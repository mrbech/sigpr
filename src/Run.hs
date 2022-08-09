module Run where

import Control.Concurrent (MVar, newEmptyMVar, putMVar, takeMVar)
import Control.Exception (finally)
import Control.Monad (void, when)
import Data.List.NonEmpty (NonEmpty (..))
import System.Posix
  ( Handler (Catch),
    ProcessGroupID,
    executeFile,
    forkProcess,
    getProcessID,
    getProcessStatus,
    installHandler,
    setProcessGroupIDOf,
    signalProcessGroup,
    softwareTermination,
    userDefinedSignal1,
  )

data Args = Args
  { printPid :: Bool,
    pidFile :: Maybe FilePath
  }
  deriving (Show, Eq)

parseArgs :: [String] -> Maybe (Args, NonEmpty String)
parseArgs = parse Args {printPid = False, pidFile = Nothing}
  where
    parse args ("--print-pid" : xs) = parse args {printPid = True} xs
    parse args ("--pid-file" : f : xs) = parse args {pidFile = Just f} xs
    parse _ ["--pid-file"] = Nothing
    parse args (x : xs) = Just (args, x :| xs)
    parse _ [] = Nothing

runCommand :: MVar () -> NonEmpty String -> IO ()
runCommand restart command = do
  pgid <- runProcess command
  takeMVar restart
    -- signal the group to ensure everything gets terminated
    `finally` signalProcessGroup softwareTermination pgid
  -- get status waits on process
  void $ getProcessStatus True True pgid
  runCommand restart command
  where
    runProcess :: NonEmpty String -> IO ProcessGroupID
    runProcess (c :| args) = forkProcess $ do
      -- we set the process group id to the parent process id
      -- this makes it possible for the parent process to use pid as pgid
      pid <- getProcessID
      setProcessGroupIDOf 0 pid
      executeFile c True args Nothing

setupHandler :: MVar () -> IO ()
setupHandler restart = do
  void $ installHandler userDefinedSignal1 (Catch handler) Nothing
  where
    handler = do
      putMVar restart ()

outputPid :: IO ()
outputPid = do
  pid <- getProcessID
  print pid

savePidFile :: Maybe FilePath -> IO ()
savePidFile (Just path) = do
  pid <- getProcessID
  writeFile path (show pid)
savePidFile Nothing = return ()

run :: Args -> NonEmpty String -> IO ()
run args command = do
  restart <- newEmptyMVar
  when (printPid args) outputPid
  savePidFile (pidFile args)
  setupHandler restart
  runCommand restart command

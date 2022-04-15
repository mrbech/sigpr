module Run where

import Control.Concurrent (MVar, newEmptyMVar, putMVar, takeMVar)
import Control.Monad (void)
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

runCommand :: MVar () -> NonEmpty String -> IO ()
runCommand restart command = do
  pgid <- runProcess command
  takeMVar restart
  -- signal the group to ensure everything gets terminated
  signalProcessGroup softwareTermination pgid
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
setupHandler restart =
  void $ installHandler userDefinedSignal1 (Catch handler) Nothing
  where
    handler = do
      putMVar restart ()

run :: NonEmpty String -> IO ()
run args = do
  restart <- newEmptyMVar
  setupHandler restart
  runCommand restart args

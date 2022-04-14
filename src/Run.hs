module Run where

import Control.Concurrent (MVar, newEmptyMVar, putMVar, takeMVar)
import Control.Monad (void)
import Data.List.NonEmpty (NonEmpty (..))
import System.Posix
  ( Handler (Catch),
    installHandler,
    userDefinedSignal1,
  )
import System.Process (cleanupProcess, createProcess, proc)

runCommand :: MVar () -> NonEmpty String -> IO ()
runCommand restart command = do
  h <- runProcess command
  takeMVar restart
  cleanupProcess h
  runCommand restart command
  where
    runProcess (c :| args) = createProcess (proc c args)

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

module Restart where

import Control.Monad (forM, forM_, when)
import Data.Char (isSpace)
import qualified Data.List as List
import Data.Maybe (catMaybes)
import qualified System.Directory as Directory
import System.Posix (ProcessID, getProcessID, signalProcess, userDefinedSignal1)
import Text.Read (readMaybe)

procDir :: [Char]
procDir = "/proc"

-- | List running processes as (command name, pid)
--
-- Note: Command name is fetched from /proc/[pid]/comm so is truncated to
-- `TASK_COMM_LEN` (16)
listProcesses :: IO [(String, ProcessID)]
listProcesses = do
  files <- Directory.listDirectory procDir
  processes <- forM files $ \p ->
    case readMaybe p of
      Nothing -> return Nothing
      Just pid -> do
        -- /proc/[pid]/comm - for program name
        let commFile = procDir ++ "/" ++ p ++ "/comm"
        hasComm <- Directory.doesFileExist commFile
        if hasComm
          then do
            comm <- readFile commFile
            return $ Just (List.dropWhileEnd isSpace comm, pid)
          else return Nothing
  return $ catMaybes processes

run :: IO ()
run = do
  currentProcessId <- getProcessID
  process <- listProcesses
  forM_ process $ \(cmd, pid) ->
    when
      (cmd == "sigpr" && pid /= currentProcessId)
      (signalProcess userDefinedSignal1 pid)

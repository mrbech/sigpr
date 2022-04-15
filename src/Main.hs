module Main where

import qualified Restart
import qualified Run
import qualified System.Environment as Environment
import qualified System.Exit as Exit

main :: IO ()
main = do
  args <- Environment.getArgs
  case args of
    "run" : as ->
      case Run.parseArgs as of
        Just a -> uncurry Run.run a
        Nothing -> Exit.die "\"sigptr run\" requires a command to run"
    ["restart"] -> Restart.run
    "restart" : _ -> Exit.die "\"sigptr restart\" takes no arguments"
    _ -> Exit.die "Unknown command\nAvailable commands: run, restart"

module Main where

import Data.List.NonEmpty (NonEmpty (..))
import qualified Restart
import qualified Run
import qualified System.Environment as Environment
import qualified System.Exit as Exit

main :: IO ()
main = do
  args <- Environment.getArgs
  case args of
    "run" : (x : xs) -> Run.run (x :| xs)
    "run" : _ -> Exit.die "\"sigptr run\" requires at least 1 argument"
    ["restart"] -> Restart.run
    "restart" : _ -> Exit.die "\"sigptr restart\" takes no arguments"
    _ -> Exit.die "Unknown command\nAvailable commands: run, restart"

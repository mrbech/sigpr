module Help where

text :: String
text =
  unlines
    [ "Usage: sigpr COMMAND",
      "version: 1.0.1",
      "",
      "A utility for running arbitrary commands on the signal \"SIGUSR1\"",
      "",
      "Commands:",
      "  run <command>    will run the given command and run/restart command on signal",
      "  restart          will signal all running sigpr processes",
      "",
      "run options:",
      "The following options can be provided to \"sigpr run <options> <command>\"",
      "options must be provided before the actual command",
      "",
      "  --print-pid               print the \"sigpr\" process id on startup",
      "  --pid-file <file path>    writes the \"sigpr\" process id to the specified file"
    ]

# Signal Program Runner (sigpr)
A utility for running arbitrary commands on the signal `SIGUSR1`.

`sigpr` is intended for running/restarting programs/tests during software
development making it easy to control when the program/tests are run.

The simplest usage is to start a command with `sigpr run <options> <command>`, it (and
any other `sigpr` instances) can then be restarted from another shell,
scripts, editor commands etc. via `sigpr restart`.

`sigpr restart` is just a convenient command that simply finds all `sigpr`
processes and signals them with `SIGUSR1`, if finer control is desired you can
make scripts that `kill -USR1 <pid>` directly.

See `sigpr help` for all options and commands.

## Installation
TODO

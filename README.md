# Signal Program Runner (sigpr)
A utility for running arbitrary commands on the signal `SIGUSR1`.

`sigpr` is intended for running/restarting programs/tests during software
development making it easy to control when the program/tests are run.

The simplest usage is to start a command with `sigpr run <options> <command>`, it (and
any other `sigpr` instances) can then be restarted from any other terminal,
scripts, editor commands etc. via `sigpr restart`.

`sigpr restart <options>` is a convenient command that simply finds `sigpr` processes and
signals them with `SIGUSR1`, if finer control is desired you can make scripts
that `kill -USR1 <pid>` directly.

## Installation
TODO

## Run command line options
** Note: options are not implemented yet **

The following options can be provided to `sigpr run <options> <command>`,
options must be provided before the actual command

- `--print-pid` print the `sigpr` process id on startup.
- `--pid-file <file name>` writes the `sigpr` process id to the specified file.
- `--name <name>` names this `sigpr` instance so `restart` can target it specifically.
- `-r` mode that takes control of terminal input, in this mode typing `r` to
  the process will trigger a restart of the command.

## Restart command line options
** Note: options are not implemented yet **

The following options can be provided to `sigpr restart <options>`

- `--name <name>` will only restart the `sigpr run --name <name>` processes.
- `--dry-run` dry run that prints which `sigpr` process that would be targeted.

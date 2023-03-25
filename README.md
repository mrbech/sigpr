# Signal Program Runner (sigpr)
A Linux utility for running arbitrary commands on the signal `SIGUSR1`.

`sigpr` is intended for running/restarting programs/tests during software
development making it easy to control when the program/tests are run.

The simplest usage is to start a command with `sigpr run <command>`, it (and
any other `sigpr` instances) can then be restarted from another shell,
scripts, editor commands etc. via `sigpr restart`.

`sigpr restart` is just a convenient command that simply finds all `sigpr`
processes and signals them with `SIGUSR1`, if finer control is desired you can
make scripts that `kill -USR1 <sigpr pid>` directly.

See `sigpr help` for all options and commands.

## Installation
Pre-built fully statically linked binaries can be found on the [release
page](https://github.com/mrbech/sigpr/releases).

Installation from source can be done with `cabal install`.

## VIM
When developing with `sigpr` and `vim` the following config can be used to execute
restarts:

```vim
" Bind <Leader>r to execute a sigpr restart
noremap <Leader>r <cmd>silent execute '!sigpr restart'<CR>

" Run sigpr restart on file write
autocmd BufWritePost * silent execute '!sigpr restart'
```

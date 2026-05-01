#!/usr/bin/zsh

# Source this file in your machine's `.zshrc` to load the functions in
# the `zsh-functions` directory. This assumes dot-files is in your $HOME.
fpath=($HOME/dot-files/zsh-functions $fpath)
autoload -Uz $fpath[1]/*(.:t)


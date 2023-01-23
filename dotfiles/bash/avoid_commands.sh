#!/bin/bash

# Commands that I don't want to use.
function avoid_command {
  echo -e "\e[31muse '\e[33m$1\e[31m' instead"
}

alias ls="avoid_command exa"
alias grep="avoid_command rg"
alias find="avoid_command fd"


#!/bin/bash

# Update the PATH to include our custom binaries.
function add_path {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]
  then
    PATH+=:$1
  fi
}

add_path ~/.local/bin

# Add cargo-specific binaries to the PATH.
source ~/.cargo/env

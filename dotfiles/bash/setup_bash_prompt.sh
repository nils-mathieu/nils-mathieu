#!/bin/bash

# Setup the custom prompt.
function bash_prompt {
  local status=$?

  # Print the last status code if it not 0.
  if [[ $status != 0 ]]
  then
    echo -e "\e[31;3merror code \e[1;31m$status\e[0m"
  fi

  # Print the current working directory.
  if git rev-parse 2> /dev/null
  then
    local pwd=$(basename $(git rev-parse --show-toplevel))"/"$(git rev-parse --show-prefix)
    pwd=${pwd%*/}

    local branch=$(git branch --show-current)

    echo -e " \e[32m(\e[92m$branch\e[32m)\e[0m \e[32m$pwd\e[0m"
  else
    echo -e " \e[34m$(dirs)\e[0m"
  fi

  # And finally, the actual prompt.
  echo " >_ "
}

PS1="\$(bash_prompt)"
PS2=" >  "
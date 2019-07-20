#!/usr/bin/env bash

rm -rf ~/.bash_sessions/*

__files=(
  ~/.bash_history
  ~/.sh_history
  ~/.zsh_history
  ~/.zhistory

  ~/.node_repl_history
  ~/.coffee_history
  ~/.python_history
  ~/.utop-history
  ~/.rtop-history

  ~/.lesshst

  ~/.mysql_history
  ~/.psql_history
  ~/.rediscli_history
)

for file in ${__files[@]}; do
  if [ -s $file ]; then
    echo "> $file"
    cp /dev/null $file
  fi
done

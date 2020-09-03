#!/usr/bin/env fish

git diff (git show :nvim/dein-rollback | jq -S . | psub) (jq -S . dein-rollback | psub)

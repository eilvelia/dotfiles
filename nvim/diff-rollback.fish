#!/usr/bin/env fish

git diff (jq -S . dein-rollback | psub) (git show :nvim/dein-rollback | jq -S . | psub)

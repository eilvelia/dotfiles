function mkcd -a name --description "mkdir and cd together!!"
  mkdir -p "$name" && cd "$name"
end

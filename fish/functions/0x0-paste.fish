function "0x0-paste" --description "Paste to 0x0.st"
  if set -q argv[1]
    set -f filename $argv[1]
  else
    set -f filename "paste.txt"
  end
  curl -F "file=@-;filename=$filename" '-Fsecret=' https://0x0.st
end

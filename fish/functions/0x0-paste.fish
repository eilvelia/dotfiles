function "0x0-paste" --description "Paste to 0x0.st"
  # Syntax:
  # 0x0-paste [-f <filename>] [<file>]
  # <file> is the file to send to 0x0.st; by default reads from stdin.
  # <filename> is the name of the file that is sent to 0x0.st; defaults either
  #            to <file> (if set) or paste.txt.
  argparse 'f=' -- $argv
  if set -q argv[1]
    set -f file $argv[1]
    set -f filename $argv[1]
  else
    set -f file "-"
    set -f filename "paste.txt"
  end
  set -q _flag_f; and set -f filename $_flag_f
  curl -F "file=@$file;filename=$filename" '-Fsecret=' https://0x0.st
end

# Partially from https://coderwall.com/p/xhiasw/easily-extract-files
function extract --description "Expand or extract bundled & compressed files"
  for file in $argv
    if test -f $file
      echo -s "Extracting " (set_color --bold blue) $file (set_color normal)
      switch $file
        case '*.tar'
          tar -xvf $file
        case '*.tar.gz' '*.tgz'
          tar -xzvf $file
        case '*.tar.bz2' '*.tbz2' '*.tbz'
          tar -xjvf $file
        case '*.tar.zst'
          tar -xv --zstd -f $file
        case '*.tar.xz'
          tar -xv --xz -f $file
        case '*.tar.*'
          tar -xvf $file
        case '*.bz2'
          bunzip2 $file
        case '*.gz'
          gunzip $file
        case '*.zip' '*.ZIP'
          unzip $file
        case '*.rar'
          unrar x $file
        case '*.pax'
          pax -r < $file
        case '*.Z'
          uncompress $file
        case '*.7z'
          7z x $file
        case '*'
          echo "Extension not recognized, cannot extract $file"
      end
    else
      echo "$file is not a valid file"
    end
  end
end

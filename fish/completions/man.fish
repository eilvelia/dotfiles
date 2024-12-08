test "$uname" != "Darwin" || exit

# Custom man completion
# From https://codeberg.org/novenary/nicks/src/commit/65d01656d316470a885499869c10b557b0646f9c/home/shell/man.fish
# by novenary (https://codeberg.org/novenary)

function _local_complete_man
  set -l --path manpath (manpath)
  # Add fish builtins
  set -p manpath $__fish_data_dir/man

  find -L $manpath/*{man,cat}*/ -mindepth 1 -maxdepth 1 -type f -printf '%f\0' \
    # Remove compression suffixes
    | sed -ze 's/\.\([glx]z\|bz2\|lzma\|Z\|zst\)$//I' \
    | string split0
end
complete -xc man -a "(_local_complete_man)"

complete -rc man -s C -d "Configuration file"
complete -xc man -s M -a "(__fish_complete_directories (commandline -ct))" -d Manpath
complete -rc man -s P -d Pager
complete -xc man -s S -d "Manual sections"
complete -c man -s a -d "Display all matches"
#complete -c man -s c -d "Always reformat"
complete -c man -s d -d Debug
complete -c man -s D -d "Default options" #"Debug and run"
#complete -c man -s f -d "Show whatis information"
#complete -c man -s F -l preformat -d "Format only"
complete -c man -s h -d "Display help and exit"
#complete -c man -s k -d "Show apropos information"
#complete -c man -s K -d "Search in all man pages"
complete -xc man -s m -d "Set system"
complete -xc man -s p -d Preprocessors
complete -c man -s t -d "Format for printing"
complete -c man -s w -l path -d "Only print locations"
#complete -c man -s W -d "Only print locations"

complete -c man -n 'string match -q -- "*/*" (commandline -t | string collect)' --force-files
if command -q man
  # We have a conditionally-defined man function,
  # so we need to check for existence here.
  if echo | MANPAGER=cat command man -l - &>/dev/null
    complete -c man -s l -l local-file -d "Local file" -r
  end
end

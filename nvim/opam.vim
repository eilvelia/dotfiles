
" 40-200 ms
let g:opam_share_dir = substitute(system("opam config var share"), '[\r\n]*$', '', '')

" TODO: Execute it only if a file with filetype=ocaml is open

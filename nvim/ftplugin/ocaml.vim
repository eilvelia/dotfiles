let no_ocaml_maps = 1

" TODO: Use `ocamllsp/switchImplIntf`?

nmap <buffer> <LocalLeader>- <Plug>OCamlSwitchEdit
nmap <buffer> <LocalLeader>_ <Plug>OCamlSwitchNewWin

" doesn't work well
" let g:ocaml_folding = 1

" setlocal foldmethod=manual
setlocal foldmethod=indent

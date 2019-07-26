let b:ale_linters = ['merlin']
let b:ale_fixers = ['ocp-indent']

" let no_ocaml_maps = 1

nmap <buffer> <LocalLeader>r <Plug>(MerlinRename)
nmap <buffer> <LocalLeader>y :MerlinYankLatestType<CR>

" nmap <silent> <buffer> <C-x> <Plug>OCamlSwitchEdit
" nmap <silent> <buffer> <A-x> <Plug>OCamlSwitchNewWin

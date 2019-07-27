let b:ale_linters = ['merlin']
let b:ale_fixers = ['ocp-indent']

nmap <buffer> <LocalLeader>r <Plug>(MerlinRename)
nmap <buffer> <LocalLeader>y :MerlinYankLatestType<CR>

nmap <silent><buffer> <LocalLeader>f :MerlinOccurrences<CR>

imap <silent><buffer> <C-t> <C-o>:MerlinTypeOf<CR>

let no_ocaml_maps = 1

nmap <buffer> <LocalLeader>s <Plug>OCamlSwitchEdit
nmap <buffer> <LocalLeader>S <Plug>OCamlSwitchNewWin
" nmap <silent> <buffer> <C-x> <Plug>OCamlSwitchEdit
" nmap <silent> <buffer> <A-x> <Plug>OCamlSwitchNewWin

let g:merlin_disable_default_keybindings = 1

map  <silent><buffer> <LocalLeader>t :MerlinTypeOf<return>
map  <silent><buffer> <LocalLeader>n :MerlinGrowEnclosing<return>
map  <silent><buffer> <LocalLeader>p :MerlinShrinkEnclosing<return>
vmap <silent><buffer> <LocalLeader>t :MerlinTypeOfSel<return>

nmap <silent><buffer> gd  :MerlinLocate<return>

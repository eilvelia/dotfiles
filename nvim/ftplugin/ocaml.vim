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

map  <silent><buffer> <LocalLeader>t :MerlinTypeOf<CR>
map  <silent><buffer> <LocalLeader>n :MerlinGrowEnclosing<CR>
map  <silent><buffer> <LocalLeader>p :MerlinShrinkEnclosing<CR>
vmap <silent><buffer> <LocalLeader>t :MerlinTypeOfSel<CR>

nmap <silent><buffer> gd :MerlinLocate<CR>

map <buffer> <LocalLeader>T :MerlinTypeOf<space>
nmap <buffer> <LocalLeader>gd :MerlinLocate<space>

map <silent><buffer> <A-;> :MerlinClearEnclosing<CR>


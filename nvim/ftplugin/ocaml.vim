let g:ale_ocaml_ols_executable = 'ocamllsp'
" let b:ale_linters = ['merlin']
" let b:ale_linters = ['ols']
let b:ale_fixers = ['ocp-indent']

let no_ocaml_maps = 1

nmap <buffer> <LocalLeader>s <Plug>OCamlSwitchEdit
nmap <buffer> <LocalLeader>S <Plug>OCamlSwitchNewWin

" doesn't work well
" let g:ocaml_folding = 1

" setlocal foldmethod=manual
setlocal foldmethod=indent

"" Merlin without LSP:

let g:merlin_disable_default_keybindings = 1

if !exists('g:ocaml_loaded') && executable('opam')
  let g:ocaml_loaded = 1

  let s:opam_share_dir =
        \ substitute(system('opam config var share'), '[\r\n]*$', '', '')

  let s:ocp_indent_dir = s:opam_share_dir . '/ocp-indent/vim'
  let s:ocp_index_dir = s:opam_share_dir . '/ocp-index/vim'
  let s:merlin_dir = s:opam_share_dir . '/merlin/vim'

  if executable('ocp-indent')
    execute 'set rtp^=' . s:ocp_indent_dir
  endif

  if executable('ocp-index')
    execute 'set rtp+=' . s:ocp_index_dir
  endif

  if executable('ocamlmerlin')
    execute 'set rtp+=' . s:merlin_dir
    execute 'helptags ' . s:merlin_dir . '/doc'
    execute 'source ' . s:merlin_dir . '/plugin/*.vim'
  endif
endif

" nmap <buffer> <LocalLeader>r <Plug>(MerlinRename)

nnoremap <buffer> <LocalLeader>y :MerlinYankLatestType<CR>

" nnoremap <silent><buffer> <LocalLeader>f :MerlinOccurrences<CR>

noremap <silent><buffer> <LocalLeader>mt :MerlinTypeOf<CR>
" noremap <silent><buffer> <LocalLeader>t :MerlinTypeOf<CR>
noremap <silent><buffer> <LocalLeader>n :MerlinGrowEnclosing<CR>
noremap <silent><buffer> <LocalLeader>p :MerlinShrinkEnclosing<CR>
vnoremap <silent><buffer> <LocalLeader>t :MerlinTypeOfSel<CR>

" nmap <silent><buffer> gd :MerlinLocate<CR>

nnoremap <buffer> <LocalLeader>T :MerlinTypeOf<Space>
nnoremap <buffer> <LocalLeader>mg :MerlinLocate<Space>

nnoremap <silent><buffer> <A-;> :MerlinClearEnclosing<CR>

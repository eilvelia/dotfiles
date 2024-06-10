" vim: foldmethod=marker

let $VIMDIR = expand('~/.config/nvim')

let g:is_gui = has('gui_running') || has('gui_vimr')
let g:is_mac = has('macunix') || has('mac')

if g:is_mac
  let g:loaded_python_provider = 0
  let g:python3_host_prog = '/usr/local/bin/python3'
endif

" Minimal mode
if !exists('g:min_mode')
  let g:min_mode = 0
endif

source $VIMDIR/options.vim

nnoremap <Space> <nop>

if has('vim_starting')
  let mapleader = "\<Space>"
  let maplocalleader = "\<Space>"
endif

lua require('config')

if g:is_mac
  " Apple ISO keyboards
  map § `
endif

nnoremap Y y$

nnoremap <BS> "_X
nnoremap <S-BS> "_x

nnoremap <Space>y "+y
nnoremap <Space>Y "+Y
nnoremap <Space>p "+p
nnoremap <Space>P "+P
vnoremap <Space>y "+y
vnoremap <Space>Y "+Y
vnoremap <Space>p "+p
vnoremap <Space>P "+P

" system register
noremap <Space>= "+

inoremap <A-BS> <C-w>
cnoremap <A-BS> <C-w>

noremap 0 ^
noremap ^ 0

noremap <Space>1 !
noremap <Space>2 @
noremap <Space>3 #
noremap <Space>4 $
noremap <Space>5 %
noremap <Space>6 0
noremap <Space>7 &
noremap <Space>8 *

nnoremap <silent> c<Tab> :let @/=expand('<cword>')<CR>cgn

" helix-style
noremap gl $
noremap gh 0
noremap gs ^

nnoremap <Space>n :normal<Space>
vnoremap <Space>n :normal<Space>

" command history
nnoremap q: <nop>
" ^ That mapping adds delay to `q` when you stop recording. v This fixes it.
nnoremap <nowait> q q
nnoremap <Space><Space>q q:

nnoremap Q <nop>

nnoremap <Space>. @:

" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" clear search selection
nnoremap <silent> <Space>c :let @/ = ''<CR>
vnoremap <silent> <Space>c <Cmd>let @/ = ''<CR>

" previous (last used) buffer
nnoremap <silent> ga :b#<CR>

" add newlines above and below
nnoremap <silent> [<Space> :call append(line('.')-1, '')<CR>
nnoremap <silent> ]<Space> :call append(line('.'), '')<CR>

" insert newline without automatic comment insertion
nnoremap <silent> <Space><CR> :put =nr2char(10)<CR>
inoremap <silent> <A-]> <Cmd>put =nr2char(10)<CR>

" remove trailing newlines from the register
nnoremap <silent> <Space><Space>n :call setreg(v:register,
      \ substitute(getreg(v:register), '\n\+$', '', 'g'))<CR>

" strip trailing whitespace
function! s:strip_trailing_whitespace() abort
  if &binary
    echoerr 'Cannot strip whitespace in a binary file.'
    return
  endif
  let old_pattern = @/
  %s/\s\+$//e
  let @/ = old_pattern
endfunction
command! StripTrailingWhitespace call <SID>strip_trailing_whitespace()

function! s:execute_vim() range
  let lines = getline(a:firstline, a:lastline)
  for line in lines
    execute line
  endfor
endfunction
command! -range ExecuteVim <line1>,<line2>call <SID>execute_vim()

" Delete [No Name] buffers
function! s:delete_unnamed_buffers() abort
  let bufs = filter(range(1, bufnr('$')), 'bufexists(v:val) && bufname(v:val) ==# ""')
  if !empty(bufs)
    " Doesn't delete buffers with unsaved changes
    execute 'bdelete' join(bufs)
  endif
endfunction
command! DeleteUnnamedBuffers call <SID>delete_unnamed_buffers()

" function! s:delete_nearest_line(above) abort
"   let save_col = col('.')
"   let curline = line('.')
"   if a:above && curline != 1
"     -d
"     call cursor(curline - 1, save_col)
"   elseif curline != line('$')
"     +d
"     call cursor(curline, save_col)
"   endif
" endfunction

" Window mappings {{{

nmap <Space>w <C-w>

nnoremap <C-w><S-Left> <C-w>H
nnoremap <C-w><S-Right> <C-w>L
nnoremap <C-w><S-Up> <C-w>K
nnoremap <C-w><S-Down> <C-w>J

nnoremap <A-Left> <C-w><Left>
nnoremap <A-Right> <C-w><Right>
nnoremap <A-Up> <C-w><Up>
nnoremap <A-Down> <C-w><Down>

nnoremap <A-S-Left> <C-w>H
nnoremap <A-S-Right> <C-w>L
nnoremap <A-S-Up> <C-w>K
nnoremap <A-S-Down> <C-w>J

nnoremap <A-h> <C-w><Left>
nnoremap <A-l> <C-w><Right>
nnoremap <A-k> <C-w><Up>
nnoremap <A-j> <C-w><Down>

nnoremap <A-S-h> <C-w>H
nnoremap <A-S-l> <C-w>L
nnoremap <A-S-k> <C-w>K
nnoremap <A-S-j> <C-w>J

" to tab
nnoremap <A-t> <C-w>T

" change height
nnoremap <A--> <C-w>-
nnoremap <A-=> <C-w>+

" change width
nnoremap <A-.> <C-w>>
nnoremap <A-,> <C-w><

" }}}

" Terminal mappings {{{

tnoremap <C-.> <C-\><C-n>

" tnoremap <A-Left> <C-\><C-n><C-w>h
" tnoremap <A-Right> <C-\><C-n><C-w>l
" tnoremap <A-Up> <C-\><C-n><C-w>k
" tnoremap <A-Down> <C-\><C-n><C-w>j

" }}}

command! -count EditReg call edit_reg#start()
nnoremap <Space><Space>e :EditReg<CR>

command! SyntaxAttr call syntax_attr#main()
nnoremap <Space><Space>a :SyntaxAttr<CR>

nnoremap <Space><Space>w :setlocal wrap!<CR>:setlocal wrap?<CR>

nnoremap <Space><Space>s     :set expandtab   tabstop=2 shiftwidth=2 softtabstop=0<CR>
nnoremap <Space><Space>S     :set expandtab   tabstop=4 shiftwidth=4 softtabstop=0<CR>
nnoremap <Space><Space>t     :set noexpandtab tabstop=2 shiftwidth=2 softtabstop=0<CR>
nnoremap <Space><Space>T     :set noexpandtab tabstop=4 shiftwidth=4 softtabstop=0<CR>
nnoremap <Space><Space><A-t> :set noexpandtab tabstop=8 shiftwidth=8 softtabstop=0<CR>

nnoremap <silent> <A-[> :-tabmove<CR>
nnoremap <silent> <A-]> :+tabmove<CR>

" select tab by g1..g9
nnoremap <silent> g1 :tabn 1<CR>
nnoremap <silent> g2 :tabn 2<CR>
nnoremap <silent> g3 :tabn 3<CR>
nnoremap <silent> g4 :tabn 4<CR>
nnoremap <silent> g5 :tabn 5<CR>
nnoremap <silent> g6 :tabn 6<CR>
nnoremap <silent> g7 :tabn 7<CR>
nnoremap <silent> g8 :tabn 8<CR>
nnoremap <silent> g9 :tabn 9<CR>

if g:is_gui
  nnoremap <silent> <C-Tab> :tabn<CR>
  inoremap <silent> <C-Tab> <Esc>:tabn<CR>
  vnoremap <silent> <C-Tab> <Esc>:tabn<CR>
  nnoremap <silent> <C-S-Tab> :tabp<CR>
  inoremap <silent> <C-S-Tab> <Esc>:tabp<CR>
  vnoremap <silent> <C-S-Tab> <Esc>:tabp<CR>
endif

if g:is_mac && g:is_gui
  nnoremap <silent> <D-A-Right> :tabn<CR>
  inoremap <silent> <D-A-Right> <Esc>:tabn<CR>
  vnoremap <silent> <D-A-Right> <Esc>:tabn<CR>
  nnoremap <silent> <D-A-Left> :tabp<CR>
  inoremap <silent> <D-A-Left> <Esc>:tabp<CR>
  vnoremap <silent> <D-A-Left> <Esc>:tabp<CR>

  " select tab by cmd+1..cmd+9
  for i in range(1, 9)
    execute "nnoremap <silent> <D-" . i . "> :tabn " . i . "<CR>"
    execute "inoremap <silent> <D-" . i . "> <Cmd>tabn " . i . "<CR>"
  endfor

  nnoremap <D-Left> ^
  inoremap <D-Left> <Cmd>normal! ^<CR>
  vnoremap <D-Left> ^
  nnoremap <D-Right> g_
  inoremap <D-Right> <End>
  vnoremap <D-Right> g_
  nnoremap <D-Up> gg
  inoremap <D-Up> <C-Home>
  vnoremap <D-Up> gg
  nnoremap <D-Down> G
  inoremap <D-Down> <C-End>
  vnoremap <D-Down> G

  nnoremap <D-BS> v0d

  nnoremap <D-]> >>
  inoremap <D-]> <C-t>
  vnoremap <D-]> >
  nnoremap <D-[> <<
  inoremap <D-[> <C-d>
  vnoremap <D-[> <

  " duplicate current line
  nnoremap <silent> <D-S-d> :t.<CR>
  inoremap <silent> <D-S-d> <Cmd>t.<CR>

  nnoremap <D-f> /
  vnoremap <D-f> /
  nnoremap <D-S-f> ?
  vnoremap <D-S-f> ?
  " cnoremap <D-f> <CR>

  inoremap <D-y> <C-y>
endif

source $VIMDIR/vault.vim
source $VIMDIR/useful-text-objects.vim

if !g:min_mode
  set exrc
  set secure
endif

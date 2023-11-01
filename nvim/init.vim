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

" Arrow keys are bound to ijkl system-wide
noremap h <nop>
noremap j <nop>
nmap k <C-w>
noremap l <nop>

nnoremap <Space> <nop>

if has('vim_starting')
  let mapleader = "j"
  let maplocalleader = "\<Space>"
endif

lua require('config')

" " vim-surround {{{
" let g:surround_no_mappings = 1
" nmap ds  <Plug>Dsurround
" nmap cs  <Plug>Csurround
" nmap cS  <Plug>CSurround
" nmap ys  <Plug>Ysurround
" nmap yS  <Plug>YSurround
" nmap yss <Plug>Yssurround
" nmap ySs <Plug>YSsurround
" nmap ySS <Plug>YSsurround
" " xmap S   <Plug>VSurround
" xmap gS  <Plug>VgSurround
" " if !hasmapto("<Plug>Isurround", "i") && "" == mapcheck("<C-S>", "i")
" "   imap <C-S> <Plug>Isurround
" " endif
" " imap <C-G>s <Plug>Isurround
" " imap <C-G>S <Plug>ISurround

" xmap <Leader>s <Plug>VSurround
" " }}}

if g:is_mac
  " Apple ISO keyboards
  map § `
endif

noremap <Leader>k `
noremap <C-w>j `

nnoremap Y y$

nnoremap <BS> "_X
nnoremap <S-BS> "_x

" inoremap <C-.> <Esc>

" system register
noremap <Leader>a "+

nnoremap <LocalLeader>y "+y
nnoremap <LocalLeader>Y "+Y
nnoremap <LocalLeader>p "+p
nnoremap <LocalLeader>P "+P
vnoremap <LocalLeader>y "+y
vnoremap <LocalLeader>Y "+Y
vnoremap <LocalLeader>p "+p
vnoremap <LocalLeader>P "+P

map h "

inoremap <A-BS> <C-w>
cnoremap <A-BS> <C-w>

nnoremap <Leader>v <C-v>
vnoremap <Leader>v <C-v>

noremap 0 ^
noremap ^ 0

noremap <Leader>1 !
noremap <Leader>2 @
noremap <Leader>3 #
noremap <Leader>4 $
noremap <Leader>5 %
noremap <Leader>6 0
noremap <Leader>7 &
noremap <Leader>8 *

nnoremap <silent> c<Tab> :let @/=expand('<cword>')<CR>cgn

nnoremap <Leader>w :w<CR>

" TODO: consider gs + gl (helix)?
" noremap ls ^
" noremap le $
noremap ls ^
noremap lf $
noremap lw b
noremap lW B
noremap le ge
noremap lE gE

nnoremap <Leader>n :normal<Space>
vnoremap <Leader>n :normal<Space>

" command history
nnoremap q: <nop>
" ^ That mapping adds delay to `q` when you stop recording. v This fixes it.
nnoremap <nowait> q q
nnoremap <Leader><Leader>q q:

" ex mode, alternative mapping: gQ
nnoremap Q <nop>

nnoremap <Leader>. @:

" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" clear search selection
nnoremap <silent> <Leader>g :let @/ = ''<CR>
vnoremap <silent> <Leader>g <Cmd>let @/ = ''<CR>

" previous buffer
nnoremap <silent> <Leader>s :b#<CR>

" duplicate current line
" nnoremap <silent> <Leader><Leader>d :t.<CR>
nnoremap <silent> <Leader>c :t.<CR>
" (c - clone)

" add newlines above and below
nnoremap <silent> [<Space> :call append(line('.')-1, '')<CR>
nnoremap <silent> ]<Space> :call append(line('.'), '')<CR>

" insert newline without automatic comment insertion
nnoremap <silent> <Space><CR> :put =nr2char(10)<CR>
inoremap <silent> <A-]> <Cmd>put =nr2char(10)<CR>

" remove trailing newlines from the register
nnoremap <silent> <Leader><Leader>n :call setreg(v:register,
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

nnoremap <silent> <Leader><Leader>w :StripTrailingWhitespace<CR>

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

" location list
nnoremap <silent> <Leader>l :lopen<CR>
nnoremap <silent> <Leader>L :lclose<CR>
nnoremap <silent> <Leader><Leader>l :ll<CR>
" [l / ]l / [<C-l> / ]<C-l> from unimpaired are useful

" quickfix list
nnoremap <silent> <Leader>q :copen<CR>
nnoremap <silent> <Leader>Q :cclose<CR>
nnoremap <silent> <Leader><Leader>c :cc<CR>
" [q / ]q / [<C-q> / ]<C-q> from unimpaired are useful

" Window mappings {{{

nnoremap <C-w><S-Left> <C-w>H
nnoremap <C-w><S-Right> <C-w>L
nnoremap <C-w><S-Up> <C-w>K
nnoremap <C-w><S-Down> <C-w>J

nnoremap <C-w>h <nop>
" nnoremap <C-w>j <nop>
nnoremap <C-w>k <nop>
nnoremap <C-w>l <nop>

nnoremap <C-w>H <nop>
nnoremap <C-w>J <nop>
nnoremap <C-w>K <nop>
nnoremap <C-w>L <nop>

nnoremap <A-Left> <C-w><Left>
nnoremap <A-Right> <C-w><Right>
nnoremap <A-Up> <C-w><Up>
nnoremap <A-Down> <C-w><Down>

nnoremap <A-S-Left> <C-w>H
nnoremap <A-S-Right> <C-w>L
nnoremap <A-S-Up> <C-w>K
nnoremap <A-S-Down> <C-w>J

nnoremap <A-j> <C-w><Left>
nnoremap <A-l> <C-w><Right>
nnoremap <A-i> <C-w><Up>
nnoremap <A-k> <C-w><Down>

nnoremap <A-S-j> <C-w>H
nnoremap <A-S-l> <C-w>L
nnoremap <A-S-i> <C-w>K
nnoremap <A-S-k> <C-w>J

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
nnoremap <Leader>e :EditReg<CR>

command! SyntaxAttr call syntax_attr#main()
nnoremap <Leader><Leader>a :SyntaxAttr<CR>

nnoremap <Leader><Leader><Leader>w :setlocal wrap!<CR>:setlocal wrap?<CR>

nnoremap <Leader><Leader><Leader>s     :set expandtab   tabstop=2 shiftwidth=2 softtabstop=0<CR>
nnoremap <Leader><Leader><Leader>S     :set expandtab   tabstop=4 shiftwidth=4 softtabstop=0<CR>
nnoremap <Leader><Leader><Leader>t     :set noexpandtab tabstop=2 shiftwidth=2 softtabstop=0<CR>
nnoremap <Leader><Leader><Leader>T     :set noexpandtab tabstop=4 shiftwidth=4 softtabstop=0<CR>
nnoremap <Leader><Leader><Leader><A-t> :set noexpandtab tabstop=8 shiftwidth=8 softtabstop=0<CR>

nnoremap <silent> <A-[> :-tabmove<CR>
nnoremap <silent> <A-]> :+tabmove<CR>

" select tab by g1..g9
for i in range(1, 9)
  execute "nnoremap <silent> g" . i . " :tabn " . i . "<CR>"
endfor

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

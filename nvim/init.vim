set nocompatible

let g:is_gui = has('gui_running') || has('gui_vimr')
let g:is_mac = has('macunix') || has('mac')

let mapleader = ","

call plug#begin('~/.config/nvim/Plugged')

if is_mac
  Plug '/usr/local/opt/fzf'
else
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
endif
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'jreybert/vimagit'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-commentary'
Plug 'junegunn/vim-easy-align'
Plug 'easymotion/vim-easymotion'
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
Plug 'itchyny/vim-parenmatch'
Plug 'junegunn/vim-peekaboo'
Plug 'itchyny/vim-cursorword'
Plug 'brooth/far.vim'
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'dhruvasagar/vim-open-url', {
      \'commit': '595f964eca353f6cc158f953d879dda55e45370b' }
" Plug 'vim-syntastic/syntastic'
Plug 'w0rp/ale'
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'copy/deoplete-ocaml'
" Plug 'carlosrocha/vim-flow-plus', { 'for': 'javascript',
"       \'commit': 'a7c940b15b008afdcea096d3fc4d25e3e431eb49' }
Plug 'rgrinberg/vim-ocaml'
Plug 'joshdick/onedark.vim'

call plug#end()

runtime! ocaml.vim

" remove newline from register
nnoremap <silent> <Leader>n :call setreg(v:register,
      \substitute(getreg(v:register), '\n$', '', 'g'))<CR>

" fzf - Fuzzy find
" let $FZF_DEFAULT_OPTS .= ' --inline-info'
let $FZF_DEFAULT_COMMAND = 'fd --type f --hidden --exclude .git'
if is_mac && is_gui
  nnoremap <D-p> :FZF<CR>
  inoremap <D-p> <C-o>:FZF<CR>
  vnoremap <D-p> <ESC>:FZF<CR>
  nnoremap <D-S-p> :Buffers<CR>
  inoremap <D-S-p> <C-o>:Buffers<CR>
  nnoremap <D-A-p> :GFiles<CR>
  nnoremap <D-A-S-p> :GFiles?<CR>
endif
nnoremap <C-p> :FZF<CR>
nnoremap <Leader>l :Lines<CR>
nnoremap <Leader>L :BLines<CR>
nnoremap <Leader>rg :Rg <C-r><C-w><CR>
nnoremap <Leader>RG :Rg <C-r><C-r><CR>
vnoremap <Leader>rg y:Rg <C-r>"<CR>
nnoremap <Leader>ag :Ag <C-r><C-w><CR>
vmap <Leader>f <Leader>rg
nnoremap <Leader>` :Marks<CR>
nnoremap <Leader>§ :Marks<CR>
" imap <C-x><C-k> <Plug>(fzf-complete-word)
imap <C-x><C-f> <Plug>(fzf-complete-path)
imap <C-x><C-j> <Plug>(fzf-complete-file-ag)
imap <C-x><C-l> <Plug>(fzf-complete-line)

" airline
if is_gui
  let g:airline_theme = 'onedark'
else
  let g:airline_theme = 'powerlineish'
endif
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#ale#enabled = 1
" let g:airline#extensions#tagbar#enabled = 1
" let g:airline_skip_empty_sections = 1

" gitgutter
highlight link GitGutterAdd DiffAdd
highlight link GitGutterChange DiffChange
highlight link GitGutterDelete DiffDelete

" commentary
" if is_mac
"   " cmd+/
"   nnoremap <D-/> gcc inoremap <D-/> <C-o>gcc
"   vnoremap <D-/> gc
"   nnoremap <D-_> gcc
"   inoremap <D-_> <C-o>gcc
"   vnoremap <D-_> gc
" endif

" vim-easy-align
nmap ga <Plug>(EasyAlign)
vmap ga <Plug>(EasyAlign)

" vim-easymotion
let g:EasyMotion_smartcase = 1
nmap s <Plug>(easymotion-s)
vmap s <Plug>(easymotion-s)
nmap t <Plug>(easymotion-t)
vmap t <Plug>(easymotion-t)

" vim-open-url
" (default is gB)
nmap <Leader>o <Plug>(open-url-browser)
" open on GitHub
vnoremap <Leader>gh y:OpenURL https://github.com/<C-r>"<CR>

" syntastic
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 0
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0
" let g:syntastic_error_symbol = '✗'
" let g:syntastic_style_error_symbol = 'S✗'
" let g:syntastic_warning_symbol = '!'
" let g:syntastic_style_warning_symbol = 'S!'
" if is_gui
"   let g:syntastic_full_redraws = 0
" endif
" " let g:syntastic_ocaml_checkers = ['merlin']

" ale
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '!'
let g:ale_sign_info = 'i'
let g:ale_set_balloons = 0
let g:ale_linters = {
      \'javascript': ['flow-language-server'],
      \'ocaml': ['merlin'],
      \}
let g:ale_fixers = {
      \'ocaml': ['ocp-indent'],
      \}

" deoplete
" let g:deoplete#enable_at_startup = 1

" insert char
nnoremap <Leader>i i_<Esc>r
nnoremap <Leader>I a_<Esc>r

nnoremap <silent> <BS> "_X
nnoremap <silent> <S-BS> "_x

vnoremap <silent> // y/<C-R>"<CR>

" nnoremap Y y$

inoremap <silent> <C-.> <Esc>

" remove trailing whitespace
nnoremap <Leader>W :%s/\s\+$//<CR>:let @/=''<CR>

" C-;
nnoremap <silent> <C-;> :let @/=''<CR>

nnoremap <silent> <C-\> :b#<CR>

noremap ' `
noremap ` '

" duplicate line
nnoremap <silent> <Leader>d mmyyp`mj
" inoremap <silent> <Leader>d <Esc>mmyyp`mja
" vnoremap <silent> <Leader>d y'>p`

nnoremap <silent> <Leader>q :lopen<CR>
nnoremap <silent> <Leader>Q :lclose<CR>

nnoremap \w :setlocal wrap!<CR>:setlocal wrap?<CR>

nnoremap \m :set expandtab tabstop=2 shiftwidth=2 softtabstop=2<CR>
nnoremap \M :set expandtab tabstop=4 shiftwidth=4 softtabstop=4<CR>
nnoremap \t :set noexpandtab tabstop=2 shiftwidth=2 softtabstop=2<CR>
nnoremap \T :set noexpandtab tabstop=4 shiftwidth=4 softtabstop=4<CR>

if is_mac && is_gui
  nnoremap <silent> <D-A-Left> :tabp<CR>
  inoremap <silent> <D-A-Left> <C-o>:tabp<CR>
  vnoremap <silent> <D-A-Left> <ESC>:tabp<CR>
  nnoremap <silent> <D-A-Right> :tabn<CR>
  inoremap <silent> <D-A-Right> <C-o>:tabn<CR>
  vnoremap <silent> <D-A-Right> <ESC>:tabn<CR>

  let n = 1
  while n <= 9
    execute "nnoremap <silent> <D-" . n . "> :tabn " . n . "<CR>"
    execute "inoremap <silent> <D-" . n  . "> <C-o>:tabn " . n . "<CR>"
    let n += 1
  endwhile

  nnoremap <silent> <D-Left> ^
  inoremap <silent> <D-Left> <C-o>^
  vnoremap <silent> <D-Left> ^
  nnoremap <silent> <D-Right> g_
  inoremap <silent> <D-Right> <C-o>$
  vnoremap <silent> <D-Right> g_
  nnoremap <silent> <D-Up> gg
  inoremap <silent> <D-Up> <C-o>gg
  vnoremap <silent> <D-Up> gg
  nnoremap <silent> <D-Down> G
  inoremap <silent> <D-Down> <C-o>G
  vnoremap <silent> <D-Down> G

  nnoremap <silent> <D-]> >>
  inoremap <silent> <D-]> <C-t>
  vnoremap <silent> <D-]> >
  nnoremap <silent> <D-[> <<
  inoremap <silent> <D-[> <C-d>
  vnoremap <silent> <D-[> <

  nnoremap <silent> <D-A-Down> mm:m +1<CR>`m
  nnoremap <silent> <D-A-Up> mm:m -2<CR>`m
  inoremap <silent> <D-A-Down> <Esc>mm:m +1<CR>`ma
  inoremap <silent> <D-A-Up> <Esc>mm:m -2<CR>`ma
  vnoremap <silent> <D-A-Down> :m '>+1<CR>
  vnoremap <silent> <D-A-Up> :m '<-2<CR>

  nmap <D-S-d> <Leader>d
  inoremap <D-S-d> <Esc>mmyyp`mja
  " vmap <D-S-d> <Leader>d

  " select word
  nnoremap <silent> <D-d> viw
  vnoremap <silent> <D-d> iw
endif

" disable automatic comment insertion
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

runtime! vault.vim

set foldmethod=syntax

set ssop-=options

set signcolumn=yes

" set title

set hidden

set number
set relativenumber
set wrap
set showbreak=+++
set showmatch
set visualbell

set hlsearch
set smartcase
set ignorecase
set incsearch

set tabstop=2
set softtabstop=2
set shiftwidth=2
set smarttab
set expandtab
set autoindent

set ruler
set whichwrap+=<,>,[,]
set backspace=indent,eol,start

set wildmode=longest,list

set cc=80

" set cursorline

set list
set lazyredraw

set tagcase=smart

set updatetime=300

syntax on

if is_gui
  colorscheme onedark
endif

set exrc
set secure

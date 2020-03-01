" vim: foldmethod=marker

if has('vim_starting')
  set nocompatible

  let mapleader = ","
  let maplocalleader = "\<Space>"
endif

let $VIMDIR = expand('~/.config/nvim')

let g:is_gui = has('gui_running') || has('gui_vimr')
let g:is_mac = has('macunix') || has('mac')

if is_mac
  let g:python_host_prog = '/usr/local/bin/python2'
  let g:python3_host_prog = '/usr/local/bin/python3'
endif

let s:dein_cache_path = expand('~/.cache/dein')
let s:dein_dir = s:dein_cache_path . '/repos/github.com/Shougo/dein.vim'
let s:dein_toml = expand('~/.config/nvim/dein.toml')

if &runtimepath !~ '/dein.vim'
  if !isdirectory(s:dein_dir) && has('vim_starting')
    echomsg 'Installing dein.vim...'
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
  endif
  execute 'set runtimepath+=' . fnamemodify(s:dein_dir, ':p')
endif

if dein#load_state(s:dein_cache_path)
  call dein#begin(s:dein_cache_path, [$MYVIMRC, s:dein_toml])

  call dein#add(s:dein_dir)

  call dein#load_toml(s:dein_toml)

  call dein#end()
  call dein#save_state()
endif

if !has('vim_starting')
  call dein#call_hook('source')
  call dein#call_hook('post_source')
end

command! DeinInstall call dein#install()
command! DeinUpdate call dein#update()
command! DeinRecache call dein#recache_runtimepath()

command! DeinShowDisabledPlugins echo dein#check_clean()

function! s:DeinRemoveDisabledPlugins()
  call map(dein#check_clean(), "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
endfunction
command! DeinRemoveDisabledPlugins call <SID>RemoveDisabledDeinPlugins()

command! -nargs=1 DeinSaveRollback call dein#save_rollback('<args>')

" Plugin settings {{{

" fzf {{{
"let $FZF_DEFAULT_OPTS .= ' --inline-info'
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
" nnoremap <Leader>ag :Ag <C-r><C-w><CR>
" vmap <Leader>f <Leader>rg
nnoremap <Leader>` :Marks<CR>
nnoremap <Leader>§ :Marks<CR>
" imap <C-x><C-k> <Plug>(fzf-complete-word)
imap <C-x><C-f> <Plug>(fzf-complete-path)
imap <C-x><C-j> <Plug>(fzf-complete-file-ag)
imap <C-x><C-l> <Plug>(fzf-complete-line)
" }}}

" vim-devicons {{{
if !is_gui
  let g:loaded_webdevicons = 1
endif
" }}}

" nerdtree {{{
nnoremap <Leader>f :NERDTreeToggle<CR>
nnoremap <Leader>F :NERDTreeToggleVCS<CR>
let NERDTreeMinimalUI = 1
let NERDTreeShowHidden = 1
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeIgnore = ['^\.git$[[dir]]', '^\.DS_Store$', '\~$']
" }}}

" nerdtree-git-plugin {{{
"let g:NERDTreeShowGitStatus = 0
let g:NERDTreeShowIgnoredStatus = 1
" (Changed the 'Dirty' character from ✗ to ✹)
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✹",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }
" Vim-devicons and nerdtree-git-plugin are conflicting here a bit.
" Highlighting of the indicators doesn't work properly with devicons' conceal.
let g:webdevicons_conceal_nerdtree_brackets = 0
" }}}

" airline {{{
if is_gui
  " let g:airline_theme = 'onedark_modified'
  " let g:airline_theme = 'gruvbox'
  " let g:airline_theme = 'violet'
  let g:airline_theme = 'srcery'
  let g:airline_powerline_fonts = 1
else
  let g:airline_theme = 'powerlineish'
endif
let g:airline#parts#ffenc#skip_expected_string = 'utf-8[unix]'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#coc#enabled = 1
" let g:airline#extensions#vista#enabled = 1
" let g:airline_skip_empty_sections = 1
" }}}

" commentary {{{
if is_mac && is_gui
  nmap <D-/> gcc
  imap <D-/> <C-o>gcc
  vmap <D-/> gc
endif
" }}}

" vim-easy-align {{{
nmap ga <Plug>(EasyAlign)
vmap ga <Plug>(EasyAlign)
" }}}

" " vim-easymotion {{{
" let g:EasyMotion_smartcase = 1
" nmap s <Plug>(easymotion-s2)
" nmap S <Plug>(easymotion-s)
" vmap <Leader>s <Plug>(easymotion-s2)
" vmap <Leader>S <Plug>(easymotion-s)
" vmap s <Plug>(easymotion-s2)
" imap <C-s> <C-o><Plug>(easymotion-s2)
" nmap f <Plug>(easymotion-fl)
" nmap F <Plug>(easymotion-Fl)
" vmap f <Plug>(easymotion-fl)
" vmap F <Plug>(easymotion-Fl)
" nmap <A-f> <Plug>(easymotion-f)
" nmap <A-F> <Plug>(easymotion-F)
" vmap <A-f> <Plug>(easymotion-f)
" vmap <A-F> <Plug>(easymotion-F)
" nnoremap <Leader><A-f> f
" nnoremap <Leader><A-F> F
" " }}}

" vim-sneak {{{
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1
" }}}

" vim-open-url {{{
" (default is gB)
nmap <Leader>o <Plug>(open-url-browser)
" open on GitHub
vnoremap <Leader>gh y:OpenURL https://github.com/<C-r>"<CR>
" }}}

" vim-slime {{{
let g:slime_target = 'neovim'
function! s:SlimeSetJobId()
  let g:slime_default_config = { "jobid": b:terminal_job_id }
  let g:slime_dont_ask_default = 1
endfunction
command! SlimeSetJobId call <SID>SlimeSetJobId()
" a - activate
nnoremap <C-c>a :SlimeSetJobId<CR>
" }}}

" " syntastic {{{
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
" " }}}

" ale {{{
let g:ale_virtualtext_cursor = 1
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '!'
let g:ale_sign_info = 'i'
let g:ale_set_balloons = 0
nmap <Leader>af <Plug>(ale_fix)
" nmap <Leader>al <Plug>(ale_lint)
" nmap <Leader>ad <Plug>(ale_detail)
" nmap <Leader>ah <Plug>(ale_hover)
" nmap <Leader>ar <Plug>(ale_find_references)
" nmap <Leader>agd <Plug>(ale_go_to_definition_in_split)
" nmap <Leader>agD <Plug>(ale_go_to_definition)
" nmap gd <Plug>(ale_go_to_definition_in_split)
" nmap gD <Plug>(ale_go_to_definition)
" nmap <LocalLeader>t <Plug>(ale_hover)
" imap <C-t> <Plug>(ale_hover)
" nmap <LocalLeader>f <Plug>(ale_find_references)
" nmap <Leader>a, <Plug>(ale_next_wrap)
" nmap <Leader>a. <Plug>(ale_previous_wrap)
let g:ale_linters = {}
let g:ale_linters_explicit = 1
let g:ale_disable_lsp = 1
" }}}

" " deoplete {{{
" let g:deoplete#enable_at_startup = 1
" " }}}

" coc.nvim {{{
nnoremap <silent> <LocalLeader>ct :call CocAction('doHover')<CR>
nnoremap <silent> <LocalLeader>t :call CocAction('doHover')<CR>
nmap <silent> cgd <Plug>(coc-definition)
nmap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gD :call CocAction('jumpDefinition', 'split')<CR>
nmap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gY :call CocAction('jumpTypeDefinition', 'split')<CR>
nmap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gI :call CocAction('jumpImplementation', 'split')<CR>
nmap <silent> <LocalLeader>cf <Plug>(coc-references)
nmap <silent> <LocalLeader>f <Plug>(coc-references)
nmap <silent> <LocalLeader>cr <Plug>(coc-rename)
nmap <silent> <LocalLeader>r <Plug>(coc-rename)
nmap <LocalLeader>ca <Plug>(coc-codeaction)
vmap <LocalLeader>ca <Plug>(coc-codeaction-selected)
nmap <LocalLeader>qf <Plug>(coc-fix-current)
nnoremap <silent> <LocalLeader>chi :call CocActionAsync('highlight')<CR>
nnoremap <silent> <LocalLeader>hi :call CocActionAsync('highlight')<CR>
vmap <LocalLeader>cxf <Plug>(coc-format-selected)
nmap <LocalLeader>cxf <Plug>(coc-format-selected)

" > Requires 'textDocument/selectionRange' support from the language server
nmap <silent> <LocalLeader>cv <Plug>(coc-range-select)
nmap <silent> <LocalLeader>v <Plug>(coc-range-select)
vmap <silent> <LocalLeader>cv <Plug>(coc-range-select)
vmap <silent> <LocalLeader>v <Plug>(coc-range-select)

nnoremap <silent> <LocalLeader>cc :CocList commands<CR>
nnoremap <silent> <LocalLeader>co :CocList outline<CR>
nnoremap <silent> <LocalLeader>o :CocList outline<CR>
nnoremap <silent> <LocalLeader>cs :CocList -I symbols<CR>
nnoremap <silent> <LocalLeader>s :CocList -I symbols<CR>
nnoremap <silent> <LocalLeader>cp :CocListResume<CR>
nnoremap <silent> <LocalLeader>cj :CocNext<CR>
nnoremap <silent> <LocalLeader>ck :CocPrev<CR>

" > Introduce function text object
" > Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

command! Format call CocAction('format')
command! Fold call CocAction('fold', <f-args>)
command! OrganizeImports call CocAction('runCommand', 'editor.action.organizeImport')
" }}}

" " echodoc {{{
" let g:echodoc#enable_at_startup = 1
" let g:echodoc#type = 'floating'
" " }}}

" vista.vim {{{
if g:is_gui
  let g:vista#renderer#enable_icon = 1
endif
let g:vista_default_executive = 'coc'
let g:vista_finder_alternative_executives = []
nnoremap <LocalLeader>v :Vista finder<CR>
" }}}

" vim-indent-guides {{{
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
" }}}

" vim-javascript {{{
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1
" }}}

" vim-move {{{
let g:move_map_keys = 0
vmap <Leader><A-j> <Plug>MoveBlockDown
vmap <Leader><A-k> <Plug>MoveBlockUp
vmap <Leader><A-h> <Plug>MoveBlockLeft
vmap <Leader><A-l> <Plug>MoveBlockRight
nmap <Leader><A-j> <Plug>MoveLineDown
nmap <Leader><A-k> <Plug>MoveLineUp
if is_mac && is_gui
  nmap <D-A-Down> <Plug>MoveLineDown
  nmap <D-A-Up> <Plug>MoveLineUp
  vmap <D-A-Down> <Plug>MoveBlockDown
  vmap <D-A-Up> <Plug>MoveBlockUp
  vmap <D-A-Left> <Plug>MoveBlockLeft
  vmap <D-A-Right> <Plug>MoveBlockRight
endif
" }}}

" vim-choosewin {{{
nmap - <Plug>(choosewin)
" }}}

" }}}

nnoremap <Space> <NOP>

nnoremap ' `
nnoremap ` '

nnoremap Y y$

" builtin 'goto local declaration' and 'goto global declaration'
nnoremap <C-g>d gd
nnoremap <C-g>D gD

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"

" remove trailing newlines from the register
nnoremap <silent> <Leader>n :call setreg(v:register,
      \ substitute(getreg(v:register), '\n\+$', '', 'g'))<CR>

" insert a new character
nnoremap <Leader>i i_<Esc>r
nnoremap <Leader>I a_<Esc>r

" delete a character on Backspace without changing registers
nnoremap <silent> <BS> "_X
nnoremap <silent> <S-BS> "_x

" search the selected text
vnoremap <silent> // y/<C-R>"<CR>

inoremap <silent> <C-.> <Esc>

" command history
nnoremap q: <NOP>
nnoremap <Leader><Leader>q: q:

" ex mode
nnoremap Q <NOP>
nnoremap <Leader><Leader><C-q>Q Q

" strip trailing whitespace
function! s:StripTrailingWhitespace()
  if &binary
    echoerr 'Cannot strip whitespace in a binary file.'
    return
  endif
  let old_pattern = @/
  %s/\s\+$//e
  let @/ = old_pattern
endfunction
command! StripTrailingWhitespace call <SID>StripTrailingWhitespace()
nnoremap <silent> <Leader><C-w> :StripTrailingWhitespace<CR>

nnoremap <silent> <C-;> :let @/ = ''<CR>
inoremap <silent> <C-;> <C-o>:let @/ = ''<CR>

" previous buffer
nnoremap <silent> <C-\> :b#<CR>

" duplicate the line
nnoremap <silent> <Leader>d :t.<CR>

" location list
nnoremap <silent> <A-l> :lopen<CR>
nnoremap <silent> <A-L> :lclose<CR>
nnoremap <silent> <C-l> :ll<CR>

" quickfix list
nnoremap <silent> <A-q> :copen<CR>
nnoremap <silent> <A-Q> :cclose<CR>
nnoremap <silent> Q :cc<CR>

" Window mappings {{{

nnoremap <A-Left> <C-w><Left>
nnoremap <A-Right> <C-w><Right>
nnoremap <A-Up> <C-w><Up>
nnoremap <A-Down> <C-w><Down>

nnoremap <A-S-Left> <C-w>H
nnoremap <A-S-Right> <C-w>L
nnoremap <A-S-Up> <C-w>K
nnoremap <A-S-Down> <C-w>J

" close the other windows
nnoremap <A-o> <C-w>o

" to tab
nnoremap <A-t> <C-w>T

" close
nnoremap <A-c> <C-w>c

" previous window
nnoremap <A-p> <C-w>p

" preview window
nnoremap <A-S-p> <C-w>P

" height
nnoremap <A--> <C-w>-
nnoremap <A-=> <C-w>+
" width
nnoremap <A-.> <C-w>>
nnoremap <A-,> <C-w><

" equal height and width
nnoremap <C-A-=> <C-w>=

" " height: maximize
" nnoremap <C-A--> <C-w>_
" " width: maximize
" nnoremap <C-A-\> <C-w>|

" }}}

" Terminal mappings {{{

tnoremap <expr> <Esc> &filetype == 'fzf' ? "\<Esc>" : "\<C-\>\<C-n>"
" tnoremap <A-Left> <C-\><C-N><C-w>h
" tnoremap <A-Right> <C-\><C-N><C-w>l
" tnoremap <A-Up> <C-\><C-N><C-w>k
" tnoremap <A-Down> <C-\><C-N><C-w>j

" }}}

" insert newline without automatic comment insertion
nnoremap <silent> <A-]> :put =nr2char(10)<CR>
inoremap <silent> <A-]> <C-o>:put =nr2char(10)<CR>

nnoremap <Leader><Leader><Leader>w :setlocal wrap!<CR>:setlocal wrap?<CR>

nnoremap <Leader><Leader><Leader>m :set expandtab tabstop=2 shiftwidth=2 softtabstop=2<CR>
nnoremap <Leader><Leader><Leader>M :set expandtab tabstop=4 shiftwidth=4 softtabstop=4<CR>
nnoremap <Leader><Leader><Leader>t :set noexpandtab tabstop=2 shiftwidth=2 softtabstop=2<CR>
nnoremap <Leader><Leader><Leader>T :set noexpandtab tabstop=4 shiftwidth=4 softtabstop=4<CR>

if is_mac && is_gui
  nnoremap <silent> <D-A-Left> :tabp<CR>
  inoremap <silent> <D-A-Left> <Esc>:tabp<CR>
  vnoremap <silent> <D-A-Left> <Esc>:tabp<CR>
  nnoremap <silent> <D-A-Right> :tabn<CR>
  inoremap <silent> <D-A-Right> <Esc>:tabn<CR>
  vnoremap <silent> <D-A-Right> <Esc>:tabn<CR>

  " select tabs by cmd+1..cmd+9
  for i in range(1, 9)
    execute "nnoremap <silent> <D-" . i . "> :tabn " . i . "<CR>"
    execute "inoremap <silent> <D-" . i . "> <Esc>:tabn " . i . "<CR>"
  endfor

  nnoremap <silent> <D-Left> ^
  inoremap <silent> <D-Left> <C-c>I
  vnoremap <silent> <D-Left> ^
  nnoremap <silent> <D-Right> g_
  inoremap <silent> <D-Right> <End>
  vnoremap <silent> <D-Right> g_
  nnoremap <silent> <D-Up> gg
  inoremap <silent> <D-Up> <C-Home>
  vnoremap <silent> <D-Up> gg
  nnoremap <silent> <D-Down> G
  inoremap <silent> <D-Down> <C-End>
  vnoremap <silent> <D-Down> G

  nnoremap <silent> <D-BS> v0d
  inoremap <silent> <D-BS> <C-o>v0d

  nnoremap <silent> <D-]> >>
  inoremap <silent> <D-]> <C-t>
  vnoremap <silent> <D-]> >
  nnoremap <silent> <D-[> <<
  inoremap <silent> <D-[> <C-d>
  vnoremap <silent> <D-[> <

  " duplicate the line
  nnoremap <silent> <D-S-d> :t.<CR>
  inoremap <silent> <D-S-d> <C-o>:t.<CR>
endif

source $VIMDIR/vault.vim
source $VIMDIR/syntax-attr.vim

" Vim options {{{

set completeopt-=preview

set noshowmode

set concealcursor=nc
set conceallevel=1
set listchars+=conceal:∘

set nostartofline

set scrolloff=1

set foldmethod=indent
set foldlevelstart=6

set sessionoptions-=options

set signcolumn=yes

" set title

set hidden

set number
set relativenumber
set wrap
set showbreak=↳
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

set colorcolumn=80

" set cursorline

set list
set lazyredraw

set tagcase=smart

set updatetime=300

set termguicolors

syntax on

" }}}

" Colors {{{

" SpellBad       xxx cterm=underline ctermfg=204 gui=underline guifg=#E06C75
" SpellCap       xxx ctermfg=173 guifg=#D19A66

if is_gui
  augroup colorextend
    autocmd!
  augroup END
  function! s:Highlighting()
    hi SpellBad gui=undercurl guifg=NONE guibg=NONE guisp=#e06c75

    hi! link ALEError SpellBad
    hi! link ALEWarning SpellCap

    hi ALEVirtualTextError gui=bold,italic cterm=bold ctermfg=204 guifg=#dd7186
    hi ALEVirtualTextWarning gui=bold,italic cterm=bold ctermfg=173 guifg=#d19a66

    hi CocWarningVirtualText gui=italic cterm=bold ctermfg=130 guifg=#c36c00
    hi CocErrorVirtualText gui=italic cterm=bold ctermfg=204 guifg=#c30000
    hi CocErrorFloat guifg=#ff5d64
    hi! link CocErrorHighlight SpellBad
    hi! link CocWarningHighlight SpellCap

    hi Sneak ctermfg=15 ctermbg=201 guifg=#ff0000 guibg=#000000
    hi clear SneakLabel

    " hi Pmenu ctermbg=237 ctermfg=white
    " hi PmenuSel ctermbg=220 ctermfg=black
    " hi PmenuSbar ctermbg=233
    " hi PmenuThumb ctermbg=7

    hi IndentGuidesOdd guibg=#2d2b28
    hi IndentGuidesEven guibg=#272522

    hi VertSplit guifg=#121212 guibg=#121212

    " Default value: #ef2f27
    hi SrceryRed ctermfg=1 guifg=#ef453e
  endfunction
  autocmd colorextend ColorScheme * call s:Highlighting()
  " let g:onedark_terminal_italics = 1
  " colorscheme onedark
  " let g:gruvbox_contrast_dark = 'hard'
  " let g:gruvbox_hls_cursor = 'red'
  " colorscheme gruvbox
  " colorscheme space-vim-dark
  let g:srcery_italic = 1
  colorscheme srcery
else
  hi link GitGutterAdd DiffAdd
  hi link GitGutterChange DiffChange
  hi link GitGutterDelete DiffDelete
endif

" }}}

set exrc
set secure

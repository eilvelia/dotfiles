" vim: foldmethod=marker

nmap h <C-;>
vnoremap h <nop>
onoremap l <nop>
noremap j <nop>
nmap k <C-w>
vnoremap k <nop>
onoremap k <nop>
nnoremap l `
vnoremap l <nop>
onoremap l <nop>

if has('vim_starting')
  " let mapleader = ","
  let mapleader = "j"
  let maplocalleader = "\<Space>"
endif

let $VIMDIR = expand('~/.config/nvim')

let g:is_gui = has('gui_running') || has('gui_vimr')
let g:is_mac = has('macunix') || has('mac')

if g:is_mac
  " let g:python_host_prog = '/usr/local/bin/python2'
  let g:loaded_python_provider = 0
  let g:python3_host_prog = '/usr/local/bin/python3'
endif

" Minimal mode
if !exists('g:min_mode')
  let g:min_mode = 0
endif

" itchyny/vim-parenmatch is used instead
let g:loaded_matchparen = 1

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
command! DeinRemoveDisabledPlugins call <SID>DeinRemoveDisabledPlugins()

command! DeinUselessLazy echo dein#check_lazy_plugins()

command! DeinSaveRollback call dein#save_rollback($VIMDIR . '/dein-rollback')

command! DeinLoadRollback call dein#load_rollback($VIMDIR . '/dein-rollback')

" Plugin settings {{{

" fzf, fzf.vim {{{
" let $FZF_DEFAULT_OPTS .= ' --preview="head -100 {}"'
let $FZF_DEFAULT_COMMAND = 'fd --type f --hidden --exclude .git'
if g:is_mac && g:is_gui
  nnoremap <D-p> :FZF<CR>
  inoremap <D-p> <Esc>:FZF<CR>
  vnoremap <D-p> <Esc>:FZF<CR>
  nnoremap <D-S-p> :Buffers<CR>
  inoremap <D-S-p> <Esc>:Buffers<CR>
  vnoremap <D-S-p> <Esc>:Buffers<CR>
endif
nnoremap <C-p> :FZF<CR>
nnoremap <Leader>ff :FZF<CR>
nnoremap <Leader>fd :Buffers<CR>
nnoremap <Leader>fg :GFiles<CR>
nnoremap <Leader>fs :GFiles?<CR>
nnoremap <Leader>fc :Commits<CR>
nnoremap <Leader>fbc :BCommits<CR>
nnoremap <Leader>fl :Lines<CR>
nnoremap <Leader>fbl :BLines<CR>
nnoremap <Leader>fm :Marks<CR>
nnoremap <Leader>fr :Rg <C-r><C-w><CR>
nnoremap <Leader>fR :Rg <C-r><C-r><CR>
vnoremap <Leader>fr y:Rg <C-r>"<CR>
" nnoremap <Leader>fa :Ag <C-r><C-w><CR>
" nnoremap <Leader>` :Marks<CR>
" nnoremap <Leader>§ :Marks<CR>
" imap <C-x><C-k> <Plug>(fzf-complete-word)
imap <C-x><C-f> <Plug>(fzf-complete-path)
imap <C-x><C-j> <Plug>(fzf-complete-file-ag)
imap <C-x><C-l> <Plug>(fzf-complete-line)
" since fzf v0.21.0:
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.7 } }
" }}}

" " fzf-preview.vim {{{
" if &shell =~# 'fish$'
"   " Original: '[[ "$(file --mime {})" =~ binary ]]'
"   let g:fzf_preview_if_binary_command = "string match -q -r 'binary$' (file --mime-encoding {})"
" endif
" let g:fzf_preview_filelist_command = 'fd --type f --hidden --exclude .git'
" let g:fzf_preview_directory_files_command = 'fd --type f --hidden --exclude .git'
" " }}}

" vim-floaterm {{{
let g:floaterm_winblend = 15
let g:floaterm_position = 'center'
hi! link FloatermNF Normal
hi! link FloatermBorderNF Normal
" let g:floaterm_keymap_new = '<C-t>n'
" let g:floaterm_keymap_prev = '<C-t>['
" let g:floaterm_keymap_next = '<C-t>]'
let g:floaterm_keymap_toggle = '<C-t>'
nnoremap <Leader>t[ :FloatermPrev<CR>
nnoremap <Leader>t] :FloatermNext<CR>
nnoremap <Leader>tn :FloatermNew<CR>
nnoremap <Leader>ts :FloatermSend!<CR>
vnoremap <Leader>ts :FloatermSend!<CR>
tnoremap <F8> <C-\><C-n>:FloatermPrev<CR>
tnoremap <F9> <C-\><C-n>:FloatermNext<CR>
command! Ranger FloatermNew ranger
command! Nnn FloatermNew nnn
nnoremap <Leader>ra :Ranger<CR>
nnoremap <Leader>cf :CocList floaterm<CR>
" }}}

" vim-devicons {{{
if !g:is_gui
  let g:loaded_webdevicons = 1
endif
" }}}

" nerdtree {{{
nnoremap <Leader>d :NERDTreeToggle<CR>
nnoremap <Leader>D :NERDTreeToggleVCS<CR>
let NERDTreeMinimalUI = 1
let NERDTreeShowHidden = 1
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeIgnore = ['^\.git$[[dir]]', '^\.DS_Store$', '\~$']
" }}}

" nerdtree-git-plugin {{{
" Slows down NERDTree
let g:NERDTreeShowGitStatus = 0
let g:NERDTreeShowIgnoredStatus = 1
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✹",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '·',
    \ "Unknown"   : "?"
    \ }
" Vim-devicons and nerdtree-git-plugin are conflicting here a bit.
" Highlighting of the indicators doesn't work properly with devicons' conceal.
let g:webdevicons_conceal_nerdtree_brackets = 0
" }}}

" " defx {{{
" " TODO: change floating window colors?
" let s:defx_height = max([float2nr(&lines * 0.9), 25])
" let s:defx_col = float2nr((&columns - 90) / 2) " 90 = default width
" let s:defx_row = float2nr((&lines - s:defx_height) / 2)
" let s:defx_com = 'Defx -split=floating -winheight=' . s:defx_height
"       \ . ' -wincol=' . s:defx_col . ' -winrow=' . s:defx_row
"       \ . ' -toggle -columns=indent:git:icons:filename:type'
" exe 'command! D ' . s:defx_com . ' -resume'
" exe 'nnoremap <silent> <Leader>d :' . s:defx_com . ' -resume<CR>'
" exe 'nnoremap <silent> <Leader>D :' . s:defx_com . '<CR>'
" autocmd FileType defx call s:DefxFtSettings()
" function! s:DefxFtSettings()
"   " setlocal cursorline
"   " setlocal winhl=Normal:Floating

"   " TODO: somehow remove other normal mode mappings?

"   " Mappings
"   nnoremap <silent><buffer><expr> <CR>
"         \ defx#do_action('drop')
"   nnoremap <silent><buffer><expr> c
"         \ defx#do_action('copy')
"   nnoremap <silent><buffer><expr> m
"         \ defx#do_action('move')
"   nnoremap <silent><buffer><expr> p
"         \ defx#do_action('paste')
"   nnoremap <silent><buffer><expr> l
"         \ defx#do_action('open')
"   " nnoremap <silent><buffer><expr> E
"   "       \ defx#do_action('open', 'vsplit')
"   " nnoremap <silent><buffer><expr> P
"   "       \ defx#do_action('open', 'pedit')
"   nnoremap <silent><buffer><expr> o
"         \ defx#do_action('open_or_close_tree')
"   nnoremap <silent><buffer><expr> A
"         \ defx#do_action('new_directory')
"   " nnoremap <silent><buffer><expr> N
"   "       \ defx#do_action('new_file')
"   nnoremap <silent><buffer><expr> a
"         \ defx#do_action('new_file')
"   nnoremap <silent><buffer><expr> M
"         \ defx#do_action('new_multiple_files')
"   nnoremap <silent><buffer><expr> C
"         \ defx#do_action('toggle_columns',
"         \                'mark:indent:icon:filename:type:size:time')
"   " nnoremap <silent><buffer><expr> S
"   "       \ defx#do_action('toggle_sort', 'time')
"   nnoremap <silent><buffer><expr> d
"         \ defx#do_action('remove')
"   nnoremap <silent><buffer><expr> r
"         \ defx#do_action('rename')
"   nnoremap <silent><buffer><expr> <Leader>!
"         \ defx#do_action('execute_command')
"   nnoremap <silent><buffer><expr> <Leader>x
"         \ defx#do_action('execute_system')
"   nnoremap <silent><buffer><expr> yy
"         \ defx#do_action('yank_path')
"   nnoremap <silent><buffer><expr> I
"         \ defx#do_action('toggle_ignored_files')
"   nnoremap <silent><buffer><expr> ;
"         \ defx#do_action('repeat')
"   nnoremap <silent><buffer><expr> h
"         \ defx#do_action('cd', ['..'])
"   " nnoremap <silent><buffer><expr> ~
"   "       \ defx#do_action('cd')
"   nnoremap <silent><buffer><expr> q
"         \ defx#do_action('quit')
"   nnoremap <silent><buffer><expr> <Space>
"         \ defx#do_action('toggle_select') . 'j'
"   nnoremap <silent><buffer><expr> *
"         \ defx#do_action('toggle_select_all')
"   nnoremap <silent><buffer><expr> j
"         \ line('.') == line('$') ? 'gg' : 'j'
"   nnoremap <silent><buffer><expr> k
"         \ line('.') == 1 ? 'G' : 'k'
"   nnoremap <silent><buffer><expr> <C-l>
"         \ defx#do_action('redraw')
"   nnoremap <silent><buffer><expr> <C-g>
"         \ defx#do_action('print')
"   nnoremap <silent><buffer><expr> cd
"         \ defx#do_action('change_vim_cwd')
" endfunction
" " }}}

" airline {{{
" let g:airline_theme = 'onedark_modified'
" let g:airline_theme = 'gruvbox'
" let g:airline_theme = 'violet'
let g:airline_theme = 'srcery'
let g:airline_highlighting_cache = 1
let g:airline_powerline_fonts = 1
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
if g:is_mac && g:is_gui
  nmap <D-/> gcc
  imap <D-/> <Cmd>normal gcc<CR>
  vmap <D-/> gc
endif
" }}}

" vim-easy-align {{{
nmap ga <Plug>(EasyAlign)
vmap ga <Plug>(EasyAlign)
" align vim mappings - works for most cases
command! -range AlignVimMappings execute
      \ "<line1>,<line2>EasyAlign /\\s<silent>\\s\\|\\s/ l0r0all"
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
" if g:is_gui
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
nmap <LocalLeader>af <Plug>(ale_fix)
" nmap <LocalLeader>al <Plug>(ale_lint)
" nmap <LocalLeader>ad <Plug>(ale_detail)
" nmap <LocalLeader>ah <Plug>(ale_hover)
" nmap <LocalLeader>ar <Plug>(ale_find_references)
" nmap <LocalLeader>agd <Plug>(ale_go_to_definition_in_split)
" nmap <LocalLeader>agD <Plug>(ale_go_to_definition)
" nmap gd <Plug>(ale_go_to_definition_in_split)
" nmap gD <Plug>(ale_go_to_definition)
" nmap <LocalLeader>t <Plug>(ale_hover)
" imap <C-t> <Plug>(ale_hover)
" nmap <LocalLeader>f <Plug>(ale_find_references)
" nmap <LocalLeader>a, <Plug>(ale_next_wrap)
" nmap <LocalLeader>a. <Plug>(ale_previous_wrap)
let g:ale_linters = {}
let g:ale_linters_explicit = 1
let g:ale_disable_lsp = 1
" }}}

" " deoplete {{{
" let g:deoplete#enable_at_startup = 1
" " }}}

" coc.nvim {{{
nnoremap <silent> <LocalLeader>ct :call CocActionAsync('doHover')<CR>
nnoremap <silent> <LocalLeader>t :call CocActionAsync('doHover')<CR>
nmap <silent> cgd <Plug>(coc-definition)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> <C-w>gd :call CocAction('jumpDefinition', 'vsplit')<CR>
nnoremap <silent> <C-w>gy :call CocAction('jumpTypeDefinition', 'vsplit')<CR>
nnoremap <silent> <C-w>gi :call CocAction('jumpImplementation', 'vsplit')<CR>
nnoremap <silent> <C-w>dgd :call CocAction('jumpDefinition', 'split')<CR>
nnoremap <silent> <C-w>dgy :call CocAction('jumpTypeDefinition', 'split')<CR>
nnoremap <silent> <C-w>dgi :call CocAction('jumpImplementation', 'split')<CR>
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

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nnoremap <silent> <LocalLeader>cg :CocList diagnostics<CR>
nnoremap <silent> <LocalLeader>g :CocList diagnostics<CR>
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
nnoremap <Space>V :Vista finder<CR>
" }}}

" vim-indent-guides {{{
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
" }}}

" vim-javascript {{{
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1
" }}}

" vim-polyglot {{{
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0
" }}}

" vim-move {{{
let g:move_map_keys = 0
" vmap <Leader><A-j> <Plug>MoveBlockDown
" vmap <Leader><A-k> <Plug>MoveBlockUp
" vmap <Leader><A-h> <Plug>MoveBlockLeft
" vmap <Leader><A-l> <Plug>MoveBlockRight
" nmap <Leader><A-j> <Plug>MoveLineDown
" nmap <Leader><A-k> <Plug>MoveLineUp
vmap <Leader><Down> <Plug>MoveBlockDown
vmap <Leader><Up> <Plug>MoveBlockUp
vmap <Leader><Left> <Plug>MoveBlockLeft
vmap <Leader><Right> <Plug>MoveBlockRight
nmap <Leader><Down> <Plug>MoveLineDown
nmap <Leader><Up> <Plug>MoveLineUp
vmap <Leader>mk <Plug>MoveBlockDown
vmap <Leader>mi <Plug>MoveBlockUp
vmap <Leader>mj <Plug>MoveBlockLeft
vmap <Leader>ml <Plug>MoveBlockRight
nmap <Leader>mk <Plug>MoveLineDown
nmap <Leader>mi <Plug>MoveLineUp
if g:is_mac && g:is_gui
  vmap <D-A-Down> <Plug>MoveBlockDown
  vmap <D-A-Up> <Plug>MoveBlockUp
  vmap <D-A-Left> <Plug>MoveBlockLeft
  vmap <D-A-Right> <Plug>MoveBlockRight
  nmap <D-A-Down> <Plug>MoveLineDown
  nmap <D-A-Up> <Plug>MoveLineUp
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

" delete a character on Backspace without changing registers
nnoremap <BS> "_X
nnoremap <S-BS> "_x

" search the selected text
vnoremap <silent> // y/<C-R>"<CR>

inoremap <C-.> <Esc>

noremap <Leader><Leader>s "+

" command history
nnoremap q: <NOP>
" ^ That mapping adds delay to `q` when you stop recording. v This fixes it.
nnoremap <nowait> q q
nnoremap <Leader><Leader>q q:

" ex mode
" alternative mapping: gQ
nnoremap Q <NOP>

nnoremap <Leader>. @:

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"

" remove trailing newlines from the register
nnoremap <silent> <Leader><Leader>n :call setreg(v:register,
      \ substitute(getreg(v:register), '\n\+$', '', 'g'))<CR>

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
nnoremap <silent> <Leader><Leader>w :StripTrailingWhitespace<CR>

function! s:ExecuteVim() range
    let lines = getline(a:firstline, a:lastline)
    for line in lines
      execute line
    endfor
endfunction
command! -range ExecuteVim <line1>,<line2>call <SID>ExecuteVim()

nnoremap <silent> <C-;> :let @/ = ''<CR>
inoremap <silent> <C-;> <Cmd>let @/ = ''<CR>

" previous buffer
nnoremap <silent> <Leader>s :b#<CR>
" nnoremap <silent> <C-\> :b#<CR>

" duplicate the line
nnoremap <silent> <Leader><Leader>d :t.<CR>

" location list
nnoremap <silent> <A-l> :lopen<CR>
nnoremap <silent> <A-L> :lclose<CR>
nnoremap <silent> <C-l> :ll<CR>

" quickfix list
nnoremap <silent> <A-q> :copen<CR>
nnoremap <silent> <A-Q> :cclose<CR>
nnoremap <silent> Q :cc<CR>

" Window mappings {{{

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

" to tab
nnoremap <A-t> <C-w>T

" change height
nnoremap <A--> <C-w>-
nnoremap <A-=> <C-w>+

" change width
nnoremap <A-.> <C-w>>
nnoremap <A-,> <C-w><

" previous window - replaces "split horizontally"
nnoremap <C-w>s <C-w>p

" <C-w> / <C-w>v - vertical mappings, <C-w>d - horizontal
nnoremap <C-w>v <nop>
nnoremap <C-w>d <nop>
nnoremap <C-w>vv <C-w>v
nnoremap <C-w>ds <C-w>s
nnoremap <silent> <C-w>f :vertical :wincmd f<CR>
nnoremap <silent> <C-w>F :vertical :wincmd F<CR>
nnoremap <silent> <C-w>vf :vertical :wincmd f<CR>
nnoremap <silent> <C-w>vF :vertical :wincmd F<CR>
nnoremap <silent> <C-w>df <C-w>f
nnoremap <silent> <C-w>dF <C-w>F
nnoremap <silent> <C-w>vd :vertical :wincmd d<CR>
nnoremap <silent> <C-w>dd d<CR>

" }}}

" Terminal mappings {{{

" tnoremap <expr> <Esc> &filetype == 'fzf' ? "\<Esc>" : "\<C-\>\<C-n>"
tnoremap <C-.> <C-\><C-n>

" tnoremap <A-Left> <C-\><C-n><C-w>h
" tnoremap <A-Right> <C-\><C-n><C-w>l
" tnoremap <A-Up> <C-\><C-n><C-w>k
" tnoremap <A-Down> <C-\><C-n><C-w>j

" }}}

" insert newline without automatic comment insertion
nnoremap <silent> <A-]> :put =nr2char(10)<CR>
inoremap <silent> <A-]> <Cmd>put =nr2char(10)<CR>

inoremap <A-BS> <C-w>
cnoremap <A-BS> <C-w>

nnoremap <Leader>v <C-v>
vnoremap <Leader>v <C-v>

nnoremap <Leader><Leader><Leader>w :setlocal wrap!<CR>:setlocal wrap?<CR>

nnoremap <Leader><Leader><Leader>s :set expandtab tabstop=2 shiftwidth=2 softtabstop=0<CR>
nnoremap <Leader><Leader><Leader>S :set expandtab tabstop=4 shiftwidth=4 softtabstop=0<CR>
nnoremap <Leader><Leader><Leader>t :set noexpandtab tabstop=2 shiftwidth=2 softtabstop=0<CR>
nnoremap <Leader><Leader><Leader>T :set noexpandtab tabstop=4 shiftwidth=4 softtabstop=0<CR>

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

  " select tabs by cmd+1..cmd+9
  for i in range(1, 9)
    execute "nnoremap <silent> <D-" . i . "> :tabn " . i . "<CR>"
    execute "inoremap <silent> <D-" . i . "> <Esc>:tabn " . i . "<CR>"
  endfor

  nnoremap <D-Left> ^
  inoremap <D-Left> <C-c>I
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

  " duplicate the line
  nnoremap <silent> <D-S-d> :t.<CR>
  inoremap <silent> <D-S-d> <Cmd>:t.<CR>
endif

source $VIMDIR/vault.vim
source $VIMDIR/syntax-attr.vim
source $VIMDIR/options.vim
source $VIMDIR/color.vim

set exrc
set secure

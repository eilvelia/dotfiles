" vim: foldmethod=marker

if has('vim_starting')
  noremap h <nop>
  noremap j <nop>
  noremap k <nop>
  noremap l <nop>

  nnoremap <Space> <nop>

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

" TODO: don't set plugin mappings / settings if the plugin is disabled
if g:min_mode
  let g:loaded_airline = 1
  let g:loaded_airline_themes = 1
  let g:loaded_indent_guides = 1
  " let g:loaded_nerd_tree = 1
  let g:loaded_gitgutter = 1
  let g:loaded_unimpaired = 1
  let g:loaded_fugitive = 1
  let g:did_coc_loaded = 1
  let g:loaded_vista = 1
  let g:loaded_ale_dont_use_this_in_other_plugins_please = 1 " Nope.
endif

if !g:is_gui
  let g:loaded_webdevicons = 1
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

function! s:dein_remove_disabled_plugins()
  call map(dein#check_clean(), "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
endfunction
command! DeinRemoveDisabledPlugins call <SID>dein_remove_disabled_plugins()

command! DeinUselessLazy echo dein#check_lazy_plugins()

command! DeinSaveRollback call dein#save_rollback($VIMDIR . '/dein-rollback')
command! DeinLoadRollback call dein#load_rollback($VIMDIR . '/dein-rollback')

" lua <<EOF
" require'nvim-treesitter.configs'.setup {
"   ensure_installed = "maintained",
"   highlight = {
"     enable = true
"   },
" }
" EOF

source $VIMDIR/options.vim

nmap k <C-w>

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
nnoremap <Leader>fe :FZF %:h<CR>
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

" Too slow, also fzf has a built-in preview
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
nnoremap <Leader>tl :CocList floaterm<CR>
" }}}

" " nerdtree {{{
" nnoremap <Leader>d :NERDTreeToggle<CR>
" nnoremap <Leader>D :NERDTreeToggleVCS<CR>
" let NERDTreeMinimalUI = 1
" let NERDTreeShowHidden = 1
" let NERDTreeAutoDeleteBuffer = 1
" let NERDTreeIgnore = ['^\.git$[[dir]]', '^\.DS_Store$', '\~$']
" " }}}

" " nerdtree-git-plugin {{{
" " Slows down NERDTree, so it is disabled
" let g:NERDTreeShowGitStatus = 0
" let g:NERDTreeShowIgnoredStatus = 1
" let g:NERDTreeIndicatorMapCustom = {
"       \ "Modified"  : "✹",
"       \ "Staged"    : "✚",
"       \ "Untracked" : "✭",
"       \ "Renamed"   : "➜",
"       \ "Unmerged"  : "═",
"       \ "Deleted"   : "✖",
"       \ "Dirty"     : "✹",
"       \ "Clean"     : "✔︎",
"       \ 'Ignored'   : '·',
"       \ "Unknown"   : "?"
"       \ }
" " Vim-devicons and nerdtree-git-plugin are conflicting here a bit.
" " Highlighting of the indicators doesn't work properly with devicons' conceal.
" let g:webdevicons_conceal_nerdtree_brackets = 0
" " }}}

" defx {{{
" TODO: doesn't always work correctly with :b#
let s:defx_height = max([float2nr(&lines * 0.9), 25])
let s:defx_col = float2nr((&columns - 90) / 2) " 90 = default width
let s:defx_row = float2nr((&lines - s:defx_height) / 2)
let s:defx_columns = g:is_gui
      \ ? 'indent:git:icons:filename:type'
      \ : 'indent:git:filename:type'
" TODO: defx#custom#option('_', {...}) can be used instead of this, but it
" won't work if there's no defx, so a check is needed
let s:defx_command =
      \ 'Defx -split=floating -winheight=' . s:defx_height
      \ . ' -wincol=' . s:defx_col . ' -winrow=' . s:defx_row
      \ . ' -toggle -columns=' . s:defx_columns
      \ . ' -vertical-preview -floating-preview -preview-height=' . (s:defx_height - 5)
execute 'command! D ' . s:defx_command . ' -resume'
execute 'nnoremap <silent> <Leader>d :' . s:defx_command . ' -resume<CR>'
execute 'nnoremap <silent> <Leader>D :' . s:defx_command . '<CR>'
execute 'nnoremap <silent> <Leader><Space>d :'
      \ . s:defx_command . " -resume -search=`expand('%:p')`" . '<CR>'

augroup defx_settings
  autocmd!
  autocmd FileType defx call s:defx_ft_settings()
augroup END

function! s:defx_ft_settings() abort
  setlocal cursorline

  " " setlocal winhl=Normal:Floating
  " TODO: change floating window colors?
  " TODO: borders?

  " nowrap enables horizontal scrolling in my gui
  setlocal wrap

  nnoremap <silent><nowait><buffer><expr> k
        \ line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><nowait><buffer><expr> i
        \ line('.') == 1 ? 'G' : 'k'

  nnoremap <silent><buffer><expr> <2-LeftMouse>
        \ defx#is_directory()
        \ ? defx#do_action('open_tree', ['toggle', 'nested'])
        \ : defx#do_action('multi', ['drop', 'quit'])

  nnoremap <silent><nowait><buffer><expr> <Tab>
        \ defx#do_action('open_tree', ['toggle', 'nested'])
  nnoremap <silent><nowait><buffer><expr> <Leader><Tab>
        \ defx#do_action('open_tree', ['recursive:6', 'nested'])
  nnoremap <silent><nowait><buffer><expr> <CR>
        \ defx#is_directory() ? '\<nop>' : defx#do_action('multi', ['drop', 'quit'])
  nnoremap <silent><nowait><buffer><expr> o
        \ defx#is_directory() ? '\<nop>' : defx#do_action('multi', ['drop', 'quit'])
  nnoremap <silent><nowait><buffer><expr> <Leader>o
        \ defx#is_directory() ? '\<nop>' : defx#do_action('multi', [['drop', 'vsplit'], 'quit'])
  " nnoremap <silent><nowait><buffer><expr> <Leader>s
  "       \ defx#is_directory() ? '\<nop>' : defx#do_action('multi', [['drop', 'split'], 'quit'])
  " uses choosewin (doesn't work for now)
  " nnoremap <silent><nowait><buffer><expr> <Leader>c
  "       \ defx#is_directory() ? '\<nop>' : defx#do_action('multi', [['drop', 'choose'], 'quit'])
  nnoremap <silent><nowait><buffer><expr> t
        \ defx#is_directory() ? '\<nop>' : defx#do_action('drop', 'tabedit')

  nnoremap <silent><nowait><buffer><expr> cv
        \ defx#do_action('change_vim_cwd')
  nnoremap <silent><nowait><buffer><expr> cp
        \ defx#do_action('cd', ['..'])
  nnoremap <silent><nowait><buffer><expr> cc
        \ defx#do_action('open_directory')

  nnoremap <silent><nowait><buffer><expr> p
        \ defx#do_action('preview')

  " go to parent
  nnoremap <silent><nowait><buffer><expr> <Leader>p
        \ defx#do_action('search',
        \   fnamemodify(defx#get_candidate().action__path, ':h'))

  " TODO: go to next/prev sibling?

  function! s:close_all()
    normal! ggj
    while defx#is_directory()
      if defx#is_opened_tree()
        call defx#call_action('close_tree')
      endif
      normal! j
    endwhile
    normal! ggj
  endfunction

  " should be very slow, but I can't find a better way for defx
  function! s:open_all()
    call s:close_all()
    normal! G
    while line('.') > 1
      if defx#is_directory() && !defx#is_opened_tree()
        call defx#call_action('open_tree', ['recursive:6', 'nested'])
      endif
      normal! k
    endwhile
    normal! j
  endfunction

  " a - all
  nnoremap <silent><nowait><buffer> ao
        \ :call <SID>open_all()<CR>
  nnoremap <silent><nowait><buffer> ax
        \ :call <SID>close_all()<CR>

  nnoremap <silent><nowait><buffer><expr> mc
        \ defx#do_action('copy')
  nnoremap <silent><nowait><buffer><expr> mm
        \ defx#do_action('move')
  nnoremap <silent><nowait><buffer><expr> mp
        \ defx#do_action('paste')
  nnoremap <silent><nowait><buffer><expr> mA
        \ defx#do_action('new_directory')
  nnoremap <silent><nowait><buffer><expr> ma
        \ defx#do_action('new_file')
  nnoremap <silent><nowait><buffer><expr> M
        \ defx#do_action('new_multiple_files')
  nnoremap <silent><nowait><buffer><expr> md
        \ defx#do_action('remove')
  nnoremap <silent><nowait><buffer><expr> mr
        \ defx#do_action('rename')

  nnoremap <silent><nowait><buffer><expr> C
        \ defx#do_action('toggle_columns',
        \                'mark:indent:icon:filename:type:size:time')
  " nnoremap <silent><nowait><buffer><expr> S
  "       \ defx#do_action('toggle_sort', 'time')

  nnoremap <silent><nowait><buffer><expr> <Leader>!
        \ defx#do_action('execute_command')
  nnoremap <silent><nowait><buffer><expr> <Leader>x
        \ defx#do_action('execute_system')
  nnoremap <silent><nowait><buffer><expr> yy
        \ defx#do_action('yank_path')
  nnoremap <silent><nowait><buffer><expr> I
        \ defx#do_action('toggle_ignored_files')
  nnoremap <silent><nowait><buffer><expr> ;
        \ defx#do_action('repeat')
  nnoremap <silent><nowait><buffer><expr> q
        \ defx#do_action('quit')
  nnoremap <silent><nowait><buffer><expr> <Space>
        \ defx#do_action('toggle_select') . 'j'
  nnoremap <silent><nowait><buffer><expr> *
        \ defx#do_action('toggle_select_all')
  nnoremap <silent><nowait><buffer><expr> <C-l>
        \ defx#do_action('redraw')
  nnoremap <silent><nowait><buffer><expr> R
        \ defx#do_action('redraw')
  nnoremap <silent><nowait><buffer><expr> <C-g>
        \ defx#do_action('print')
endfunction
" }}}

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
let g:airline#extensions#branch#enabled = 0
" let g:airline_skip_empty_sections = 1
" }}}

" commentary isn't very good tbh
" vim-commentary {{{
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

" EasyMotion is too slow, changes buffers, doesn't work well with macros, etc.
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
let g:sneak#label = 1 " TODO: disable labels / bind to a standalone key?
let g:sneak#use_ic_scs = 1
" replaces S from surround
xmap S <Plug>Sneak_S
" }}}

" vim-surround {{{
let g:surround_no_mappings = 1
nmap ds  <Plug>Dsurround
nmap cs  <Plug>Csurround
nmap cS  <Plug>CSurround
nmap ys  <Plug>Ysurround
nmap yS  <Plug>YSurround
nmap yss <Plug>Yssurround
nmap ySs <Plug>YSsurround
nmap ySS <Plug>YSsurround
" xmap S   <Plug>VSurround
xmap gS  <Plug>VgSurround
" if !hasmapto("<Plug>Isurround", "i") && "" == mapcheck("<C-S>", "i")
"   imap <C-S> <Plug>Isurround
" endif
" imap <C-G>s <Plug>Isurround
" imap <C-G>S <Plug>ISurround

xmap <Leader>s <Plug>VSurround
" }}}

" targets.vim {{{
" 'Prefer multiline targets around cursor over distant targets within cursor
" line'
let g:targets_seekRanges = 'cc cr cb cB lc ac Ac lr lb ar ab lB Ar aB Ab AB rr ll rb al rB Al bb aa bB Aa BB AA'
" }}}

" vim-open-url {{{
" (default is gB)
" nmap <Leader>o <Plug>(open-url-browser)
nmap go <Plug>(open-url-browser)
" open on GitHub
" vnoremap <Leader>gh y:OpenURL https://github.com/<C-r>"<CR>
vnoremap gh y:OpenURL https://github.com/<C-r>"<CR>
" }}}

" doesn't work very well
" vim-slime {{{
let g:slime_target = 'neovim'
function! s:slime_set_job_id()
  let g:slime_default_config = { "jobid": b:terminal_job_id }
  let g:slime_dont_ask_default = 1
endfunction
command! SlimeSetJobId call <SID>slime_set_job_id()
" a - activate
nnoremap <C-c>a :SlimeSetJobId<CR>
" }}}

" works pretty slow and unstable,
" but can highlight vim's hi commands including underline, cterm colors, etc.
" Colorizer {{{
nnoremap <Leader><Leader><Leader>c :ColorToggle<CR>
" }}}

" not needed for now
" " nvim-colorizer.lua {{{
" lua require 'colorizer'.setup { 'vim'; 'css' }
" " }}}

" ale {{{
let g:ale_virtualtext_cursor = 1
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '!'
let g:ale_sign_info = 'i'
let g:ale_set_highlights = 0
nmap <LocalLeader>af <Plug>(ale_fix)
nmap <LocalLeader>al <Plug>(ale_lint)
" nmap <LocalLeader>ad <Plug>(ale_detail)
" nmap <LocalLeader>ar <Plug>(ale_find_references)
" nmap <LocalLeader>agd <Plug>(ale_go_to_definition_in_split)
" nmap <LocalLeader>agD <Plug>(ale_go_to_definition)
" nmap gd <Plug>(ale_go_to_definition_in_split)
" nmap gD <Plug>(ale_go_to_definition)
" nmap <LocalLeader>at <Plug>(ale_hover)
" nmap <LocalLeader>t <Plug>(ale_hover)
" imap <C-t> <Plug>(ale_hover)
" nmap <LocalLeader>af <Plug>(ale_find_references)
" nmap <LocalLeader>f <Plug>(ale_find_references)
" nmap <LocalLeader>a, <Plug>(ale_next_wrap)
" nmap <LocalLeader>a. <Plug>(ale_previous_wrap)
let g:ale_disable_lsp = 1
let g:ale_linters_explicit = 1
" }}}

" " deoplete {{{
" let g:deoplete#enable_at_startup = 1
" " }}}

" coc.nvim {{{
let g:coc_global_extensions = [
      \ 'coc-json',
      \ 'coc-tsserver',
      \ 'coc-flow',
      \ 'coc-floaterm'
      \ ]

" TODO: change the prefix from c to l (lsp)?
nnoremap <silent> <LocalLeader>ct :call CocActionAsync('doHover')<CR>
nnoremap <silent> <LocalLeader>t :call CocActionAsync('doHover')<CR>
nmap <LocalLeader>j <LocalLeader>t
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
nnoremap <silent> <LocalLeader>ch :call CocActionAsync('highlight')<CR>
nnoremap <silent> <LocalLeader>h :call CocActionAsync('highlight')<CR>
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

" " vim-javascript {{{
" let g:javascript_plugin_jsdoc = 1
" let g:javascript_plugin_flow = 1
" " }}}

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

" quick-scope {{{
let g:qs_buftype_blacklist = ['terminal', 'help']
nmap <Leader><Leader>t <Plug>(QuickScopeToggle)
" TODO: an option to give priority to lowercase letters would be useful
"       (without completely disabling uppercase letters)
"       https://github.com/unblevable/quick-scope/issues/62
let g:qs_accepted_chars = [
      \ 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
      \ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9']
" }}}

" vim-illuminate {{{
" TODO: disable in visual mode?
let g:Illuminate_delay = 50
let g:Illuminate_highlightPriority = -100
nnoremap <Leader>il :IlluminationToggle<CR>
" }}}

" vim-wordmotion {{{
" " prefix can be changed to the leader
" let g:wordmotion_prefix = 'h'
" let g:wordmotion_nomap = 1
" map h [wm-prefix]
" map [wm-prefix]w <Plug>WordMotion_w
" map [wm-prefix]b <Plug>WordMotion_b
" map [wm-prefix]e <Plug>WordMotion_e
" map [wm-prefix]ge <Plug>WordMotion_ge
" omap [wm-prefix]aw <Plug>WordMotion_aw
" xmap [wm-prefix]aw <Plug>WordMotion_aw
" omap [wm-prefix]iw <Plug>WordMotion_iw
" xmap [wm-prefix]iw <Plug>WordMotion_iw

let g:wordmotion_nomap = 1
" v is like w but without a v.
omap iv <Plug>WordMotion_iw
xmap iv <Plug>WordMotion_iw
omap av <Plug>WordMotion_aw
xmap av <Plug>WordMotion_aw
map <A-w> <Plug>WordMotion_w
map <A-b> <Plug>WordMotion_b
map <A-e> <Plug>WordMotion_e
map g<A-e> <Plug>WordMotion_ge
" }}}

" FixCursorHold.nvim {{{
let g:cursorhold_updatetime = 250
" }}}

" }}}

" Move the text closer to the center if there's only one vertical split
" by setting signcolumn to yes:9 (works only in neovim)
" Currently doesn't work correctly with Goyo
" TODO: Doesn't work correctly with gf
" TODO: Skip if peekaboo window is open
let s:default_signcolumn = &signcolumn
function! s:left_padding()
  if &columns < 140 | return | endif
  " " for handle in nvim_list_wins()
  " NOTE: mouse=a in nvim doesn't work correctly with multiple tabs if you use
  " nvim_win_set_option for all nvim_list_wins() (tested with nvim v0.4.4 and
  " v0.5.0-832-g35325ddac). All other features seem to work.
  for handle in nvim_tabpage_list_wins(0)
    let cfg = nvim_win_get_config(handle)
    " Skip floating and external windows
    if cfg.relative != '' || cfg.external | continue | endif
    if nvim_win_get_width(handle) == &columns
      call nvim_win_set_option(handle, 'signcolumn', 'yes:9')
    else
      call nvim_win_set_option(handle, 'signcolumn', s:default_signcolumn)
    endif
  endfor
endfunction
augroup left_padding
  autocmd!
  " TODO: WinResized from neovim 0.5?
  autocmd WinNew,WinEnter * call s:left_padding()
augroup END
call s:left_padding()

if g:is_mac
  " Apple ISO keyboards
  map § `
endif

" nnoremap ' `
" nnoremap ` '

" if g:is_gui
"   noremap <Tab> `
" endif

noremap l `

nnoremap Y y$

" built-in 'goto local declaration' and 'goto global declaration'
nnoremap <C-g>d gd
nnoremap <C-g>D gD

" delete a character on Backspace without changing registers
nnoremap <BS> "_X
nnoremap <S-BS> "_x

inoremap <C-.> <Esc>

noremap <Leader>a "+
map h "

" command history
nnoremap q: <nop>
" ^ That mapping adds delay to `q` when you stop recording. v This fixes it.
nnoremap <nowait> q q
nnoremap <Leader><Leader>q q:

" ex mode
" alternative mapping: gQ
nnoremap Q <nop>

nnoremap <Leader>. @:

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"

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

nnoremap <silent> <Leader>g :let @/ = ''<CR>
vnoremap <silent> <Leader>g <Cmd>let @/ = ''<CR>
nnoremap <silent> <C-;>     :let @/ = ''<CR>
vnoremap <silent> <C-;>     <Cmd>let @/ = ''<CR>
inoremap <silent> <C-;>     <Cmd>let @/ = ''<CR>

" previous buffer
nnoremap <silent> <Leader>s :b#<CR>
" nnoremap <silent> <C-\> :b#<CR>

" duplicate current line
" nnoremap <silent> <Leader><Leader>d :t.<CR>
nnoremap <silent> <Leader>c :t.<CR>
" (c - clone)

function! s:delete_nearest_line(above) abort
  let save_col = col('.')
  let curline = line('.')
  if a:above && curline != 1
    -d
    call cursor(curline - 1, save_col)
  elseif curline != line('$')
    +d
    call cursor(curline, save_col)
  endif
endfunction

" can be mapped to other keys / removed in the future
nnoremap <silent> <Leader><Leader>d :call <SID>delete_nearest_line(0)<CR>
nnoremap <silent> <Leader><Leader>D :call <SID>delete_nearest_line(1)<CR>

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

nnoremap <A-Left> <C-w><Left>
nnoremap <A-Right> <C-w><Right>
nnoremap <A-Up> <C-w><Up>
nnoremap <A-Down> <C-w><Down>

nnoremap <A-j> <C-w><Left>
nnoremap <A-l> <C-w><Right>
nnoremap <A-i> <C-w><Up>
nnoremap <A-k> <C-w><Down>

nnoremap <A-S-Left> <C-w>H
nnoremap <A-S-Right> <C-w>L
nnoremap <A-S-Up> <C-w>K
nnoremap <A-S-Down> <C-w>J

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

noremap 0 ^
noremap ^ 0

noremap <Leader>2 @
noremap <Leader>3 #
noremap <Leader>4 $
noremap <Leader>5 %
noremap <Leader>6 0
noremap <Leader>7 &
noremap <Leader>8 *

nnoremap <Leader>w *N

" search the selected text
vnoremap <silent> <Leader>w y/\M<C-R>"<CR>
" vnoremap <silent> // y/\M<C-R>"<CR>

nnoremap <Leader>n :normal<Space>
vnoremap <Leader>n :normal<Space>

nnoremap <Leader><Leader><Leader>w :setlocal wrap!<CR>:setlocal wrap?<CR>

nnoremap <Leader><Leader><Leader>s     :set expandtab   tabstop=2 shiftwidth=2 softtabstop=0<CR>
nnoremap <Leader><Leader><Leader>S     :set expandtab   tabstop=4 shiftwidth=4 softtabstop=0<CR>
nnoremap <Leader><Leader><Leader>t     :set noexpandtab tabstop=2 shiftwidth=2 softtabstop=0<CR>
nnoremap <Leader><Leader><Leader>T     :set noexpandtab tabstop=4 shiftwidth=4 softtabstop=0<CR>
nnoremap <Leader><Leader><Leader><A-t> :set noexpandtab tabstop=8 shiftwidth=8 softtabstop=0<CR>

command! -count EditReg call edit_reg#start()
nnoremap <Leader>e :EditReg<CR>

command! SyntaxAttr call syntax_attr#main()
nnoremap <Leader><Leader>a :SyntaxAttr<CR>

nnoremap <silent> <A-[> :-tabmove<CR>
nnoremap <silent> <A-]> :+tabmove<CR>

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

  " select tabs by cmd+1..cmd+9
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

  " nnoremap <D-f> /
  " vnoremap <D-f> /
  " nnoremap <D-S-f> ?
  " vnoremap <D-S-f> ?
  " " cnoremap <D-f> <CR>

  inoremap <D-y> <C-y>
endif

source $VIMDIR/vault.vim
source $VIMDIR/useful-text-objects.vim
source $VIMDIR/color.vim

if !g:min_mode
  set exrc
  set secure
endif

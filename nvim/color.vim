
" SpellBad       xxx cterm=underline ctermfg=204 gui=underline guifg=#E06C75
" SpellCap       xxx ctermfg=173 guifg=#D19A66

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
  hi Title gui=bold guifg=#b8bb26

  hi! link NERDTreeGitStatusIgnored Comment
  hi! link NERDTreeGitStatusUntracked Title
  " Defaults:
  " hi def link NERDTreeGitStatusModified Special
  " hi def link NERDTreeGitStatusStaged Function
  " hi def link NERDTreeGitStatusRenamed Title
  " hi def link NERDTreeGitStatusUnmerged Label
  " hi def link NERDTreeGitStatusUntracked Comment
  " hi def link NERDTreeGitStatusDirDirty Tag
  " hi def link NERDTreeGitStatusDirClean DiffAdd
  " hi def link NERDTreeGitStatusIgnored DiffAdd
endfunction

augroup colorextend
  autocmd!
  autocmd ColorScheme * call s:Highlighting()
augroup END

" let g:onedark_terminal_italics = 1
" colorscheme onedark

" let g:gruvbox_contrast_dark = 'hard'
" let g:gruvbox_hls_cursor = 'red'
" colorscheme gruvbox

" colorscheme space-vim-dark

let g:srcery_italic = 1
if !is_gui | let g:srcery_transparent_background = 1 | endif
colorscheme srcery

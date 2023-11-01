
" SpellBad       xxx cterm=underline ctermfg=204 gui=underline guifg=#E06C75
" SpellCap       xxx ctermfg=173 guifg=#D19A66

function! s:highlighting()
  hi Title  guifg=#b8bb26 ctermfg=142  guibg=none    ctermbg=none gui=bold cterm=bold
  hi Visual guifg=NONE    ctermfg=NONE guibg=#3c382f ctermbg=236  gui=NONE cterm=NONE

  hi SpellBad guifg=NONE guibg=NONE gui=undercurl guisp=#e06c75

  hi! link ALEError SpellBad
  hi! link ALEWarning SpellCap
  hi ALEVirtualTextError gui=bold,italic cterm=bold ctermfg=204 guifg=#dd7186
  hi ALEVirtualTextWarning gui=bold,italic cterm=bold ctermfg=173 guifg=#d19a66

  hi CocErrorVirtualText gui=italic cterm=bold ctermfg=204 guifg=#c30000
  hi CocErrorFloat guifg=#ff5d64
  hi! link CocErrorHighlight SpellBad
  hi CocWarningVirtualText gui=italic cterm=bold ctermfg=130 guifg=#c36c00
  hi! link CocWarningHighlight SpellCap
  hi CocInfoSign ctermfg=gray guifg=#999999
  hi! link CocInfoFloat CocInfoSign
  hi clear CocInfoHighlight
  hi CocInfoHighlight ctermfg=gray guifg=#999999
  " Default: links to CursorColumn -> CursorLine (ctermbg=236 guibg=#303030)
  hi CocHighlightText ctermbg=237 guibg=#3a3a3a

  " Default: links to CursorLine (ctermbg=236 guibg=#303030 in srcery)
  hi illuminatedWord ctermbg=236 guibg=#2a2a2a

  hi! link ParenMatch CursorLine

  hi QuickScopePrimary   guifg=#9de555 ctermfg=149 gui=underline cterm=underline
  hi QuickScopeSecondary guifg=#55e5e5 ctermfg=80  gui=underline cterm=underline

  hi Sneak      ctermfg=red ctermbg=black guifg=#ff0000 guibg=#000000
  hi SneakLabel ctermfg=red ctermbg=black guifg=#ff0000 guibg=#000000
  hi! link SneakScope Cursor

  hi IndentGuidesOdd  guifg=NONE ctermfg=NONE guibg=#2b2a26 ctermbg=234
  hi IndentGuidesEven guifg=NONE ctermfg=NONE guibg=#23221f ctermbg=235

  " hi! link NERDTreeGitStatusIgnored Comment
  " hi! link NERDTreeGitStatusUntracked Title
  " " Defaults:
  " " hi def link NERDTreeGitStatusModified Special
  " " hi def link NERDTreeGitStatusStaged Function
  " " hi def link NERDTreeGitStatusRenamed Title
  " " hi def link NERDTreeGitStatusUnmerged Label
  " " hi def link NERDTreeGitStatusUntracked Comment
  " " hi def link NERDTreeGitStatusDirDirty Tag
  " " hi def link NERDTreeGitStatusDirClean DiffAdd
  " " hi def link NERDTreeGitStatusIgnored DiffAdd

  execute 'hi StatusModified'
      \ . ' guifg=' . synIDattr(synIDtrans(hlID('Special')), 'fg', 'gui')
      \ . ' ctermfg=' . synIDattr(synIDtrans(hlID('Special')), 'fg', 'cterm')
      \ . ' guibg=' . synIDattr(synIDtrans(hlID('StatusLine')), 'bg', 'gui')
      \ . ' ctermbg=' . synIDattr(synIDtrans(hlID('StatusLine')), 'bg', 'cterm')
  " execute 'hi StatusNotModified'
  "     \ . ' guifg=' . synIDattr(synIDtrans(hlID('StatusLine')), 'fg', 'gui')
  "     \ . ' ctermfg=' . synIDattr(synIDtrans(hlID('StatusLine')), 'fg', 'cterm')
  "     \ . ' guibg=' . synIDattr(synIDtrans(hlID('StatusLine')), 'bg', 'gui')
  "     \ . ' ctermbg=' . synIDattr(synIDtrans(hlID('StatusLine')), 'bg', 'cterm')
endfunction

augroup colorextend
  autocmd!
  autocmd ColorScheme * call s:highlighting()
augroup END

" Without this, the theme sources twice
syntax enable

" let g:onedark_terminal_italics = 1
" colorscheme onedark

" let g:gruvbox_contrast_dark = 'hard'
" let g:gruvbox_hls_cursor = 'red'
" colorscheme gruvbox

" colorscheme space-vim-dark

" let g:srcery_italic = 1
if !g:is_gui | let g:srcery_transparent_background = 1 | endif
" colorscheme srcery
colorscheme my_srcery

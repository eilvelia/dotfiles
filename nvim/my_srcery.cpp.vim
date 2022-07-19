" vim: foldmethod=marker

" Vim color scheme.
" Based on https://github.com/srcery-colors/srcery-vim/blob/ecbd5ba9055ad6b78dc47ef4f0894a7da63215f7/colors/srcery.vim

" Yes, this file uses cpp.

" Modifications:
" - uses preprocessing instead of calling `s:HL`
" - replaced `link Normal` with `hi clear` (works better in floating windows)
" - removed support for sneak and indent-guides (I have my own settings in my config)
" - removed support for plugins that I don't use
" - removed g:srcery_{bold,italic,underline,undercurl,inverse} options
" - changed the red color: #ef2f27 -> #ef453e
" - added new red_error color: #a11a15
" - removed bold from Error
" - red_error is used instead of red in
"   Error, ErrorMsg, DiffDelete, ExtraWhitespace, shParenError
" - changed VertSplit to use hard_black (as both fg and bg)
" - removed jsonString linking (now behaves as jsonString -> String)
" - jsonKeyword -> Identifier instead of SrceryCyan
" - removed Visual (it's changed to another color in my config)
" - removed Title (it's changed to another color in my config)

" TODO: Use colortemplate (https://github.com/lifepillar/vim-colortemplate)?

" TODO: Use preprocessing instead of SrceryX groups as well?

scriptencoding utf-8

set background=dark

hi clear

if exists('syntax_on')
  syntax reset
endif

let g:colors_name = 'my_srcery'

if !has('gui_running') && &t_Co != 256
  finish
endif

#include "my_srcery_colors.cpp.vim"

#define FG(x) guifg=x ctermfg=x##_CTERM
#define BG(x) guibg=x ctermbg=x##_CTERM
#define ATTR(...) gui=__VA_ARGS__ cterm=__VA_ARGS__

" Setup Variables: {{{
" if !exists('g:srcery_bold')
"   let g:srcery_bold=1
" endif

" if !exists('g:srcery_italic')
"   if has('gui_running') || $TERM_ITALICS ==? 'true'
"     let g:srcery_italic=1
"   else
"     let g:srcery_italic=0
"   endif
" endif

if !exists('g:srcery_transparent_background')
  let g:srcery_transparent_background=0
endif

" if !exists('g:srcery_undercurl')
"   let g:srcery_undercurl=1
" endif

" if !exists('g:srcery_underline')
"   let g:srcery_underline=1
" endif

" if !exists('g:srcery_inverse')
"   let g:srcery_inverse=1
" endif

if !exists('g:srcery_inverse_matches')
  let g:srcery_inverse_matches=0
endif

if !exists('g:srcery_inverse_match_paren')
  let g:srcery_inverse_match_paren=0
endif

if !exists('g:srcery_dim_lisp_paren')
  let g:srcery_dim_lisp_paren=0
endif
" }}}

" Srcery Hi Groups: {{{
" memoize common hi groups
hi SrceryWhite         FG(WHITE)          BG(NONE) ATTR(NONE)
hi SrceryRed           FG(RED)            BG(NONE) ATTR(NONE)
hi SrceryGreen         FG(GREEN)          BG(NONE) ATTR(NONE)
hi SrceryYellow        FG(YELLOW)         BG(NONE) ATTR(NONE)
hi SrceryBlue          FG(BLUE)           BG(NONE) ATTR(NONE)
hi SrceryMagenta       FG(MAGENTA)        BG(NONE) ATTR(NONE)
hi SrceryCyan          FG(CYAN)           BG(NONE) ATTR(NONE)
hi SrceryBlack         FG(BLACK)          BG(NONE) ATTR(NONE)

hi SrceryRedBold       FG(RED)            BG(NONE) ATTR(bold)
hi SrceryGreenBold     FG(GREEN)          BG(NONE) ATTR(bold)
hi SrceryYellowBold    FG(YELLOW)         BG(NONE) ATTR(bold)
hi SrceryBlueBold      FG(BLUE)           BG(NONE) ATTR(bold)
hi SrceryMagentaBold   FG(MAGENTA)        BG(NONE) ATTR(bold)
hi SrceryCyanBold      FG(CYAN)           BG(NONE) ATTR(bold)

hi SrceryBrightRed     FG(BRIGHT_RED)     BG(NONE) ATTR(NONE)
hi SrceryBrightGreen   FG(BRIGHT_GREEN)   BG(NONE) ATTR(NONE)
hi SrceryBrightYellow  FG(BRIGHT_YELLOW)  BG(NONE) ATTR(NONE)
hi SrceryBrightBlue    FG(BRIGHT_BLUE)    BG(NONE) ATTR(NONE)
hi SrceryBrightMagenta FG(BRIGHT_MAGENTA) BG(NONE) ATTR(NONE)
hi SrceryBrightCyan    FG(BRIGHT_CYAN)    BG(NONE) ATTR(NONE)
hi SrceryBrightBlack   FG(BRIGHT_BLACK)   BG(NONE) ATTR(NONE)
hi SrceryBrightWhite   FG(BRIGHT_WHITE)   BG(NONE) ATTR(NONE)

" special
hi SrceryOrange        FG(ORANGE)         BG(NONE) ATTR(NONE)
hi SrceryBrightOrange  FG(BRIGHT_ORANGE)  BG(NONE) ATTR(NONE)
hi SrceryOrangeBold    FG(ORANGE)         BG(NONE) ATTR(bold)
hi SrceryHardBlack     FG(HARD_BLACK)     BG(NONE) ATTR(NONE)
hi SrceryXgray1        FG(XGRAY1)         BG(NONE) ATTR(NONE)
hi SrceryXgray2        FG(XGRAY2)         BG(NONE) ATTR(NONE)
hi SrceryXgray3        FG(XGRAY3)         BG(NONE) ATTR(NONE)
hi SrceryXgray4        FG(XGRAY4)         BG(NONE) ATTR(NONE)
hi SrceryXgray5        FG(XGRAY5)         BG(NONE) ATTR(NONE)
hi SrceryXgray6        FG(XGRAY6)         BG(NONE) ATTR(NONE)
" }}}

" Setup Terminal Colors For Neovim: {{{
if has('nvim')
  let g:terminal_color_0  = STR(BLACK)
  let g:terminal_color_8  = STR(BRIGHT_BLACK)

  let g:terminal_color_1  = STR(RED)
  let g:terminal_color_9  = STR(BRIGHT_RED)

  let g:terminal_color_2  = STR(GREEN)
  let g:terminal_color_10 = STR(BRIGHT_GREEN)

  let g:terminal_color_3  = STR(YELLOW)
  let g:terminal_color_11 = STR(BRIGHT_YELLOW)

  let g:terminal_color_4  = STR(BLUE)
  let g:terminal_color_12 = STR(BRIGHT_BLUE)

  let g:terminal_color_5  = STR(MAGENTA)
  let g:terminal_color_13 = STR(BRIGHT_MAGENTA)

  let g:terminal_color_6  = STR(CYAN)
  let g:terminal_color_14 = STR(BRIGHT_CYAN)

  let g:terminal_color_7  = STR(WHITE)
  let g:terminal_color_15 = STR(BRIGHT_WHITE)
endif
" }}}

" Setup Terminal Colors For Vim with termguicolors: {{{
if exists('*term_setansicolors')
  let g:terminal_ansi_colors = repeat([0], 16)

  let g:terminal_ansi_colors[0]  = STR(BLACK)
  let g:terminal_ansi_colors[8]  = STR(BRIGHT_BLACK)

  let g:terminal_ansi_colors[1]  = STR(RED)
  let g:terminal_ansi_colors[9]  = STR(BRIGHT_RED)

  let g:terminal_ansi_colors[2]  = STR(GREEN)
  let g:terminal_ansi_colors[10] = STR(BRIGHT_GREEN)

  let g:terminal_ansi_colors[3]  = STR(YELLOW)
  let g:terminal_ansi_colors[11] = STR(BRIGHT_YELLOW)

  let g:terminal_ansi_colors[4]  = STR(BLUE)
  let g:terminal_ansi_colors[12] = STR(BRIGHT_BLUE)

  let g:terminal_ansi_colors[5]  = STR(MAGENTA)
  let g:terminal_ansi_colors[13] = STR(BRIGHT_MAGENTA)

  let g:terminal_ansi_colors[6]  = STR(CYAN)
  let g:terminal_ansi_colors[14] = STR(BRIGHT_CYAN)

  let g:terminal_ansi_colors[7]  = STR(WHITE)
  let g:terminal_ansi_colors[15] = STR(BRIGHT_WHITE)
endif
" }}}

" Vanilla colorscheme ---------------------------------------------------------

" General UI: {{{

" Normal text
if g:srcery_transparent_background == 1 && !has('gui_running')
  hi Normal FG(BRIGHT_WHITE) BG(NONE) ATTR(NONE)
 else
  hi Normal FG(BRIGHT_WHITE) BG(BLACK) ATTR(NONE)
endif

if v:version >= 700
  " Screen line that the cursor is
  hi CursorLine FG(NONE) BG(XGRAY2) ATTR(NONE)
  " Screen column that the cursor is
  hi! link CursorColumn CursorLine
  hi TabLineFill FG(BRIGHT_BLACK) BG(XGRAY2) ATTR(NONE)

  hi TabLineSel FG(BRIGHT_WHITE) BG(XGRAY5) ATTR(NONE)

  " Not active tab page label
  hi! link TabLine TabLineFill

  " Match paired bracket under the cursor
  if g:srcery_inverse_match_paren == 1
    hi MatchParen FG(BRIGHT_MAGENTA) BG(NONE) ATTR(inverse,bold)
  else
    hi MatchParen FG(BRIGHT_MAGENTA) BG(NONE) ATTR(bold)
  endif
endif

if v:version >= 703
  " Highlighted screen columns
  hi ColorColumn FG(NONE) BG(XGRAY2) ATTR(NONE)

  " Concealed element: \lambda → λ
  hi Conceal FG(BLUE) BG(NONE) ATTR(NONE)

  " Line number of CursorLine
  if g:srcery_transparent_background == 1 && !has('gui_running')
    hi CursorLineNr FG(YELLOW) BG(NONE) ATTR(NONE)
  else
    hi CursorLineNr FG(YELLOW) BG(BLACK) ATTR(NONE)
  endif
endif

hi! link NonText SrceryXgray4
hi! link SpecialKey SrceryBlue

" hi Visual FG(NONE) BG(NONE) ATTR(inverse)

hi! link VisualNOS Visual

if g:srcery_inverse_matches == 1
  hi Search    FG(NONE) BG(NONE)   ATTR(inverse)
  hi IncSearch FG(NONE) BG(NONE)   ATTR(inverse)
else
  hi Search    FG(NONE) BG(XGRAY5) ATTR(bold)
  hi IncSearch FG(NONE) BG(XGRAY5) ATTR(underline,bold)
endif

hi Underlined FG(BLUE) BG(NONE) ATTR(underline)

hi StatusLine FG(BRIGHT_WHITE) BG(XGRAY2) ATTR(NONE)

if g:srcery_transparent_background == 1 && !has('gui_running')
  hi StatusLineNC FG(BRIGHT_BLACK) BG(NONE)  ATTR(underline)
  " Current match in wildmenu completion
  hi WildMenu     FG(BLUE)         BG(NONE)  ATTR(bold)
else
  hi StatusLineNC FG(BRIGHT_BLACK) BG(BLACK) ATTR(underline)
  hi WildMenu     FG(BLUE)         BG(BLACK) ATTR(bold)
endif

" The column separating vertically split windows
hi VertSplit FG(HARD_BLACK) BG(HARD_BLACK) ATTR(NONE)

" Directory names, special names in listing
hi! link Directory SrceryGreenBold

" Titles for output from :set all, :autocmd, etc.
" hi! link Title SrceryGreenBold

" Error messages on the command line
hi ErrorMsg FG(BRIGHT_WHITE) BG(RED_ERROR) ATTR(NONE)
" More prompt: -- More --
hi! link MoreMsg SrceryYellowBold
" Current mode message: -- INSERT --
hi! link ModeMsg SrceryYellowBold
" 'Press enter' prompt and yes/no questions
hi! link Question SrceryOrangeBold
" Warning messages
hi! link WarningMsg SrceryRedBold
" }}}

" Gutter: {{{
" Line number for :number and :# commands
hi LineNr FG(BRIGHT_BLACK) BG(NONE) ATTR(NONE)

if g:srcery_transparent_background == 1 && !has('gui_running')
  " Column where signs are displayed
  " TODO Possibly need to fix SignColumn
  hi SignColumn FG(NONE)         BG(NONE)  ATTR(NONE)
  " Line used for closed folds
  hi Folded     FG(BRIGHT_BLACK) BG(NONE)  ATTR(italic)
  " Column where folds are displayed
  hi FoldColumn FG(BRIGHT_BLACK) BG(NONE)  ATTR(NONE)
else
  hi SignColumn FG(NONE)         BG(BLACK) ATTR(NONE)
  hi Folded     FG(BRIGHT_BLACK) BG(BLACK) ATTR(italic)
  hi FoldColumn FG(BRIGHT_BLACK) BG(BLACK) ATTR(NONE)
endif
" }}}

" Cursor: {{{
" Character under cursor
hi Cursor FG(BLACK) BG(YELLOW) ATTR(NONE)
" Visual mode cursor, selection
hi! link vCursor Cursor
" Input moder cursor
hi! link iCursor Cursor
" Language mapping cursor
hi! link lCursor Cursor
" }}}

" Syntax Highlighting: {{{
hi! link Special SrceryOrange

hi Comment FG(BRIGHT_BLACK) BG(NONE) ATTR(italic)

if g:srcery_transparent_background == 1 && !has('gui_running')
  hi Todo FG(BRIGHT_WHITE) BG(NONE)  ATTR(bold,italic)
else
  hi Todo FG(BRIGHT_WHITE) BG(BLACK) ATTR(bold,italic)
endif

hi Error FG(BRIGHT_WHITE) BG(RED_ERROR) ATTR(NONE)

" String constant: "this is a string"
hi String FG(BRIGHT_GREEN) BG(NONE) ATTR(NONE)

" Generic statement
hi! link Statement SrceryRed
" if, then, else, endif, swicth, etc.
hi! link Conditional SrceryRed
" for, do, while, etc.
hi! link Repeat SrceryRed
" case, default, etc.
hi! link Label SrceryRed
" try, catch, throw
hi! link Exception SrceryRed
" sizeof, "+", "*", etc.
" hi! link Operator Normal
hi clear Operator
" Any other keyword
hi! link Keyword SrceryRed

" Variable name
hi! link Identifier SrceryCyan
" Function name
hi! link Function SrceryYellow

" Generic preprocessor
hi! link PreProc SrceryCyan
" Preprocessor #include
hi! link Include SrceryCyan
" Preprocessor #define
hi! link Define SrceryCyan
" Same as Define
hi! link Macro SrceryOrange
" Preprocessor #if, #else, #endif, etc.
hi! link PreCondit SrceryCyan

" Generic constant
hi! link Constant SrceryBrightMagenta
" Character constant: 'c', '/n'
hi! link Character SrceryBrightMagenta
" Boolean constant: TRUE, false
hi! link Boolean SrceryBrightMagenta
" Number constant: 234, 0xff
hi! link Number SrceryBrightMagenta
" Floating point constant: 2.3e10
hi! link Float SrceryBrightMagenta

" Generic type
hi! link Type SrceryBrightBlue
" static, register, volatile, etc
hi! link StorageClass SrceryOrange
" struct, union, enum, etc.
hi! link Structure SrceryCyan
" typedef
hi! link Typedef SrceryMagenta

if g:srcery_dim_lisp_paren == 1
  hi! link Delimiter SrceryXgray6
else
  hi! link Delimiter SrceryBrightBlack
endif
" }}}

" Completion Menu: {{{
if v:version >= 700
  " Popup menu: normal item
  hi Pmenu FG(BRIGHT_WHITE) BG(XGRAY2) ATTR(NONE)
  " Popup menu: selected item
  hi PmenuSel FG(BRIGHT_WHITE) BG(BLUE) ATTR(bold)

  if g:srcery_transparent_background == 1 && !has('gui_running')
    " Popup menu: scrollbar
    hi PmenuSbar  FG(NONE) BG(NONE)  ATTR(NONE)
    " Popup menu: scrollbar thumb
    hi PmenuThumb FG(NONE) BG(NONE)  ATTR(NONE)
  else
    hi PmenuSbar  FG(NONE) BG(BLACK) ATTR(NONE)
    hi PmenuThumb FG(NONE) BG(BLACK) ATTR(NONE)
  endif
endif
" }}}

" Diffs: {{{
if g:srcery_transparent_background == 1 && !has('gui_running')
  hi DiffDelete FG(RED_ERROR) BG(NONE)  ATTR(NONE)
  hi DiffAdd    FG(GREEN)     BG(NONE)  ATTR(NONE)
  hi DiffChange FG(CYAN)      BG(NONE)  ATTR(NONE)
  hi DiffText   FG(YELLOW)    BG(NONE)  ATTR(NONE)
else
  hi DiffDelete FG(RED_ERROR) BG(BLACK) ATTR(NONE)
  hi DiffAdd    FG(GREEN)     BG(BLACK) ATTR(NONE)
  hi DiffChange FG(CYAN)      BG(BLACK) ATTR(NONE)
  hi DiffText   FG(YELLOW)    BG(BLACK) ATTR(NONE)
endif
" }}}

" Spelling: {{{
if has('spell')
  " Not capitalised word, or compile warnings
  hi SpellCap   FG(GREEN) BG(NONE) ATTR(bold,italic)
  " Not recognized word
  hi SpellBad   FG(NONE)  BG(NONE) ATTR(undercurl) guisp=BLUE
  " Wrong spelling for selected region
  hi SpellLocal FG(NONE)  BG(NONE) ATTR(undercurl) guisp=CYAN
  " Rare word
  hi SpellRare  FG(NONE)  BG(NONE) ATTR(undercurl) guisp=MAGENTA
endif
" }}}

" Terminal: {{{
if has('terminal')
  " Must set an explicit background as NONE won't work
  " Therefore not useful with transparent background option
  hi Terminal FG(BRIGHT_WHITE) BG(HARD_BLACK) ATTR(NONE)
endif
" }}}

" Plugin specific -------------------------------------------------------------

" " Sneak: {{{
" hi! link Sneak Search
" hi SneakScope FG(NONE) BG(HARD_BLACK) ATTR(NONE)
" hi! link SneakLabel Search
" " }}}

" " Rainbow Parentheses: {{{
" if !exists('g:rbpt_colorpairs')
"   let g:rbpt_colorpairs =
"     \ [
"       \ ['blue',  '#2C78BF'], ['202',  '#FF5F00'],
"       \ ['red',  '#EF2F27'], ['magenta', '#E02C6D']
"     \ ]
" endif

" let g:rainbow_guifgs = [ '#E02C6D', '#EF2F27', '#D75F00', '#2C78BF']
" let g:rainbow_ctermfgs = [ 'magenta', 'red', '202', 'blue' ]

" if !exists('g:rainbow_conf')
"   let g:rainbow_conf = {}
" endif
" if !has_key(g:rainbow_conf, 'guifgs')
"   let g:rainbow_conf['guifgs'] = g:rainbow_guifgs
" endif
" if !has_key(g:rainbow_conf, 'ctermfgs')
"   let g:rainbow_conf['ctermfgs'] = g:rainbow_ctermfgs
" endif

" let g:niji_dark_colours = g:rbpt_colorpairs
" let g:niji_light_colours = g:rbpt_colorpairs
" " }}}

" GitGutter: {{{
hi! link GitGutterAdd          SrceryGreen
hi! link GitGutterChange       SrceryYellow
hi! link GitGutterDelete       SrceryRed
hi! link GitGutterChangeDelete SrceryYellow
" }}}

" GitCommit: {{{
hi! link gitcommitSelectedFile SrceryGreen
hi! link gitcommitDiscardedFile SrceryRed
" }}}

" Asynchronous Lint Engine: {{{
hi ALEError   FG(NONE) BG(NONE) ATTR(undercurl) guisp=RED
hi ALEWarning FG(NONE) BG(NONE) ATTR(undercurl) guisp=YELLOW
hi ALEInfo    FG(NONE) BG(NONE) ATTR(undercurl) guisp=BLUE

hi! link ALEErrorSign   SrceryRed
hi! link ALEWarningSign SrceryYellow
hi! link ALEInfoSign    SrceryBlue
" }}}

" " vim-indent-guides: {{{
" hi IndentGuidesEven FG(NONE) BG(XGRAY3) ATTR(NONE)
" hi IndentGuidesOdd  FG(NONE) BG(XGRAY4) ATTR(NONE)
" " }}}

" " vim-startify {{{
" hi! link StartifyNumber Statement
" hi! link StartifyFile Normal
" hi! link StartifyPath String
" hi! link StartifySlash Normal
" hi! link StartifyBracket Comment
" hi! link StartifyHeader Type
" hi! link StartifyFooter Normal
" hi! link StartifySpecial Comment
" hi! link StartifySection Identifier
" " }}}

" fzf: {{{
hi fzf1 FG(MAGENTA)      BG(XGRAY2) ATTR(NONE)
hi fzf2 FG(BRIGHT_GREEN) BG(XGRAY2) ATTR(NONE)
hi fzf3 FG(BRIGHT_WHITE) BG(XGRAY2) ATTR(NONE)
" }}}

" Netrw: {{{
hi! link netrwDir      SrceryBlue
hi! link netrwClassify SrceryCyan
hi! link netrwLink     SrceryBrightBlack
hi! link netrwSymLink  SrceryCyan
hi! link netrwExe      SrceryYellow
hi! link netrwComment  SrceryBrightBlack
hi! link netrwList     SrceryBrightBlue
hi! link netrwTreeBar  SrceryBrightBlack
hi! link netrwHelpCmd  SrceryCyan
hi! link netrwVersion  SrceryGreen
hi! link netrwCmdSep   SrceryBrightBlack
"}}}

" coc.nvim: {{{
hi! link CocErrorSign          SrceryRed
hi! link CocWarningSign        SrceryBrightOrange
hi! link CocInfoSign           SrceryYellow
hi! link CocHintSign           SrceryBlue
hi! link CocErrorFloat         SrceryRed
hi! link CocWarningFloat       SrceryOrange
hi! link CocInfoFloat          SrceryYellow
hi! link CocHintFloat          SrceryBlue
hi! link CocDiagnosticsError   SrceryRed
hi! link CocDiagnosticsWarning SrceryOrange
hi! link CocDiagnosticsInfo    SrceryYellow
hi! link CocDiagnosticsHint    SrceryBlue

hi! link CocSelectedText SrceryRed
hi! link CocCodeLens SrceryWhite

hi CocErrorHighlight   FG(NONE) BG(NONE) ATTR(undercurl) guisp=RED
hi CocWarningHighlight FG(NONE) BG(NONE) ATTR(undercurl) guisp=BRIGHT_ORANGE
hi CocInfoHighlight    FG(NONE) BG(NONE) ATTR(undercurl) guisp=YELLOW
hi CocHintHighlight    FG(NONE) BG(NONE) ATTR(undercurl) guisp=BLUE
" }}}

" " CtrlP: {{{
" hi! link CtrlPMatch SrceryMagenta
" hi! link CtrlPLinePre SrceryBrightGreen
" hi CtrlPMode1 FG(BRIGHT_WHITE) BG(XGRAY3) ATTR(NONE)
" hi CtrlPMode2 FG(BRIGHT_WHITE) BG(XGRAY5) ATTR(NONE)
" hi CtrlPStats FG(YELLOW) BG(XGRAY2) ATTR(NONE)
" " }}}

" Filetype specific -----------------------------------------------------------

" Diff: {{{
hi! link diffAdded   SrceryGreen
hi! link diffRemoved SrceryRed
hi! link diffChanged SrceryCyan

hi! link diffFile    SrceryOrange
hi! link diffNewFile SrceryYellow

hi! link diffLine    SrceryBlue
" }}}

" Html: {{{
hi! link htmlTag SrceryBlue
hi! link htmlEndTag SrceryBlue

hi! link htmlTagName SrceryBlue
hi! link htmlTag SrceryBrightBlack
hi! link htmlArg SrceryYellow

hi! link htmlScriptTag SrceryRed
hi! link htmlTagN SrceryBlue
hi! link htmlSpecialTagName SrceryBlue

hi htmlLink FG(BRIGHT_WHITE) BG(NONE) ATTR(underline)

hi! link htmlSpecialChar SrceryYellow

if g:srcery_transparent_background == 1 && !has('gui_running')
  hi htmlBold                FG(BRIGHT_WHITE) BG(NONE)  ATTR(bold)
  hi htmlBoldUnderline       FG(BRIGHT_WHITE) BG(NONE)  ATTR(bold,underline)
  hi htmlBoldItalic          FG(BRIGHT_WHITE) BG(NONE)  ATTR(bold,italic)
  hi htmlBoldUnderlineItalic FG(BRIGHT_WHITE) BG(NONE)  ATTR(bold,underline,italic)
  hi htmlUnderline           FG(BRIGHT_WHITE) BG(NONE)  ATTR(underline)
  hi htmlUnderlineItalic     FG(BRIGHT_WHITE) BG(NONE)  ATTR(underline,italic)
  hi htmlItalic              FG(BRIGHT_WHITE) BG(NONE)  ATTR(italic)
else
  hi htmlBold                FG(BRIGHT_WHITE) BG(BLACK) ATTR(bold)
  hi htmlBoldUnderline       FG(BRIGHT_WHITE) BG(BLACK) ATTR(bold,underline)
  hi htmlBoldItalic          FG(BRIGHT_WHITE) BG(BLACK) ATTR(bold,italic)
  hi htmlBoldUnderlineItalic FG(BRIGHT_WHITE) BG(BLACK) ATTR(bold,underline,italic)
  hi htmlUnderline           FG(BRIGHT_WHITE) BG(BLACK) ATTR(underline)
  hi htmlUnderlineItalic     FG(BRIGHT_WHITE) BG(BLACK) ATTR(underline,italic)
  hi htmlItalic              FG(BRIGHT_WHITE) BG(BLACK) ATTR(italic)
endif
" }}}

" Xml: {{{
hi! link xmlTag SrceryBlue
hi! link xmlEndTag SrceryBlue
hi! link xmlTagName SrceryBlue
hi! link xmlEqual SrceryBlue
hi! link docbkKeyword SrceryCyanBold

hi! link xmlDocTypeDecl SrceryBrightBlack
hi! link xmlDocTypeKeyword SrceryMagenta
hi! link xmlCdataStart SrceryBrightBlack
hi! link xmlCdataCdata SrceryMagenta
hi! link dtdFunction SrceryBrightBlack
hi! link dtdTagName SrceryMagenta

hi! link xmlAttrib SrceryCyan
hi! link xmlProcessingDelim SrceryBrightBlack
hi! link dtdParamEntityPunct SrceryBrightBlack
hi! link dtdParamEntityDPunct SrceryBrightBlack
hi! link xmlAttribPunct SrceryBrightBlack

hi! link xmlEntity SrceryYellow
hi! link xmlEntityPunct SrceryYellow
" }}}

" Vim: {{{
hi vimCommentTitle FG(BRIGHT_WHITE) BG(NONE) ATTR(bold,italic)

hi! link vimNotation SrceryYellow
hi! link vimBracket SrceryYellow
hi! link vimMapModKey SrceryYellow
hi! link vimFuncSID SrceryBrightWhite
hi! link vimSetSep SrceryBrightWhite
hi! link vimSep SrceryBrightWhite
hi! link vimContinue SrceryBrightWhite
" }}}

" Lisp dialects: {{{
if g:srcery_dim_lisp_paren == 1
  hi! link schemeParentheses SrceryXgray6
  hi! link clojureParen SrceryXgray6
else
  hi! link schemeParentheses SrceryBrightBlack
  hi! link clojureParen SrceryBrightBlack
endif

hi! link clojureKeyword SrceryBlue
hi! link clojureCond SrceryRed
hi! link clojureSpecial SrceryRed
hi! link clojureDefine SrceryRed

hi! link clojureFunc SrceryYellow
hi! link clojureRepeat SrceryYellow
hi! link clojureCharacter SrceryCyan
hi! link clojureStringEscape SrceryCyan
hi! link clojureException SrceryRed

hi! link clojureRegexp SrceryCyan
hi! link clojureRegexpEscape SrceryCyan
hi clojureRegexpCharClass FG(BRIGHT_WHITE) BG(NONE) ATTR(bold)
hi! link clojureRegexpMod clojureRegexpCharClass
hi! link clojureRegexpQuantifier clojureRegexpCharClass

hi! link clojureAnonArg SrceryYellow
hi! link clojureVariable SrceryBlue
hi! link clojureMacro SrceryOrangeBold

hi! link clojureMeta SrceryYellow
hi! link clojureDeref SrceryYellow
hi! link clojureQuote SrceryYellow
hi! link clojureUnquote SrceryYellow
" }}}

" C: {{{
hi! link cOperator SrceryMagenta
hi! link cStructure SrceryYellow
" }}}

" Python: {{{
hi! link pythonBuiltin SrceryYellow
hi! link pythonBuiltinObj SrceryYellow
hi! link pythonBuiltinFunc SrceryYellow
hi! link pythonFunction SrceryCyan
hi! link pythonDecorator SrceryRed
hi! link pythonInclude SrceryBlue
hi! link pythonImport SrceryBlue
hi! link pythonRun SrceryBlue
hi! link pythonCoding SrceryBlue
hi! link pythonOperator SrceryRed
hi! link pythonExceptions SrceryMagenta
hi! link pythonBoolean SrceryMagenta
hi! link pythonDot SrceryBrightWhite
" }}}

" CSS/SASS: {{{
hi! link cssBraces SrceryBrightWhite
hi! link cssFunctionName SrceryYellow
hi! link cssIdentifier SrceryBlue
hi! link cssClassName SrceryBlue
hi! link cssClassNameDot SrceryBlue
hi! link cssColor SrceryBrightMagenta
hi! link cssSelectorOp SrceryBlue
hi! link cssSelectorOp2 SrceryBlue
hi! link cssImportant SrceryGreen
hi! link cssVendor SrceryBlue
hi! link cssMediaProp SrceryYellow
hi! link cssBorderProp SrceryYellow
hi! link cssAttrComma SrceryBrightWhite

hi! link cssTextProp SrceryYellow
hi! link cssAnimationProp SrceryYellow
hi! link cssUIProp SrceryYellow
hi! link cssTransformProp SrceryYellow
hi! link cssTransitionProp SrceryYellow
hi! link cssPrintProp SrceryYellow
hi! link cssPositioningProp SrceryYellow
hi! link cssBoxProp SrceryYellow
hi! link cssFontDescriptorProp SrceryYellow
hi! link cssFlexibleBoxProp SrceryYellow
hi! link cssBorderOutlineProp SrceryYellow
hi! link cssBackgroundProp SrceryYellow
hi! link cssMarginProp SrceryYellow
hi! link cssListProp SrceryYellow
hi! link cssTableProp SrceryYellow
hi! link cssFontProp SrceryYellow
hi! link cssPaddingProp SrceryYellow
hi! link cssDimensionProp SrceryYellow
hi! link cssRenderProp SrceryYellow
hi! link cssColorProp SrceryYellow
hi! link cssGeneratedContentProp SrceryYellow
hi! link cssTagName SrceryBrightBlue

" SASS
hi! link sassClass SrceryBlue
hi! link sassClassChar SrceryBlue
hi! link sassVariable SrceryCyan
hi! link sassIdChar SrceryBrightBlue
" }}}

" JavaScript: {{{
hi! link javaScriptMember SrceryBlue
hi! link javaScriptNull SrceryMagenta
" }}}

" YAJS: {{{
hi! link javascriptParens SrceryBrightCyan
" hi! link javascriptFuncArg Normal
hi clear javascriptFuncArg
hi! link javascriptDocComment SrceryGreen
hi! link javascriptArrayMethod Function
hi! link javascriptReflectMethod Function
hi! link javascriptStringMethod Function
hi! link javascriptObjectMethod Function
hi! link javascriptObjectStaticMethod Function
hi! link javascriptObjectLabel SrceryBlue

hi! link javascriptProp SrceryBlue

hi! link javascriptVariable SrceryBrightBlue
hi! link javascriptOperator SrceryBrightCyan
hi! link javascriptFuncKeyword SrceryBrightRed
hi! link javascriptFunctionMethod SrceryYellow
hi! link javascriptReturn SrceryBrightRed
" hi! link javascriptEndColons Normal
hi clear javascriptEndColons
" }}}

" CoffeeScript: {{{
hi! link coffeeExtendedOp SrceryBrightWhite
hi! link coffeeSpecialOp SrceryBrightWhite
hi! link coffeeCurly SrceryYellow
hi! link coffeeParen SrceryBrightWhite
hi! link coffeeBracket SrceryYellow
" }}}

" Ruby: {{{
hi! link rubyStringDelimiter SrceryGreen
hi! link rubyInterpolationDelimiter SrceryCyan
hi! link rubyDefine Keyword
" }}}

" ObjectiveC: {{{
hi! link objcTypeModifier SrceryRed
hi! link objcDirective SrceryBlue
" }}}

" Go: {{{
hi! link goDirective SrceryCyan
hi! link goConstants SrceryMagenta
hi! link goDeclaration SrceryRed
hi! link goDeclType SrceryBlue
hi! link goBuiltins SrceryYellow
" }}}

" Lua: {{{
hi! link luaIn SrceryRed
hi! link luaFunction SrceryCyan
hi! link luaTable SrceryYellow
" }}}

" MoonScript: {{{
hi! link moonSpecialOp SrceryBrightWhite
hi! link moonExtendedOp SrceryBrightWhite
hi! link moonFunction SrceryBrightWhite
hi! link moonObject SrceryYellow
" }}}

" Java: {{{
hi! link javaAnnotation SrceryBlue
hi! link javaDocTags SrceryCyan
hi! link javaCommentTitle vimCommentTitle
hi! link javaParen SrceryBrightWhite
hi! link javaParen1 SrceryBrightWhite
hi! link javaParen2 SrceryBrightWhite
hi! link javaParen3 SrceryBrightWhite
hi! link javaParen4 SrceryBrightWhite
hi! link javaParen5 SrceryBrightWhite
hi! link javaOperator SrceryYellow

hi! link javaVarArg SrceryGreen
" }}}

" Elixir: {{{
hi! link elixirDocString Comment

hi! link elixirStringDelimiter SrceryGreen
hi! link elixirInterpolationDelimiter SrceryCyan
" }}}

" Scala: {{{
" NB: scala vim syntax file is kinda horrible
hi! link scalaNameDefinition SrceryBlue
hi! link scalaCaseFollowing SrceryBlue
hi! link scalaCapitalWord SrceryBlue
hi! link scalaTypeExtension SrceryBlue

hi! link scalaKeyword SrceryRed
hi! link scalaKeywordModifier SrceryRed

hi! link scalaSpecial SrceryCyan
hi! link scalaOperator SrceryBlue

hi! link scalaTypeDeclaration SrceryYellow
hi! link scalaTypeTypePostDeclaration SrceryYellow

hi! link scalaInstanceDeclaration SrceryBlue
hi! link scalaInterpolation SrceryCyan
" }}}

" Markdown: {{{
hi markdownItalic FG(BRIGHT_WHITE) BG(NONE) ATTR(italic)

hi! link markdownH1 SrceryGreenBold
hi! link markdownH2 SrceryGreenBold
hi! link markdownH3 SrceryYellowBold
hi! link markdownH4 SrceryYellowBold
hi! link markdownH5 SrceryYellow
hi! link markdownH6 SrceryYellow

hi! link markdownCode SrceryCyan
hi! link markdownCodeBlock SrceryCyan
hi! link markdownCodeDelimiter SrceryCyan

hi! link markdownBlockquote SrceryBrightBlack
hi! link markdownListMarker SrceryBrightBlack
hi! link markdownOrderedListMarker SrceryBrightBlack
hi! link markdownRule SrceryBrightBlack
hi! link markdownHeadingRule SrceryBrightBlack

hi! link markdownUrlDelimiter SrceryBrightWhite
hi! link markdownLinkDelimiter SrceryBrightWhite
hi! link markdownLinkTextDelimiter SrceryBrightWhite

hi! link markdownHeadingDelimiter SrceryYellow
hi! link markdownUrl SrceryMagenta
hi! link markdownUrlTitleDelimiter SrceryGreen

hi markdownLinkText FG(BRIGHT_BLACK) BG(NONE) ATTR(underline)
hi! link markdownIdDeclaration markdownLinkText
" }}}

" Haskell: {{{
" hi! link haskellType SrceryYellow
" hi! link haskellOperators SrceryYellow
" hi! link haskellConditional SrceryCyan
" hi! link haskellLet SrceryYellow

hi! link haskellType SrceryBlue
hi! link haskellIdentifier SrceryBlue
hi! link haskellSeparator SrceryBlue
hi! link haskellDelimiter SrceryBrightWhite
hi! link haskellOperators SrceryBlue
"
hi! link haskellBacktick SrceryYellow
hi! link haskellStatement SrceryYellow
hi! link haskellConditional SrceryYellow

hi! link haskellLet SrceryCyan
hi! link haskellDefault SrceryCyan
hi! link haskellWhere SrceryCyan
hi! link haskellBottom SrceryCyan
hi! link haskellBlockKeywords SrceryCyan
hi! link haskellImportKeywords SrceryCyan
hi! link haskellDeclKeyword SrceryCyan
hi! link haskellDeriving SrceryCyan
hi! link haskellAssocType SrceryCyan

hi! link haskellNumber SrceryMagenta
hi! link haskellPragma SrceryMagenta

hi! link haskellString SrceryGreen
hi! link haskellChar SrceryGreen
" }}}

" Json: {{{
hi! link jsonKeyword Identifier
hi! link jsonQuote SrceryGreen
hi! link jsonBraces SrceryBlue
" }}}

" Rust: {{{
" https://github.com/rust-lang/rust.vim/blob/master/syntax/rust.vim
hi! link rustCommentLineDoc SrceryGreen
hi! link rustModPathSep SrceryBrightBlack
" }}}

" Make: {{{
hi! link makePreCondit SrceryRed
hi! link makeCommands SrceryBrightWhite
hi! link makeTarget SrceryYellow
" }}}

" Sh: {{{
hi shParenError FG(BRIGHT_WHITE) BG(RED_ERROR) ATTR(NONE)
" }}}

" Misc: {{{
hi ExtraWhitespace FG(NONE) BG(RED_ERROR) ATTR(NONE)
" }}}

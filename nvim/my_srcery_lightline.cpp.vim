" Based on https://github.com/srcery-colors/srcery-vim/blob/ecbd5ba9055ad6b78dc47ef4f0894a7da63215f7/autoload/lightline/colorscheme/srcery.vim

" BRIGHT_RED in the replace mode is changed to RED

#include "my_srcery_colors.cpp.vim"

#define COLOR(x) [ STR(x), x ## _CTERM ]

if exists('g:lightline')
  let s:p = {'normal':{}, 'inactive':{}, 'insert':{}, 'replace':{}, 'visual':{}, 'tabline':{}, 'terminal':{}, 'command':{}}

  let s:p.normal.left     = [ [ COLOR(BRIGHT_WHITE), COLOR(XGRAY5) ], [ COLOR(BRIGHT_WHITE), COLOR(XGRAY3) ] ]
  let s:p.normal.right    = [ [ COLOR(BRIGHT_WHITE), COLOR(XGRAY5) ], [ COLOR(BRIGHT_WHITE), COLOR(XGRAY3) ] ]
  let s:p.normal.middle   = [ [ COLOR(BRIGHT_WHITE), COLOR(XGRAY2) ] ]
  let s:p.inactive.right  = [ [ COLOR(BRIGHT_BLACK), COLOR(XGRAY2) ], [ COLOR(BRIGHT_BLACK), COLOR(XGRAY2) ] ]
  let s:p.inactive.left   = [ [ COLOR(BRIGHT_BLACK), COLOR(XGRAY2) ], [ COLOR(BRIGHT_BLACK), COLOR(XGRAY2) ] ]
  let s:p.inactive.middle = [ [ COLOR(XGRAY6), COLOR(XGRAY2) ] ]
  let s:p.insert.left     = [ [ COLOR(BLACK), COLOR(BRIGHT_WHITE) ], [ COLOR(BLACK), COLOR(BRIGHT_BLACK) ] ]
  let s:p.insert.right    = [ [ COLOR(BLACK), COLOR(BRIGHT_WHITE) ], [ COLOR(BLACK), COLOR(BRIGHT_BLACK) ] ]
  let s:p.insert.middle   = [ [ COLOR(BRIGHT_WHITE), COLOR(XGRAY2) ] ]
  let s:p.replace.left    = [ [ COLOR(BRIGHT_WHITE), COLOR(RED) ], [ COLOR(BLACK), COLOR(BRIGHT_BLACK) ] ]
  let s:p.replace.right   = [ [ COLOR(BRIGHT_WHITE), COLOR(RED) ], [ COLOR(BLACK), COLOR(BRIGHT_BLACK) ] ]
  let s:p.replace.middle  = [ [ COLOR(BRIGHT_WHITE), COLOR(XGRAY2) ] ]
  let s:p.visual.left     = [ [ COLOR(BLACK), COLOR(CYAN) ], [ COLOR(BRIGHT_WHITE), COLOR(XGRAY5) ] ]
  let s:p.visual.right    = [ [ COLOR(BLACK), COLOR(CYAN) ], [ COLOR(BRIGHT_WHITE), COLOR(XGRAY5) ] ]
  let s:p.visual.middle   = [ [ COLOR(BRIGHT_WHITE), COLOR(XGRAY2) ] ]
  let s:p.tabline.left    = [ [ COLOR(BRIGHT_BLACK), COLOR(XGRAY2) ] ]
  let s:p.tabline.tabsel  = [ [ COLOR(BRIGHT_WHITE), COLOR(XGRAY5) ] ]
  let s:p.tabline.middle  = [ [ COLOR(BLACK), COLOR(XGRAY2) ] ]
  let s:p.tabline.right   = [ [ COLOR(BRIGHT_WHITE), COLOR(XGRAY5) ] ]
  let s:p.normal.error    = [ [ COLOR(BRIGHT_WHITE), COLOR(RED) ] ]
  let s:p.normal.warning  = [ [ COLOR(BLACK), COLOR(ORANGE) ] ]
  let s:p.terminal.left   = [ [ COLOR(BLACK), COLOR(GREEN) ], [ COLOR(BRIGHT_WHITE), COLOR(XGRAY5) ] ]
  let s:p.terminal.right  = [ [ COLOR(BLACK), COLOR(GREEN) ], [ COLOR(BRIGHT_WHITE), COLOR(XGRAY5) ] ]
  let s:p.terminal.middle = [ [ COLOR(BRIGHT_WHITE), COLOR(XGRAY2) ] ]
  let s:p.command.left    = [ [ COLOR(BLACK), COLOR(YELLOW) ], [ COLOR(BRIGHT_WHITE), COLOR(XGRAY5) ] ]
  let s:p.command.right   = [ [ COLOR(BLACK), COLOR(YELLOW) ], [ COLOR(BRIGHT_WHITE), COLOR(XGRAY5) ] ]
  let s:p.command.middle  = [ [ COLOR(BRIGHT_WHITE), COLOR(XGRAY2) ] ]

  let g:lightline#colorscheme#my_srcery#palette = lightline#colorscheme#flatten(s:p)
endif

" Creates a temporary window to edit a register, useful to edit macros

" TODO: support floating windows?

let s:edit_reg_keycodes = {
      \ "\<CR>": '<CR>',
      \ "\<BS>": '<BS>',
      \ "\<Del>": '<Del>',
      \ "\<Tab>": '<Tab>',
      \ "\<Esc>": '<Esc>',
      \ "\<Up>": '<Up>',
      \ "\<Left>": '<Left>',
      \ "\<Down>": '<Down>',
      \ "\<Right>": '<Right>'
      \ }

function! edit_reg#start()
  let size = v:count == 0 ? 5 : v:count
  execute size "new"
  let b:edit_reg = 1
  setlocal buftype=nofile
  setlocal bufhidden=wipe
  setlocal nobuflisted
  setlocal noswapfile
  setlocal syntax=vim
  let b:reg = v:register
  let content = getreg(b:reg)
  for code in keys(s:edit_reg_keycodes)
    let code_not = s:edit_reg_keycodes[code] " code_notation
    let content = substitute(content, '\C' . code_not, '\\' . code_not, 'g')
    let content = substitute(content, '\C' . code, code_not, 'g')
  endfor
  let lines = split(content, "\n")
  if strgetchar(content, strchars(content)-1) == 10
    let lines = add(lines, '')
  endif
  call setline(1, lines)
  autocmd BufUnload <buffer> call edit_reg#on_exit()
endfunction

function! edit_reg#on_exit()
  let content = join(getline(1, '$'), "\n")
  for code in keys(s:edit_reg_keycodes)
    let code_not = s:edit_reg_keycodes[code]
    let content = substitute(content, '\C\(\\\)\@4<!' . code_not, code, 'g')
    let content = substitute(content, '\C\\' . code_not, code_not, 'g')
  endfor
  call setreg(b:reg, content)
  echo "Register changed"
endfunction

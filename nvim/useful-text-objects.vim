" Partially from https://gist.github.com/habamax/4662821a1dad716f5c18205489203a67 (revision 4)

" number text object
" "inner" only
" supports count
function! s:number_textobj()
  let rx_num = '\d\+\(\.\d\+\)*'
  let n = v:count1
  while search(rx_num, 'ceW')
    if n <= 1
      normal! v
      call search(rx_num, 'bcW')
      break
    endif
    let n -= 1
    normal! w
  endwhile
endfunction

" d - digits
xnoremap <silent> id :<C-u>call <SID>number_textobj()<CR>
onoremap <silent> id :<C-u>call <SID>number_textobj()<CR>

" Indent text object {{{
" TODO: select a paragraph on current indentation level (as in
" `<Plug>(textobj-indent-i)`)?
" TODO: iS to include a line above, aS to include lines above and below?
" TODO: Support count
function! s:indent_textobj(inner)
  if getline('.') =~ '^\s*$'
    let ln_start = s:detect_nearest_line()
    let ln_end = ln_start
  else
    let ln_start = line('.')
    let ln_end = ln_start
  endif

  let indent = indent(ln_start)
  if indent > 0
    while indent(ln_start) >= indent && ln_start > 0
      let ln_start = prevnonblank(ln_start-1)
    endwhile

    while indent(ln_end) >= indent && ln_end <= line('$')
      let ln_end = s:nextnonblank(ln_end+1)
    endwhile
  else
    while indent(ln_start) == 0 && ln_start > 0 && getline(ln_start) !~ '^\s*$'
      let ln_start -= 1
    endwhile
    while indent(ln_start) > 0 && ln_start > 0
      let ln_start = prevnonblank(ln_start-1)
    endwhile
    while indent(ln_start) == 0 && ln_start > 0 && getline(ln_start) !~ '^\s*$'
      let ln_start -= 1
    endwhile

    while indent(ln_end) == 0 && ln_end <= line('$') && getline(ln_end) !~ '^\s*$'
      let ln_end += 1
    endwhile
    while indent(ln_end) > 0 && ln_end <= line('$')
      let ln_end = s:nextnonblank(ln_end+1)
    endwhile
  endif

  if a:inner || indent == 0
    let ln_start = s:nextnonblank(ln_start+1)
  endif

  if a:inner
    let ln_end = prevnonblank(ln_end-1)
  else
    let ln_end = ln_end-1
  endif

  if ln_end < ln_start
    let ln_end = ln_start
  endif

  exe ln_end
  normal! V
  exe ln_start
endfunction

function! s:nextnonblank(lnum) abort
  let res = nextnonblank(a:lnum)
  if res == 0
    let res = line('$')+1
  endif
  return res
endfunction

function! s:detect_nearest_line() abort
  let lnum = line('.')
  let nline = s:nextnonblank(lnum)
  let pline = prevnonblank(lnum)
  if abs(nline - lnum) > abs(pline - lnum) || getline(nline) =~ '^\s*$'
    return pline
  else
    return nline
  endif
endfunction

" s - spaces
xnoremap <silent> is :<C-u>call <SID>indent_textobj(v:true)<CR>
onoremap <silent> is :<C-u>call <SID>indent_textobj(v:true)<CR>
xnoremap <silent> as :<C-u>call <SID>indent_textobj(v:false)<CR>
onoremap <silent> as :<C-u>call <SID>indent_textobj(v:false)<CR>
" }}}

"" Markdown header text object
" * inner object is the text between prev section header(excluded) and the next
"   section of the same level(excluded) or end of file.
" * an object is the text between prev section header(included) and the next section of the same
"   level(excluded) or end of file.
function! s:header_textobj(inner) abort
  let lnum_start = search('^#\+\s\+[^[:space:]=]', "ncbW")
  if lnum_start
    let lvlheader = matchstr(getline(lnum_start), '^#\+')
    let lnum_end = search('^#\{1,'..len(lvlheader)..'}\s', "nW")
    if !lnum_end
      let lnum_end = search('\%$', 'nW')
    else
      let lnum_end -= 1
    endif
    if a:inner && getline(lnum_start + 1) !~ '^#\+\s\+[^[:space:]=]'
      let lnum_start += 1
    endif

    exe lnum_end
    normal! V
    exe lnum_start
  endif
endfunction

xnoremap <silent> im :<C-u>call <SID>header_textobj(v:true)<CR>
onoremap <silent> im :<C-u>call <SID>header_textobj(v:true)<CR>
xnoremap <silent> am :<C-u>call <SID>header_textobj(v:false)<CR>
onoremap <silent> am :<C-u>call <SID>header_textobj(v:false)<CR>

" entire buffer text object
" no ie for now
xnoremap          ae <Esc>ggVG
onoremap <silent> ae :<C-u>normal! ggVG<CR>

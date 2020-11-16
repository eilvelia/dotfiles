" Number text object
" "inner" only
" supports count
" TODO: hex numbers
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

" Indent text object
" supports count, count depends on 'shiftwidth' / 'tabstop'
function! s:indent_textobj(paragraph, around)
  let ln_start = getline('.') =~ '^\s*$' ? s:detect_nearest_line() : line('.')
  let ln_end = ln_start

  if v:count >= 1
    let indent = indent(ln_start) - (v:count - 1) * shiftwidth()
  else
    let indent = indent(ln_start)
  endif

  while ln_start > 1
    if getline(ln_start - 1) =~ '^\s*$'
      if a:paragraph
        break
      endif
    elseif indent(ln_start - 1) < indent
      break
    endif
    let ln_start -= 1
  endwhile

  while ln_end < line('$')
    if getline(ln_end + 1) =~ '^\s*$'
      if a:paragraph
        break
      endif
    elseif indent(ln_end + 1) < indent
      break
    endif
    let ln_end += 1
  endwhile

  if a:around == 2
    if ln_start > 1
      let ln_start -= 1
    endif
    if ln_end < line('$')
      let ln_end += 1
    endif
  elseif a:around == 1 && ln_start > 1
    let ln_start -= 1
  endif

  execute ln_end
  normal! V
  execute ln_start
endfunction

" From https://gist.github.com/habamax/4662821a1dad716f5c18205489203a67 (revision 4)
function! s:detect_nearest_line() abort
  let lnum = line('.')
  let nline = nextnonblank(lnum)
  if nline == 0
    let nline = line('$') + 1
  endif
  let pline = prevnonblank(lnum)
  if abs(nline - lnum) > abs(pline - lnum) || getline(nline) =~ '^\s*$'
    return pline
  else
    return nline
  endif
endfunction

" i - indent
" ii - a paragraph in the same indentation level
" ai - current indentation level
" iI - current indentation level + a line above
" aI - current indentation level + a line above + a line below
xnoremap <silent> ii :<C-u>call <SID>indent_textobj(v:true, 0)<CR>
onoremap <silent> ii :<C-u>call <SID>indent_textobj(v:true, 0)<CR>
xnoremap <silent> ai :<C-u>call <SID>indent_textobj(v:false, 0)<CR>
onoremap <silent> ai :<C-u>call <SID>indent_textobj(v:false, 0)<CR>
xnoremap <silent> iI :<C-u>call <SID>indent_textobj(v:false, 1)<CR>
onoremap <silent> iI :<C-u>call <SID>indent_textobj(v:false, 1)<CR>
xnoremap <silent> aI :<C-u>call <SID>indent_textobj(v:false, 2)<CR>
onoremap <silent> aI :<C-u>call <SID>indent_textobj(v:false, 2)<CR>

" From https://gist.github.com/habamax/4662821a1dad716f5c18205489203a67 (revision 5)
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
      let lnum_end = search('\%$', 'cnW')
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

" m - markdown
xnoremap <silent> im :<C-u>call <SID>header_textobj(v:true)<CR>
onoremap <silent> im :<C-u>call <SID>header_textobj(v:true)<CR>
xnoremap <silent> am :<C-u>call <SID>header_textobj(v:false)<CR>
onoremap <silent> am :<C-u>call <SID>header_textobj(v:false)<CR>

" entire buffer text object
" no ie for now
xnoremap          ae <Esc>ggVG
onoremap <silent> ae :<C-u>normal! ggVG<CR>

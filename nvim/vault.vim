" Protect sensitive information

" From https://github.com/rafi/vim-config/blob/b4bfc5306467c4/plugin/vault.vim

" Don't backup files in temp directories or shm
if exists('&backupskip')
  set backupskip+=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*
endif

" Don't keep swap files in temp directories or shm
augroup swapskip
  autocmd!
  silent! autocmd BufNewFile,BufReadPre
    \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*
    \ setlocal noswapfile
augroup END

" Don't keep undo files in temp directories or shm
if has('persistent_undo')
  augroup undoskip
    autocmd!
    silent! autocmd BufWritePre
      \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*
      \ setlocal noundofile
  augroup END
endif

" Don't keep viminfo for files in temp directories or shm
augroup viminfoskip
  autocmd!
  silent! autocmd BufNewFile,BufReadPre
    \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*
    \ setlocal viminfo=
augroup END

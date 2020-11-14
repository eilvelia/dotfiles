" Protect sensitive information

" Partially from
" https://github.com/rafi/vim-config/blob/b4bfc5306467c4/plugin/vault.vim

if exists('&backupskip')
  set backupskip+=/tmp/*,,*/shm/*,/private/var/*
endif

augroup vault_swapskip
  autocmd!
  silent! autocmd BufNewFile,BufReadPre
    \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*
    \ setlocal noswapfile
augroup END

if has('persistent_undo') && &undofile
  augroup vault_undoskip
    autocmd!
    silent! autocmd BufWritePre
      \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*
      \ setlocal noundofile
  augroup END
endif

if has('nvim')
  augroup vault_shadaskip
    autocmd!
    silent! autocmd BufNewFile,BufReadPre
      \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*
      \ setlocal shada=
  augroup END
else
  augroup vault_viminfoskip
    autocmd!
    silent! autocmd BufNewFile,BufReadPre
      \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*
      \ setlocal viminfo=
  augroup END
endif

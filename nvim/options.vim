set completeopt-=preview

set noshowmode

set concealcursor=nc
set conceallevel=1

set listchars+=conceal:∘
set list

set nostartofline

set scrolloff=1

set foldmethod=indent
set foldlevelstart=6

set sessionoptions-=options

if g:min_mode
  set signcolumn=auto
else
  set signcolumn=yes
endif

if !g:is_gui
  set mouse=a
endif

" set title

set hidden

set number
set relativenumber
set wrap
set showbreak=↳

set noshowmatch

set hlsearch
set smartcase
set ignorecase
set incsearch

set tabstop=2
set softtabstop=0
set shiftwidth=2
set expandtab
set smarttab
set autoindent

set nojoinspaces

set ruler
set whichwrap+=<,>,[,]
set backspace=indent,eol,start

set wildmode=longest,list

set shortmess+=c

set colorcolumn=80

" set cursorline

set splitright

set lazyredraw

set tagcase=smart

" set updatetime=300
set updatetime=3000

" default is 50 in neovim
set ttimeoutlen=10

set visualbell

set termguicolors

" interesting nvim feature
set inccommand=nosplit

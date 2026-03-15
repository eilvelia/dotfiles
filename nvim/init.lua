-- vim: foldmethod=marker

vim.env.VIMDIR = vim.fn.expand('~/.config/nvim')

vim.g.is_gui = vim.fn.has('gui_running')
vim.g.is_mac = vim.fn.has('macunix') or vim.fn.has('mac')

local is_gui = vim.g.is_gui == 1
local is_mac = vim.g.is_mac == 1

-- Minimal mode
local min_mode = vim.g.min_mode == 1

if not min_mode then vim.g.min_mode = 0 end

vim.keymap.set('n', '<Space>', '')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install lazy.nvim if not present {{{
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
-- }}}

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.hl.on_yank() end,
})

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.editorconfig = true

-- Options {{{
vim.o.colorcolumn = '80'
vim.o.concealcursor = 'nc'
vim.o.conceallevel = 0
vim.o.foldlevelstart = 99
vim.o.list = true
vim.o.mousescroll = 'ver:5,hor:6'
vim.o.scrolloff = 1
vim.o.showmode = false
vim.o.signcolumn = 'yes'
vim.o.smoothscroll = true
vim.o.splitright = true
vim.o.tagcase = 'smart'
vim.o.visualbell = true
vim.o.wildmode = 'longest,list'
vim.opt.listchars:append('conceal:∘')
vim.opt.shortmess:append('c')
vim.opt.whichwrap:append('<,>,[,]')

vim.o.title = true
vim.o.titlestring = '%t - NVIM'
vim.o.titlelen = 60

vim.o.number = true
vim.o.relativenumber = true

vim.o.wrap = true
vim.o.showbreak = '↳'
vim.o.linebreak = true

vim.o.smartcase = true
vim.o.ignorecase = true

vim.o.tabstop = 2
vim.o.softtabstop = 0
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smarttab = true

vim.o.cursorline = true
vim.o.cursorlineopt = 'number'

vim.o.ttimeoutlen = 10 -- default is 50

-- Cyrillic keyboard layout in normal mode
vim.opt.langmap:append('ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ')
vim.opt.langmap:append('фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz')
vim.opt.langmap:append('ЁёЖжЭэХхЪъ;~`:;"\'{[}]')

if min_mode then
  vim.o.signcolumn = 'auto'
end

if is_gui then
  vim.o.mouse = 'a'
end
-- }}}

-- Plugins {{{
-- TODO: Explore https://github.com/stevearc/conform.nvim?
require('lazy').setup {
  spec = {
    { 'nvim-tree/nvim-web-devicons', lazy = true },
    { 'tpope/vim-repeat', priority = 100 },
    { 'nvim-telescope/telescope.nvim',
      dependencies = {
        'nvim-lua/plenary.nvim',
        'natecraddock/telescope-zf-native.nvim'
      },
      tag = 'v0.2.1',
      cond = not min_mode,
      event = 'VeryLazy',
      config = function ()
        local actions = require('telescope.actions')
        local telescope = require('telescope')
        telescope.setup {
          defaults = {
            layout_config = {
              width = 0.90,
              height = 0.90,
              preview_width = 0.5,
            },
            mappings = {
              i = {
                ['<Esc>'] = actions.close
              }
            }
          }
        }
        telescope.load_extension('zf-native')
        local builtin = require('telescope.builtin')
        if is_mac and is_gui then
          vim.keymap.set({ 'n', 'v' }, '<D-p>', builtin.find_files, {})
          vim.keymap.set({ 'n', 'v' }, '<D-S-p>', builtin.buffers, {})
        end
        vim.keymap.set('n', '<Space>f', builtin.find_files, {})
        vim.keymap.set('n', '<Space>F', function()
          builtin.find_files { cwd = vim.fn.expand('%:p:h') }
        end, {})
        vim.keymap.set('n', '<Space>b', builtin.buffers, {})
        vim.keymap.set('n', '<Space>/', builtin.live_grep, {})
        vim.keymap.set('n', '<Space>s', builtin.lsp_document_symbols, {})
        vim.keymap.set('n', '<Space>S', builtin.lsp_workspace_symbols, {})
        vim.keymap.set('n', 'gr', builtin.lsp_references, { nowait = true })
        vim.keymap.set('n', '<Space>gs', builtin.git_status, {})
        vim.keymap.set('n', '<Space>d', builtin.diagnostics, {})
        vim.keymap.set('n', '<Space>j', builtin.jumplist, {})
        vim.keymap.set('n', '<Space>\'', builtin.resume, {})
        vim.keymap.set('n', '<Space>*', builtin.builtin, {})
        vim.keymap.set('n', '<Space>H', builtin.help_tags, {})
        vim.keymap.set('n', '<Space>M', builtin.marks, {})
        vim.keymap.set('n', '<Space><Space>r', builtin.registers, {})
        vim.keymap.set('n', '<Space>T', builtin.treesitter, {})
        vim.keymap.set('n', '<Space>L', builtin.current_buffer_fuzzy_find, {})
        vim.keymap.set('n', '<Space>?', builtin.commands, {})
      end
    },
    { 'nvim-lualine/lualine.nvim',
      cond = not min_mode,
      opts = {},
    },
    { 'nvim-treesitter/nvim-treesitter-textobjects',
      branch = 'master'
    },
    { 'nvim-treesitter/nvim-treesitter',
      branch = 'master',
      build = ':TSUpdate',
      dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
      config = function ()
        local configs = require('nvim-treesitter.configs')
        configs.setup {
          -- `:TSInstall all` manually
          -- ensure_installed = {
          --   'lua', 'vim', 'vimdoc', 'query', 'comment', 'c', 'cpp', 'nix',
          --   'html', 'css', 'markdown', 'markdown_inline', 'rst',
          --   'json', 'yaml', 'toml', 'kdl', 'xml',
          --   'javascript', 'typescript', 'jsdoc', 'python', 'ruby',
          --   'ocaml', 'ocaml_interface', 'menhir', 'haskell', 'agda',
          --   'clojure', 'racket', 'scheme', 'elixir', 'erlang',
          --   'rust', 'scala', 'java',
          --   'make', 'ninja', 'cmake', 'dockerfile',
          --   'gpg', 'diff', 'gitcommit', 'git_rebase', 'gitignore', 'git_config',
          -- },
          sync_install = false,
          auto_install = true,
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
          },
          indent = { enable = true },
          textobjects = {
            select = {
              enable = true,
              lookahead = true,
              keymaps = {
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
                ['ac'] = '@comment.outer',
                ['ic'] = '@comment.inner',
              }
            },
            move = {
              enable = true,
              set_jumps = true,
              goto_next_start = {
                [']f'] = '@function.outer',
              },
              goto_next_end = {
                [']F'] = '@function.outer',
              },
              goto_previous_start = {
                ['[f'] = '@function.outer',
              },
              goto_previous_end = {
                ['[F'] = '@function.outer',
              },
            }
          }
        }
      end
    },
    { 'neovim/nvim-lspconfig' },
    { 'saghen/blink.cmp',
      version = '1.*',
      lazy = false,
      opts = {
        keymap = {
          preset = 'none',
          ['<C-e>'] = { 'hide' },
          ['<Tab>'] = { 'accept', 'fallback' },
          ['<C-n>'] = { 'select_next', 'fallback' },
          ['<C-p>'] = { 'select_prev', 'fallback' },
          ['<C-b>'] = { 'scroll_documentation_up' },
          ['<C-f>'] = { 'scroll_documentation_down' },
        },
        sources = {
          default = { 'lsp', 'buffer' },
        },
        completion = { documentation = { auto_show = true } },
      },
    },
    { 'https://codeberg.org/andyg/leap.nvim',
      dependencies = { 'tpope/vim-repeat' },
      config = function ()
        vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap-forward)')
        vim.keymap.set({'n', 'x', 'o'}, 'S', '<Plug>(leap-backward)')
      end
    },
    { 'nvim-mini/mini.operators',
      config = function()
        local ops = require('mini.operators')
        ops.setup {
          evaluate = { prefix = '' },
          exchange = { prefix = '', reindent_linewise = true },
          multiply = { prefix = '' },
          replace  = { prefix = '', reindent_linewise = true },
          sort     = { prefix = '' },
        }
        ops.make_mappings('exchange', { textobject = 'cx', line = 'cxx', selection = 'X' })
        ops.make_mappings('replace', { textobject = 'cp', line = 'cpp', selection = '' })
      end,
    },
    { 'numToStr/Comment.nvim', opts = {} }, -- TODO: remove?
    { 'lewis6991/gitsigns.nvim',
      cond = not min_mode,
      opts = {
        on_attach = function (bufnr)
          local gitsigns = require('gitsigns')

          local function map (mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']h', function()
            if vim.wo.diff then
              vim.cmd.normal({ ']h', bang = true })
            else
              gitsigns.nav_hunk('next')
            end
          end)

          map('n', '[h', function()
            if vim.wo.diff then
              vim.cmd.normal({ '[h', bang = true })
            else
              gitsigns.nav_hunk('prev')
            end
          end)

          -- Actions
          map('n', '<Space>hs', gitsigns.stage_hunk)
          map('n', '<Space>hr', gitsigns.reset_hunk)
          map('v', '<Space>hs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
          map('v', '<Space>hr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
          map('n', '<Space>hS', gitsigns.stage_buffer)
          map('n', '<Space>hu', gitsigns.undo_stage_hunk)
          map('n', '<Space>hR', gitsigns.reset_buffer)
          map('n', '<Space>hp', gitsigns.preview_hunk)
          map('n', '<Space>hi', gitsigns.preview_hunk_inline)
          map('n', '<Space>hb', function() gitsigns.blame_line { full = true } end)
          map('n', '<Space>hd', gitsigns.diffthis)
          map('n', '<Space>hD', function() gitsigns.diffthis('~') end)
          map('n', '<Space>hQ', function() gitsigns.setqflist('all') end)
          map('n', '<Space>hq', gitsigns.setqflist)
          map('n', '<Space>htb', gitsigns.toggle_current_line_blame)
          map('n', '<Space>htd', gitsigns.toggle_deleted)
          map('n', '<Space>htw', gitsigns.toggle_word_diff)

          -- Text object
          map({'o', 'x'}, 'ih', gitsigns.select_hunk)
        end
      }
    },
    { 'kylechui/nvim-surround',
      version = '^4.0.0',
      event = 'VeryLazy',
      init = function()
        vim.g.nvim_surround_no_visual_mappings = true
      end,
      config = function()
        require('nvim-surround').setup()
        vim.keymap.set('x', 'gs', '<Plug>(nvim-surround-visual)')
        vim.keymap.set('x', 'gS', '<Plug>(nvim-surround-visual-line)')
      end,
    },
    { 'RRethy/vim-illuminate',
      cond = not min_mode,
    },
    { 'saghen/blink.indent',
      opts = {
        scope = { enabled = false },
      },
    },
    { 'tversteeg/registers.nvim',
      name = 'registers',
      config = true,
      keys = {
        { '"', mode = { 'n', 'v' } },
        { '<C-R>', mode = 'i' }
      },
      cmd = 'Registers',
    },
    { 'catgoose/nvim-colorizer.lua',
      cmd = { 'ColorizerToggle', 'ColorizerAttachToBuffer', 'ColorizerDetachFromBuffer' },
      opts = {},
    },
    { 'wellle/targets.vim',
      init = function ()
        vim.g.targets_seekRanges = 'cc cr cb cB lc ac Ac lr lb ar ab lB Ar aB Ab AB rr ll rb al rB Al bb aa bB Aa BB AA'
      end
    },
    { 'stevearc/quicker.nvim',
      ft = 'qf',
      opts = {},
    },
    { 'nvim-tree/nvim-tree.lua',
      cmd = { 'NvimTreeToggle' },
      opts = {},
      init = function ()
        vim.keymap.set('n', '<Space>t', ':NvimTreeToggle<CR>')
      end,
    },
    { 'stevearc/oil.nvim',
      cond = not min_mode,
      opts = {},
      lazy = false,
    },
    { 'folke/zen-mode.nvim',
      cmd = 'ZenMode',
      opts = {},
    },
    { 'mbbill/undotree', cmd = 'UndotreeToggle' },
    -- Languages
    { 'tjdevries/ocaml.nvim',
      cond = not min_mode,
      build = 'make',
      -- opts = {},
    },
    -- Themes
    { 'loctvl842/monokai-pro.nvim',
      lazy = false,
      priority = 1000,
      config = function()
        require('monokai-pro').setup {
          override = function (c)
            return {
              ["@punctuation.bracket"] = { fg = c.base.dimmed2 },
              LspCodeLens = { fg = c.base.dimmed3 },
              BlinkIndent = { fg = c.editorIndentGuide.background },
              BlinkIndentOrange = { fg = c.editorIndentGuide.activeBackground },
              BlinkIndentViolet = { fg = c.editorIndentGuide.activeBackground },
              BlinkIndentBlue = { fg = c.editorIndentGuide.activeBackground },
              MiniOperatorsExchangeFrom = { bg = c.base.dimmed4 },
            }
          end
        }
        vim.cmd.colorscheme 'monokai-pro'
      end
    }
  },
  checker = { enabled = false },
  rocks = { enabled = false },
}
-- }}}

-- LSP Configuration {{{
vim.keymap.set('n', '<LocalLeader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<LocalLeader>ls', vim.diagnostic.setloclist)
vim.diagnostic.config {
  virtual_text = { severity = { min = vim.diagnostic.severity.ERROR } },
  signs = true,
  underline = true
}
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function (ev)
    -- Buffer local mappings.
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = ev.buf, nowait = true })
    vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gh', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<LocalLeader>k', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<LocalLeader>la', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<LocalLeader>lr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<LocalLeader>ll', function ()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<LocalLeader>r', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<LocalLeader>a', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<LocalLeader>qf', function ()
      vim.lsp.buf.code_action { only = { 'quickfix' } }
    end, opts)
    vim.keymap.set('n', '<LocalLeader>=', function ()
      vim.lsp.buf.format { async = true }
    end, opts)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.supports_method('textDocument/inlayHint') then
      vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
    end
    if client and client.supports_method('textDocument/codeLens') then
      vim.lsp.codelens.refresh({ bufnr = ev.buf })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave' }, {
        buffer = ev.buf,
        callback = function() vim.lsp.codelens.refresh({ bufnr = ev.buf }) end,
      })
    end
  end
})

vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities()),
})

vim.lsp.config('ocamllsp', {
  -- TODO: Add keybinding for ocamllsp/switchImplIntf
  settings = {
    inlayHints = { enable = true },
    -- codelens = { enable = true }
  },
})

vim.lsp.enable('ts_ls')
vim.lsp.enable('ocamllsp')
-- }}}

-- Custom functions {{{
-- Some fairly old functions implemented in viml
vim.cmd [[
" strip trailing whitespace
function! s:strip_trailing_whitespace() abort
  if &binary
    echoerr 'Cannot strip whitespace in a binary file.'
    return
  endif
  let old_pattern = @/
  %s/\s\+$//e
  let @/ = old_pattern
endfunction
command! StripTrailingWhitespace call <SID>strip_trailing_whitespace()

function! s:execute_vim() range
  let lines = getline(a:firstline, a:lastline)
  for line in lines
    execute line
  endfor
endfunction
command! -range ExecuteVim <line1>,<line2>call <SID>execute_vim()

" Delete [No Name] buffers
function! s:delete_unnamed_buffers() abort
  let bufs = filter(range(1, bufnr('$')), 'bufexists(v:val) && bufname(v:val) ==# ""')
  if !empty(bufs)
    " Doesn't delete buffers with unsaved changes
    execute 'bdelete' join(bufs)
  endif
endfunction
command! DeleteUnnamedBuffers call <SID>delete_unnamed_buffers()

command! -count EditReg call edit_reg#start()
command! SyntaxAttr call syntax_attr#main()
]]
-- }}}

-- Mappings {{{
if is_mac then
  -- Apple ISO keyboards
  vim.keymap.set({ 'n', 'v', 'o' }, '§', '`', { remap = true })
end

vim.keymap.set({ 'n', 'v' }, '<C-s>', '<Cmd>update<CR>', { silent = true })

vim.keymap.set('n', '<BS>', '"_X')
vim.keymap.set('n', '<S-BS>', '"_x')

-- More convenient keybindings for yank/paste using the system clipboard (inspired from helix)
vim.keymap.set({ 'n', 'v' }, '<Space>y', '"+y')
vim.keymap.set({ 'n', 'v' }, '<Space>Y', '"+Y')
vim.keymap.set({ 'n', 'v' }, '<Space>p', '"+p')
vim.keymap.set({ 'n', 'v' }, '<Space>P', '"+P')

-- Delete words on ctrl-backspace
vim.keymap.set({ 'i', 'c' }, '<C-BS>', '<C-w>')

-- Swap ^ and 0
vim.keymap.set({ 'n', 'v', 'o' }, '0', '^')
vim.keymap.set({ 'n', 'v', 'o' }, '^', '0')

-- optional <Space><digit> for symbols instead of shift-<digit>
vim.keymap.set({ 'n', 'v', 'o' }, '<Space>1', '!')
vim.keymap.set({ 'n', 'v', 'o' }, '<Space>2', '@')
vim.keymap.set({ 'n', 'v', 'o' }, '<Space>3', '#')
vim.keymap.set({ 'n', 'v', 'o' }, '<Space>4', '$')
vim.keymap.set({ 'n', 'v', 'o' }, '<Space>5', '%')
vim.keymap.set({ 'n', 'v', 'o' }, '<Space>6', '0')
vim.keymap.set({ 'n', 'v', 'o' }, '<Space>7', '&')
vim.keymap.set({ 'n', 'v', 'o' }, '<Space>8', '*')

vim.keymap.set('n', 'c<Tab>', ':let @/=expand(\'<cword>\')<CR>cgn', { silent = true })

vim.keymap.set({ 'n', 'v' }, '<Space>n', ':normal ')

-- Disable the q: command history (too easy to hit it accidentally)
vim.keymap.set('n', 'q:', '')
-- ^ Adds delay to `q` due to ambiguity. v This fixes it.
vim.keymap.set('n', 'q', 'q', { nowait = true })
vim.keymap.set('n', '<Space><Space>q', 'q:')

vim.keymap.set('n', 'Q', '')

-- Clear the search selection (very useful!)
vim.keymap.set({ 'n', 'v' }, '<Space>c', function () vim.fn.setreg('/', '') end)

-- Previous (last used) buffer
vim.keymap.set('n', 'ga', '<Cmd>b#<CR>', { silent = true })

-- Remove trailing newlines from a register
vim.keymap.set('n', '<Space><Space>n', function ()
  local reg = vim.v.register
  vim.fn.setreg(reg, vim.fn.substitute(reg, '\n+$', '', 'g'))
end)

-- Window mappings {{{
-- <Space>w alias for <C-w> (as in helix)
vim.keymap.set({ 'n', 'v' }, '<Space>w', '<C-w>', { remap = true })

vim.keymap.set('n', '<C-w><S-Left>', '<C-w>H')
vim.keymap.set('n', '<C-w><S-Right>', '<C-w>L')
vim.keymap.set('n', '<C-w><S-Up>', '<C-w>K')
vim.keymap.set('n', '<C-w><S-Down>', '<C-w>J')

vim.keymap.set('n', '<A-Left>', '<C-w><Left>')
vim.keymap.set('n', '<A-Right>', '<C-w><Right>')
vim.keymap.set('n', '<A-Up>', '<C-w><Up>')
vim.keymap.set('n', '<A-Down>', '<C-w><Down>')

vim.keymap.set('n', '<A-S-Left>', '<C-w>H')
vim.keymap.set('n', '<A-S-Right>', '<C-w>L')
vim.keymap.set('n', '<A-S-Up>', '<C-w>K')
vim.keymap.set('n', '<A-S-Down>', '<C-w>J')

vim.keymap.set('n', '<A-h>', '<C-w><Left>')
vim.keymap.set('n', '<A-l>', '<C-w><Right>')
vim.keymap.set('n', '<A-k>', '<C-w><Up>')
vim.keymap.set('n', '<A-j>', '<C-w><Down>')

vim.keymap.set('n', '<A-S-h>', '<C-w>H')
vim.keymap.set('n', '<A-S-l>', '<C-w>L')
vim.keymap.set('n', '<A-S-k>', '<C-w>K')
vim.keymap.set('n', '<A-S-j>', '<C-w>J')

-- window to tab
vim.keymap.set('n', '<A-t>', '<C-w>T')

-- change height
vim.keymap.set('n', '<A-->', '<C-w>-')
vim.keymap.set('n', '<A-=>', '<C-w>+')

-- change width
vim.keymap.set('n', '<A-.>', '<C-w>>')
vim.keymap.set('n', '<A-,>', '<C-w><')
-- }}}

-- Terminal mappings {{{
vim.keymap.set('t', '<C-.>', '<C-\\><C-n>')
-- }}}

vim.keymap.set('n', '<Space><Space>e', ':EditReg<CR>')

-- Change file wrapping
vim.keymap.set('n', '<Space><Space>w',     ':setlocal wrap!<CR>:setlocal wrap?<CR>')
-- Change file indentation
vim.keymap.set('n', '<Space><Space>s',     ':set expandtab   tabstop=2 shiftwidth=2 softtabstop=0<CR>')
vim.keymap.set('n', '<Space><Space>S',     ':set expandtab   tabstop=4 shiftwidth=4 softtabstop=0<CR>')
vim.keymap.set('n', '<Space><Space>t',     ':set noexpandtab tabstop=2 shiftwidth=2 softtabstop=0<CR>')
vim.keymap.set('n', '<Space><Space>T',     ':set noexpandtab tabstop=4 shiftwidth=4 softtabstop=0<CR>')
vim.keymap.set('n', '<Space><Space><A-t>', ':set noexpandtab tabstop=8 shiftwidth=8 softtabstop=0<CR>')

-- Tab mappings {{{
-- Move tabs
vim.keymap.set('n', '<A-[>', ':-tabmove<CR>', { silent = true })
vim.keymap.set('n', '<A-]>', ':+tabmove<CR>', { silent = true })

-- Select tab via g1..g9 or alt-1..alt-9
for i = 1, 9 do
  local cmd = '<Cmd>tabn ' .. i .. '<CR>'
  vim.keymap.set('n', 'g' .. i, cmd, { silent = true })
  vim.keymap.set('n', '<A-' .. i .. '>', cmd, { silent = true })
end

if is_gui then
  vim.keymap.set({ 'n', 'v' }, '<C-Tab>',   '<Cmd>tabn<CR>', { silent = true })
  vim.keymap.set({ 'n', 'v' }, '<C-S-Tab>', '<Cmd>tabp<CR>', { silent = true })
  if is_mac then
    vim.keymap.set({ 'n', 'v' }, '<D-A-Right>', '<Cmd>tabn<CR>', { silent = true })
    vim.keymap.set({ 'n', 'v' }, '<D-A-Left>',  '<Cmd>tabp<CR>', { silent = true })
    -- Select tab via cmd+1..cmd+9
    for i = 1, 9 do
      vim.keymap.set('n', '<D-' .. i .. '>', '<Cmd>tabn ' .. i .. '<CR>', { silent = true })
    end
  end
end
-- }}}

-- Some gui Mac-specific mappings
if is_mac and is_gui then
  vim.keymap.set({ 'n', 'i' }, '<D-S-d>', '<Cmd>t.<CR>') -- dup line
  vim.keymap.set({ 'n', 'v' }, '<D-f>', '/')
  vim.keymap.set({ 'n', 'v' }, '<D-S-f>', '?')
end
-- }}}

vim.cmd [[
  source $VIMDIR/vault.vim
  source $VIMDIR/useful-text-objects.vim
]]

if not min_mode then
  vim.g.exrc = true
  vim.g.secure = true
end

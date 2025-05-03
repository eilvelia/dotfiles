-- vim: foldmethod=marker

vim.env.VIMDIR = vim.fn.expand('~/.config/nvim')

local is_gui = vim.fn.has('gui_running')
local is_mac = vim.fn.has('macunix') or vim.fn.has('mac')

vim.g.is_gui = is_gui
vim.g.is_mac = is_mac

-- Minimal mode
local min_mode = vim.g.min_mode == 1

if not min_mode then vim.g.min_mode = 0 end

if vim.fn.has('vim_starting') then
  vim.keymap.set('n', '<Space>', '')
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '
end

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
vim.o.scrolloff = 1
vim.o.showmode = false
vim.o.signcolumn = 'yes'
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
-- TODO: try nvim-spider?
-- TODO: try blink.cmp instead of nvim-cmp?
require('lazy').setup {
  spec = {
    { 'nvim-tree/nvim-web-devicons', lazy = true },
    { 'tpope/vim-repeat', priority = 100 },
    { 'nvim-telescope/telescope.nvim',
      dependencies = {
        'nvim-lua/plenary.nvim',
        'natecraddock/telescope-zf-native.nvim'
      },
      tag = '0.1.8',
      cond = not min_mode,
      config = function ()
        local actions = require('telescope.actions')
        local telescope = require('telescope')
        telescope.setup {
          defaults = {
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
        -- TODO: F to include hidden files?
        vim.keymap.set('n', '<Space>b', builtin.buffers, {})
        vim.keymap.set('n', '<Space>/', builtin.live_grep, {})
        vim.keymap.set('n', '<Space>s', builtin.lsp_document_symbols, {})
        vim.keymap.set('n', '<Space>S', builtin.lsp_workspace_symbols, {})
        vim.keymap.set('n', '<Space>gr', builtin.lsp_references, {})
        vim.keymap.set('n', '<Space>d', builtin.diagnostics, {})
        vim.keymap.set('n', '<Space>j', builtin.jumplist, {})
        vim.keymap.set('n', '<Space>\'', builtin.resume, {})
        vim.keymap.set('n', '<Space>uf', builtin.builtin, {})
        vim.keymap.set('n', '<Space>uh', builtin.help_tags, {})
        vim.keymap.set('n', '<Space>um', builtin.marks, {})
        vim.keymap.set('n', '<Space>ur', builtin.registers, {})
        vim.keymap.set('n', '<Space>ut', builtin.treesitter, {})
        vim.keymap.set('n', '<Space>ug', builtin.current_buffer_fuzzy_find, {})
      end
    },
    { 'nvim-lualine/lualine.nvim',
      cond = not min_mode,
      opts = {},
    },
    { 'nvim-treesitter/nvim-treesitter',
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
    { 'hrsh7th/nvim-cmp',
      cond = not min_mode,
      dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
      },
      config = function ()
        local cmp = require('cmp')
        cmp.setup {
          enabled = function ()
            local in_prompt = vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt'
            if in_prompt then return false end
            if vim.api.nvim_get_mode().mode == 'c' then return true end
            local context = require('cmp.config.context')
            return not context.in_treesitter_capture('comment')
              and not context.in_syntax_group('Comment')
              and not context.in_treesitter_capture('string')
              and not context.in_syntax_group('String')
          end,
          mapping = {
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<Tab>'] = cmp.mapping(function (fallback)
              if cmp.visible() then
                cmp.select_next_item()
              -- elseif luasnip.expand_or_jumpable() then
              --   luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function (fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              -- elseif luasnip.jumpable(-1) then
              --   luasnip.jump(-1)
              else
                fallback()
              end
            end, { 'i', 's' }),
          },
          sources = {
            { name = 'nvim_lsp' },
            { name = 'buffer' },
          }
        }
      end
    },
    { 'ggandor/leap.nvim',
      dependencies = { 'tpope/vim-repeat' },
      config = function ()
        -- TODO: Resolve leap/surround conflicts?
        require('leap').add_default_mappings()
      end
    },
    { 'numToStr/Comment.nvim',
      opts = {},
    },
    { 'lewis6991/gitsigns.nvim',
      cond = not min_mode,
      config = function ()
        require('gitsigns').setup {
          on_attach = function (bufnr)
            local gs = package.loaded.gitsigns

            local function map (mode, l, r, opts)
              opts = opts or {}
              opts.buffer = bufnr
              vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map('n', ']h', function ()
              if vim.wo.diff then return ']h' end
              vim.schedule(function() gs.next_hunk() end)
              return '<Ignore>'
            end, { expr = true })

            map('n', '[h', function ()
              if vim.wo.diff then return '[h' end
              vim.schedule(function() gs.prev_hunk() end)
              return '<Ignore>'
            end, { expr = true })

            -- Actions
            map('n', '<Space>hs', gs.stage_hunk)
            map('n', '<Space>hr', gs.reset_hunk)
            map('v', '<Space>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
            map('v', '<Space>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
            map('n', '<Space>hS', gs.stage_buffer)
            map('n', '<Space>hu', gs.undo_stage_hunk)
            map('n', '<Space>hR', gs.reset_buffer)
            map('n', '<Space>hp', gs.preview_hunk)
            map('n', '<Space>hb', function() gs.blame_line { full = true } end)
            map('n', '<Space>htb', gs.toggle_current_line_blame)
            map('n', '<Space>hd', gs.diffthis)
            map('n', '<Space>hD', function() gs.diffthis('~') end)
            map('n', '<Space>htd', gs.toggle_deleted)

            -- Text object
            map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
          end
        }
      end },
    { 'kylechui/nvim-surround',
      version = '^3.0.0',
      event = 'VeryLazy',
      config = function ()
        require('nvim-surround').setup {}
      end
    },
    { 'RRethy/vim-illuminate',
      cond = not min_mode,
    },
    { 'lukas-reineke/indent-blankline.nvim',
      main = 'ibl',
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
    { 'NvChad/nvim-colorizer.lua',
      cmd = { 'ColorizerToggle', 'ColorizerAttachToBuffer', 'ColorizerDetachFromBuffer' },
      opts = {},
    },
    { 'wellle/targets.vim',
      init = function ()
        vim.g.targets_seekRanges = 'cc cr cb cB lc ac Ac lr lb ar ab lB Ar aB Ab AB rr ll rb al rB Al bb aa bB Aa BB AA'
      end
    },
    { 'nvim-tree/nvim-tree.lua',
      cmd = { 'NvimTreeToggle' },
      init = function ()
        vim.keymap.set('n', '<Space>t', ':NvimTreeToggle<CR>')
      end,
      config = function ()
        require('nvim-tree').setup()
      end
    },
    { 'junegunn/goyo.vim', cmd = 'Goyo' },
    { 'mbbill/undotree', cmd = 'UndotreeToggle' },
    -- Languages
    { 'tjdevries/ocaml.nvim',
      build = ':lua require(\'ocaml\').update()',
      config = function ()
        -- vim.api.nvim_set_hl(0, '@rapper_argument', { link = '@parameter', default = true })
        -- vim.api.nvim_set_hl(0, '@rapper_return', { link = '@type', default = true })
      end
    },
    -- Theme
    { 'projekt0n/github-nvim-theme',
      lazy = false,
      priority = 1000,
      config = function ()
        require('github-theme').setup {
          options = {
            transparent = false
          }
        }
        vim.cmd.colorscheme 'github_dark_dimmed'
      end
    },
  },
  -- install = { colorscheme = { 'github_dark_dimmed' } },
  checker = { enabled = false },
  rocks = { enabled = false },
}
-- }}}

-- LSP Configuration {{{
vim.keymap.set('n', '<LocalLeader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<LocalLeader>ls', vim.diagnostic.setloclist)
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function (ev)
    -- Buffer local mappings.
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = ev.buf, nowait = true })
    vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<LocalLeader>k', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.signature_help, opts)
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
    vim.keymap.set('n', '<LocalLeader><LocalLeader>f', function ()
      vim.lsp.buf.format { async = true }
    end, opts)
  end
})

vim.lsp.config('ocamllsp', {
  -- TODO: Add keybinding for ocamllsp/switchImplIntf
  settings = {
    codelens = { enable = true }
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

vim.keymap.set('n', '<BS>', '"_X')
vim.keymap.set('n', '<S-BS>', '"_x')

-- More convenient keybindings for yank/paste using the system clipboard (inspired from helix)
vim.keymap.set({ 'n', 'v' }, '<Space>y', '"+y')
vim.keymap.set({ 'n', 'v' }, '<Space>Y', '"+Y')
vim.keymap.set({ 'n', 'v' }, '<Space>p', '"+p')
vim.keymap.set({ 'n', 'v' }, '<Space>P', '"+P')

-- Alias for the system register
vim.keymap.set({ 'n', 'v', 'o' }, '<Space>=', '=+')

-- Delete words on ctrl-backspace
vim.keymap.set({ 'i', 'c' }, '<C-BS>', '<C-w>')

-- Swap ^ and 0
vim.keymap.set({ 'n', 'v', 'o' }, '0', '^')
vim.keymap.set({ 'n', 'v', 'o' }, '^', '0')

-- Space as an alias for Shift in the case of symbol keymappings
vim.keymap.set({ 'n', 'v', 'o' }, '<Space>1', '!')
vim.keymap.set({ 'n', 'v', 'o' }, '<Space>2', '@')
vim.keymap.set({ 'n', 'v', 'o' }, '<Space>3', '#')
vim.keymap.set({ 'n', 'v', 'o' }, '<Space>4', '$')
vim.keymap.set({ 'n', 'v', 'o' }, '<Space>5', '%')
vim.keymap.set({ 'n', 'v', 'o' }, '<Space>6', '0')
vim.keymap.set({ 'n', 'v', 'o' }, '<Space>7', '&')
vim.keymap.set({ 'n', 'v', 'o' }, '<Space>8', '*')

vim.keymap.set('n', 'c<Tab>', ':let @/=expand(\'<cword>\')<CR>cgn', { silent = true })

-- Helix-style line movement
vim.keymap.set({ 'n', 'v', 'o' }, 'gl', '$')
vim.keymap.set({ 'n', 'v', 'o' }, 'gh', '0')
vim.keymap.set({ 'n', 'v', 'o' }, 'gs', '^')

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
  local reg = vim.fn.getreg()
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
vim.keymap.set('t', '<C-.>', '<C-\\><C-n')
-- }}}

vim.keymap.set('n', '<Space><Space>e', ':EditReg<CR>')
vim.keymap.set('n', '<Space><Space>a', ':SyntaxAttr<CR>')

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

-- Select tab via g1..g2
vim.keymap.set('n', 'g1', ':tabn 1<CR>', { silent = true })
vim.keymap.set('n', 'g2', ':tabn 2<CR>', { silent = true })
vim.keymap.set('n', 'g3', ':tabn 3<CR>', { silent = true })
vim.keymap.set('n', 'g4', ':tabn 4<CR>', { silent = true })
vim.keymap.set('n', 'g5', ':tabn 5<CR>', { silent = true })
vim.keymap.set('n', 'g6', ':tabn 6<CR>', { silent = true })
vim.keymap.set('n', 'g7', ':tabn 7<CR>', { silent = true })
vim.keymap.set('n', 'g8', ':tabn 8<CR>', { silent = true })
vim.keymap.set('n', 'g9', ':tabn 9<CR>', { silent = true })

if is_gui then
  vim.keymap.set({ 'n', 'v' }, '<C-Tab>',   '<Cmd>tabn<CR>', { silent = true })
  vim.keymap.set({ 'n', 'v' }, '<C-S-Tab>', '<Cmd>tabp<CR>', { silent = true })
  if is_mac then
    vim.keymap.set({ 'n', 'v' }, '<D-A-Right>', '<Cmd>tabn<CR>', { silent = true })
    vim.keymap.set({ 'n', 'v' }, '<D-A-Left>',  '<Cmd>tabp<CR>', { silent = true })
    -- Select tab using cmd+1..cmd+9
    for i = 1, 9 do
      vim.keymap.set('n', '<D-' .. i .. '>', '<Cmd>tabn ' .. i .. '<CR>', { silent = true })
    end
  end
end
-- }}}

-- Some gui Mac-specific mappings
if is_mac and is_gui then
  vim.keymap.set({ 'n', 'i' }, '<D-S-d', '<Cmd>t.<CR>') -- dup line
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

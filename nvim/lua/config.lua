local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

local min_mode = vim.g.min_mode == 1
local is_gui = vim.g.is_gui == 1
local is_mac = vim.g.is_mac == 1

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- TODO: try nvim-spider?

require('lazy').setup {
  { 'nvim-tree/nvim-web-devicons', lazy = true },
  { 'tpope/vim-repeat', priority = 100 },
  { 'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'natecraddock/telescope-zf-native.nvim',
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
    end },
  { 'nvim-lualine/lualine.nvim',
    cond = not min_mode,
    config = function ()
      require('lualine').setup()
    end },
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
        highlight = { enable = true },
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
    end },
  { 'neovim/nvim-lspconfig',
    cond = not min_mode,
    dependencies = { 'hrsh7th/cmp-nvim-lsp' },
    config = function ()
      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      lspconfig.ocamllsp.setup {
        capabilities = capabilities,
        get_language_id = function(_, ftype) return ftype end,
        settings = {
          codelens = { enable = true },
        },
        on_attach = function (client, bufnr)
          client.server_capabilities.semanticTokensProvider = nil
        end,
      }
      lspconfig.tsserver.setup { capabilities = capabilities }
      vim.keymap.set('n', '<LocalLeader>e', vim.diagnostic.open_float)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
      vim.keymap.set('n', '<LocalLeader>ls', vim.diagnostic.setloclist)
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function (ev)
          -- Enable completion triggered by <c-x><c-o>
          -- vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- Buffer local mappings.
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
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
    end },
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
    end },
  { 'ggandor/leap.nvim',
    dependencies = { 'tpope/vim-repeat' },
    config = function ()
      -- TODO: Resolve leap/surround conflicts?
      require('leap').add_default_mappings()
    end },
  { 'numToStr/Comment.nvim',
    config = function ()
      require('Comment').setup()
    end },
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
    version = '*',
    config = function ()
      require('nvim-surround').setup()
    end },
  { 'RRethy/vim-illuminate', cond = not min_mode },
  { 'lukas-reineke/indent-blankline.nvim',
    config = function ()
      require('ibl').setup {
        scope = {
          enabled = false
        }
      }
    end },
  { 'tversteeg/registers.nvim',
    name = 'registers',
    keys = {
      { '"', mode = { 'n', 'v' } },
      { '<C-R>', mode = 'i' }
    },
    cmd = 'Registers',
    config = function ()
      require('registers').setup()
    end },
  { 'NvChad/nvim-colorizer.lua',
    cmd = { 'ColorizerToggle', 'ColorizerAttachToBuffer', 'ColorizerDetachFromBuffer' },
    config = function ()
      require('colorizer').setup()
    end },
  { 'wellle/targets.vim',
    init = function ()
      vim.g.targets_seekRanges = 'cc cr cb cB lc ac Ac lr lb ar ab lB Ar aB Ab AB rr ll rb al rB Al bb aa bB Aa BB AA'
    end },
  { 'nvim-tree/nvim-tree.lua',
    cmd = { 'NvimTreeToggle' },
    init = function ()
      vim.keymap.set('n', '<Space>t', ':NvimTreeToggle<CR>')
    end,
    config = function ()
      require('nvim-tree').setup()
    end },
  { 'junegunn/goyo.vim', cmd = 'Goyo' },
  { 'mbbill/undotree', cmd = 'UndotreeToggle' },
  -- Languages
  { 'tjdevries/ocaml.nvim',
    build = ':lua require(\'ocaml\').update()',
    config = function ()
      vim.api.nvim_set_hl(0, '@rapper_argument', { link = '@parameter', default = true })
      vim.api.nvim_set_hl(0, '@rapper_return', { link = '@type', default = true })
    end },
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
      vim.cmd('colorscheme github_dark_dimmed')
    end },
}

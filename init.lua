local function apply_default_highlights()
  vim.cmd([[
      highlight Normal             ctermbg=NONE guibg=NONE
      highlight NormalNC           ctermbg=NONE guibg=NONE
      highlight CursorLine         ctermbg=8    guibg=#282a2b
      highlight TrailingWhitespace ctermbg=8    guibg=#41535B ctermfg=0    guifg=Black
      highlight VertSplit          ctermbg=NONE guibg=NONE    ctermfg=Gray guifg=Gray
    ]])
end

local augroup = 'init.lua'
vim.api.nvim_create_augroup(augroup, {})

vim.loader.enable()

-- globals {{{
vim.g.mapleader = ' '
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0

vim.g['mkdx#settings'] = {
  restore_visual = 1,
  gf_on_steroids = 1,
  enter = { shift = 1 },
  highlight = { enable = 1 },
  fold = { enable = 1 },
  links = { external = { enable = 1 } },
  toc = {
    text = 'Table of Contents',
    update_on_write = 1,
    details = { nesting_level = 0 },
  },
}
-- }}}

-- settings {{{
local undo_directory = vim.env.HOME .. '/.local/share/nvim/undo//'
local backup_directory = vim.env.HOME .. '/.local/share/nvim/backup//'

vim.opt.list = true
vim.opt.wrap = false
vim.opt.ruler = false
vim.opt.tabstop = 2
vim.opt.ttyfast = true
vim.opt.showmode = false
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.smartcase = true
vim.opt.expandtab = true
vim.opt.backupcopy = 'yes'
vim.opt.ignorecase = true
vim.opt.cursorline = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.shiftwidth = 0
vim.opt.timeoutlen = 400
vim.opt.updatetime = 100
vim.opt.softtabstop = 2
vim.opt.showtabline = 0
vim.opt.termguicolors = true
vim.opt.path:append({ '**' })
vim.opt.undodir:prepend({ undo_directory })
vim.opt.backupdir:prepend({ backup_directory })
vim.opt.clipboard:append({ 'unnamedplus' })
vim.opt.listchars:append({ nbsp = '+', tab = '‣ ', trail = '•' })
vim.opt.fillchars:append({ msgsep = ' ', vert = '│', eob = ' ' })
vim.opt.wildignore:append({ '.git', '.DS_Store', 'node_modules' })
vim.opt.completeopt:append({ 'menu', 'menuone', 'noselect' })
vim.opt.virtualedit:append({ 'onemore' })

for _, path in ipairs({ undo_directory, backup_directory }) do
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, 'p')
  end
end
-- }}}

-- plugins {{{
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup({
        theme = 'gruvbox-material',
        sections = {
          lualine_a = { 'filename' },
          lualine_b = { 'diagnostics' },
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = { 'location' },
        },
      })
    end,
  },
  {
    'folke/trouble.nvim',
    opts = {},
    cmd = 'Trouble',
    keys = {
      {
        '<leader>d',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnostics (Trouble)',
      },
    },
  },
  { 'sidofc/mkdx', ft = { 'markdown' } },
  {
    'kylechui/nvim-surround',
    event = { 'BufReadPre' },
    config = function()
      require('nvim-surround').setup()
    end,
  },
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_enable_italic = true
      vim.g.gruvbox_material_better_performance = 1
      vim.cmd.colorscheme('gruvbox-material')
    end,
  },
  {
    'sidofc/carbon.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('carbon').setup({
        sync_pwd = true,
        indicators = { collapse = '▾', expand = '▸' },
        actions = { toggle_recursive = '<s-cr>' },
      })
    end,
  },
  {
    'NeogitOrg/neogit',
    keys = { '<leader>m' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('neogit').setup({
        disable_hint = true,
        disable_signs = true,
        disable_insert_on_commit = false,
        disable_commit_confirmation = true,
        sections = {
          recent = { hidden = true, folded = true },
        },
        mappings = {
          popup = {
            P = 'PullPopup',
            p = 'PushPopup',
          },
        },
      })

      vim.keymap.set('n', '<leader>m', vim.cmd.Neogit, { silent = true })
    end,
  },
  {
    'stevearc/conform.nvim',
    config = function()
      local js_tool = 'prettier'

      require('conform').setup({
        format_on_save = { timeout_ms = 1000 },
        formatters_by_ft = {
          lua = { 'stylua' },
          ejs = { js_tool },
          css = { js_tool },
          scss = { js_tool },
          json = { js_tool },
          html = { js_tool },
          javascript = { js_tool },
          typescript = { js_tool },
          javascriptreact = { js_tool },
          typescriptreact = { js_tool },
        },
      })
    end,
  },
  {
    'aserowy/tmux.nvim',
    keys = {
      '<C-h>',
      '<C-j>',
      '<C-k>',
      '<C-l>',
      '<C-S-h>',
      '<C-S-j>',
      '<C-S-k>',
      '<C-S-l>',
    },
    config = function()
      local tmux = require('tmux')

      tmux.setup({
        copy_sync = { enable = false },
        navigation = {
          cycle_navigation = false,
          enable_default_keybindings = false,
        },
        resize = {
          resize_step_x = 6,
          resize_step_y = 3,
          enable_default_keybindings = false,
        },
      })

      vim.keymap.set('n', '<C-h>', tmux.move_left)
      vim.keymap.set('n', '<C-j>', tmux.move_bottom)
      vim.keymap.set('n', '<C-k>', tmux.move_top)
      vim.keymap.set('n', '<C-l>', tmux.move_right)

      vim.keymap.set('n', '<C-S-h>', tmux.resize_left)
      vim.keymap.set('n', '<C-S-j>', tmux.resize_bottom)
      vim.keymap.set('n', '<C-S-k>', tmux.resize_top)
      vim.keymap.set('n', '<C-S-l>', tmux.resize_right)
    end,
  },
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre' },
    config = function()
      -- npm  install --global typescript typescript-language-server
      -- npm  install --global vscode-langservers-extracted
      -- npm  install --global @biomejs/biome
      -- brew install          lua-language-server

      local lsp = require('lspconfig')

      local function on_attach(_, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }

        vim.keymap.set('n', 'gn', function()
          vim.diagnostic.jump({ count = 1, float = true })
        end, opts)

        vim.keymap.set('n', 'gp', function()
          vim.diagnostic.jump({ count = -1, float = true })
        end, opts)
      end

      lsp.ts_ls.setup({ on_attach = on_attach })
      lsp.eslint.setup({ on_attach = on_attach })
      -- lsp.biome.setup({ on_attach = on_attach })

      vim.diagnostic.config({
        signs = false,
        virtual_text = true,
        float = false,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufRead' },
    config = function()
      require('nvim-treesitter.configs').setup({
        indent = { enable = true },
        highlight = { enable = true },
        incremental_selection = { enable = true },
        textobjects = { enable = true },
        ensure_installed = {
          'c',
          'cpp',
          'css',
          'bash',
          'fish',
          'html',
          'java',
          'javascript',
          'json',
          'json5',
          'lua',
          'pug',
          'python',
          'ruby',
          'rust',
          'scss',
          'toml',
          'tsx',
          'typescript',
          'vimdoc',
          'vim',
          'yaml',
        },
      })
    end,
  },
  {
    'ibhagwan/fzf-lua',
    keys = { '<C-f>', '<C-g>' },
    config = function()
      local fzf_lua = require('fzf-lua')

      fzf_lua.setup({
        actions = {
          files = {
            ['default'] = fzf_lua.actions.file_edit_or_qf,
            ['ctrl-x'] = fzf_lua.actions.file_split,
            ['ctrl-v'] = fzf_lua.actions.file_vsplit,
          },
        },
        winopts = function()
          local height = 15

          return {
            border = { '—', '—', '—', '', '', '', '', '' },
            row = vim.o.lines - vim.o.cmdheight - 3 - height,
            column = 1,
            height = height,
            width = vim.o.columns + 1,
          }
        end,
      })

      vim.keymap.set('n', '<C-f>', function()
        fzf_lua.files({
          prompt = '> ',
          previewer = false,
          cwd_prompt = false,
          rg_opts = [[--color=never --files --hidden --follow --no-ignore -g "!.git/**" -g "!node_modules/**" -g "!.DS_Store" -g "!build"]],
          fzf_opts = { ['--info'] = 'inline' },
        })
      end)

      vim.keymap.set('n', '<C-g>', function()
        fzf_lua.live_grep_native({
          prompt = '> ',
          no_header_i = false,
          previewer = false,
          exec_empty_query = true,
          fzf_opts = { ['--info'] = 'inline', ['--nth'] = '2..' },
        })
      end)
    end,
  },
})
-- }}}

-- mappings {{{
vim.keymap.set({ 'n', 'v', 'o', 'i' }, '<Up>', '<Nop>')
vim.keymap.set({ 'n', 'v', 'o', 'i' }, '<Down>', '<Nop>')
vim.keymap.set({ 'n', 'v', 'o', 'i' }, '<Left>', '<Nop>')
vim.keymap.set({ 'n', 'v', 'o', 'i' }, '<Right>', '<Nop>')
vim.keymap.set({ 'n', 'v', 'o' }, '>>', '<Nop>')
vim.keymap.set({ 'n', 'v', 'o' }, '<<', '<Nop>')
vim.keymap.set({ 'n', 'v', 'o' }, 'K', '{')
vim.keymap.set({ 'n', 'v', 'o' }, 'J', '}')
vim.keymap.set({ 'n', 'v', 'o' }, 'H', '^')
vim.keymap.set({ 'n', 'v', 'o' }, 'L', '$')

vim.keymap.set('n', '$', '<Nop>')
vim.keymap.set('n', '^', '<Nop>')
vim.keymap.set('n', '{', '<Nop>')
vim.keymap.set('n', '}', '<Nop>')

vim.keymap.set('i', '<C-k>', '<Up>')
vim.keymap.set('i', '<C-j>', '<Down>')
vim.keymap.set('i', '<C-h>', '<Left>')
vim.keymap.set('i', '<C-l>', '<Right>')

vim.keymap.set('n', '<C-s>', ':write<Cr>', { silent = true })
vim.keymap.set('v', '<C-s>', '<C-c>:write<Cr>gv', { silent = true })
vim.keymap.set('i', '<C-s>', '<C-o>:write<Cr>', { silent = true })
vim.keymap.set('o', '<C-s>', '<Esc>:write<Cr>', { silent = true })

vim.keymap.set('i', '<>', '<><Left>')
vim.keymap.set('i', '()', '()<Left>')
vim.keymap.set('i', '{}', '{}<Left>')
vim.keymap.set('i', '[]', '[]<Left>')
vim.keymap.set('i', '""', '""<Left>')
vim.keymap.set('i', "''", "''<Left>")
vim.keymap.set('i', '``', '``<Left>')

vim.keymap.set('n', '<Tab>', '>>')
vim.keymap.set('n', '<S-Tab>', '<<')
vim.keymap.set('v', '<Tab>', '>><Esc>gv')
vim.keymap.set('v', '<S-Tab>', '<<<Esc>gv')
vim.keymap.set('i', '<S-Tab>', '<C-d>')

vim.keymap.set('v', 'i<Bar>', ':<C-u>normal! T<Bar>vt<Bar><Cr>')
vim.keymap.set('o', 'i<Bar>', ':<C-u>normal! T<Bar>vt<Bar><Cr>')
vim.keymap.set('v', 'a<Bar>', ':<C-u>normal! F<Bar>vf<Bar><Cr>')
vim.keymap.set('o', 'a<Bar>', ':<C-u>normal! F<Bar>vf<Bar><Cr>')

vim.keymap.set('n', 'Y', 'y$')
vim.keymap.set('n', 'Q', '@q')
vim.keymap.set('n', 'U', '<C-r>')
vim.keymap.set('n', '<C-S-x>', '<C-x>')
vim.keymap.set('n', '<C-x>', '<C-a>')

vim.keymap.set('n', '<C-n>', function()
  return pcall(vim.cmd.cnext) or pcall(vim.cmd.cfirst)
end)

vim.keymap.set('n', '<C-p>', function()
  return pcall(vim.cmd.cprev) or pcall(vim.cmd.clast)
end)

vim.keymap.set('n', '<C-w>', function()
  local winid = vim.api.nvim_get_current_win()
  local windows = vim.fn.getwininfo()

  if #windows > 1 then
    vim.api.nvim_win_close(winid, false)
  elseif vim.bo.filetype ~= 'carbon.explorer' then
    pcall(vim.cmd.Carbon)
  end
end, { nowait = true })
-- }}}

-- autocommands {{{
vim.api.nvim_create_autocmd(
  { 'FocusLost', 'VimLeave', 'WinLeave', 'BufLeave' },
  {
    group = augroup,
    pattern = '*',
    callback = function()
      vim.wo.cursorline = false
    end,
  }
)

vim.api.nvim_create_autocmd(
  { 'FocusGained', 'VimEnter', 'WinEnter', 'BufEnter' },
  {
    group = augroup,
    pattern = '*',
    callback = function()
      vim.wo.cursorline = true
    end,
  }
)

vim.api.nvim_create_autocmd(
  { 'BufEnter' },
  { group = augroup, pattern = 'global', callback = vim.cmd.checktime }
)

vim.api.nvim_create_autocmd('VimResized', {
  group = augroup,
  callback = function()
    vim.cmd.wincmd('=')
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup,
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 150,
      on_visual = true,
    })
  end,
})

vim.api.nvim_create_autocmd('CmdlineEnter', {
  group = augroup,
  pattern = { '/', '?' },
  callback = function()
    vim.opt_global.hlsearch = true
  end,
})

vim.api.nvim_create_autocmd('CmdlineLeave', {
  group = augroup,
  pattern = { '/', '?' },
  callback = function()
    vim.opt_global.hlsearch = false
  end,
})

local filetype_handlers = {
  [{
    'markdown',
    'python',
    'json',
    'jsonc',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'html',
    'css',
    'scss',
    'php',
  }] = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 0
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,

  qf = function()
    vim.opt_local.list = false
  end,

  NeogitStatus = function()
    vim.opt_local.list = false
  end,
}

for pattern, callback in pairs(filetype_handlers) do
  vim.api.nvim_create_autocmd('FileType', {
    group = augroup,
    pattern = pattern,
    callback = callback,
  })
end
-- }}}

-- colorscheme and highlights {{{
apply_default_highlights()
vim.api.nvim_create_autocmd('ColorScheme', {
  group = augroup,
  pattern = '*',
  callback = apply_default_highlights,
})
-- }}}

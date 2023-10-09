-- luacheck: globals vim

vim.loader.enable()

local statuslines = {
  inactive = ' %{v:lua.custom_status_line_filename()}%= %l:%c ',
  active = '%!v:lua.custom_status_line()',
}

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
vim.opt.statusline = statuslines.inactive
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
  { 'tpope/vim-commentary', event = { 'BufReadPre' } },

  { 'sidofc/mkdx', ft = { 'markdown' } },

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
        winopts_fn = function()
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

  {
    'mhartington/formatter.nvim',
    event = { 'BufReadPre' },
    config = function()
      local stylua = require('formatter.filetypes.lua').stylua
      local prettier_js = require('formatter.filetypes.javascript').prettier
      local prettier_css = require('formatter.filetypes.css').prettier
      local prettier_json = require('formatter.filetypes.json').prettier

      require('formatter').setup({
        filetype = {
          lua = { stylua },
          css = { prettier_css },
          scss = { prettier_css },
          json = { prettier_json },
          jsonc = { prettier_json },
          javascript = { prettier_js },
          javascriptreact = { prettier_js },
          typescript = { prettier_js },
          typescriptreact = { prettier_js },
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
    'kylechui/nvim-surround',
    event = { 'BufReadPre' },
    config = function()
      require('nvim-surround').setup()
    end,
  },

  {
    'RRethy/nvim-base16',
    event = { 'ColorScheme' },
    config = function() end,
  },

  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre' },
    config = function()
      --   npm  install --global vscode-langservers-extracted
      --   npm  install --global typescript typescript-language-server
      --   brew install          lua-language-server

      local lsp = require('lspconfig')

      local function on_attach(_, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }

        vim.keymap.set('n', 'gn', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', 'gp', vim.diagnostic.goto_prev, opts)
      end

      lsp.tsserver.setup({ on_attach = on_attach })
      lsp.eslint.setup({ on_attach = on_attach })
      lsp.lua_ls.setup({
        on_attach = on_attach,
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              library = { vim.env.VIM },
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })

      vim.diagnostic.config({
        signs = false,
        virtual_text = false,
        float = false,
      })
    end,
  },

  {
    'sidofc/carbon.nvim',
    config = function()
      require('carbon').setup({
        sync_pwd = true,
        indicators = { collapse = '▾', expand = '▸' },
        actions = { toggle_recursive = '<s-cr>' },
        file_icons = false,
      })
    end,
  },

  {
    'NeogitOrg/neogit',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = { '<leader>m' },
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
          status = {
            P = 'PullPopup',
            p = 'PushPopup',
          },
        },
      })

      vim.keymap.set('n', '<leader>m', vim.cmd.Neogit, { silent = true })
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
        ensure_installed = {
          'c',
          'cpp',
          'css',
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
          'yaml',
        },
      })
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

vim.keymap.set('n', '<S-s>', '<Nop>')
vim.keymap.set('n', '<C-z>', '<Nop>')

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
end)
-- }}}

-- statusline and cursorline {{{
local severity_labels = { 'Error', 'Warn', 'Info', 'Hint' }
local status_mode_groups = {
  n = 'StatusLineSection',
  i = 'StatusLineSectionI',
  c = 'StatusLineSectionC',
  r = 'StatusLineSectionR',
  v = 'StatusLineSectionV',
  ['\22'] = 'StatusLineSectionV',
}

function _G.custom_status_line_lsp()
  local counts = { 0, 0, 0, 0 }
  local segment = ''

  for _, diagnostic in ipairs(vim.diagnostic.get(0)) do
    counts[diagnostic.severity] = counts[diagnostic.severity] + 1
  end

  for severity_index, count in ipairs(counts) do
    if count > 0 then
      local type = severity_labels[severity_index]

      segment = string.format(
        '%s%%#StatusLineLsp%s# %d%s ',
        segment,
        type,
        count,
        type:sub(0, 1)
      )
    end
  end

  return segment
end

function _G.custom_status_line_filename()
  local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':~:.')

  if vim.bo.filetype == 'qf' then
    filename = 'quickfix'
  elseif string.match(filename, '^term:') then
    filename = 'terminal'
  elseif string.match(filename, '^~') then
    filename = vim.fn.fnamemodify(filename, ':t')
  elseif vim.b.carbon and vim.b.carbon.path then
    filename = string.gsub(
      vim.b.carbon.path,
      vim.fn.fnamemodify(vim.uv.cwd(), ':h') .. '/',
      ''
    )
  end

  return filename
end

function _G.custom_status_line()
  local mode = vim.api.nvim_get_mode().mode:lower()
  local group = status_mode_groups[mode] or status_mode_groups.n

  return string.format(
    '%%#%s#%s %s %s%%#StatusLine#%%=%%#%s# %%l:%%c ',
    group,
    vim.bo.modified and ' + |' or '',
    _G.custom_status_line_filename(),
    _G.custom_status_line_lsp(),
    group
  )
end
-- }}}

-- autocommands {{{
local augroup = 'init.lua'

vim.api.nvim_create_augroup(augroup, {})

vim.api.nvim_create_autocmd({ 'DiagnosticChanged' }, {
  group = augroup,
  pattern = '*',
  callback = function(data)
    if data.buf == vim.api.nvim_get_current_buf() then
      vim.wo.statusline = statuslines.active
    end
  end,
})

vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  group = augroup,
  pattern = '*',
  callback = function()
    local ok = pcall(vim.cmd.FormatWrite)

    if not ok then
      vim.api.nvim_echo(
        { { 'Failed to format buffer!', 'ErrorMsg' } },
        false,
        {}
      )
    end
  end,
})

vim.api.nvim_create_autocmd(
  { 'FocusLost', 'VimLeave', 'WinLeave', 'BufLeave' },
  {
    group = augroup,
    pattern = '*',
    callback = function()
      vim.wo.cursorline = false
      vim.wo.statusline = statuslines.inactive
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
      vim.wo.statusline = statuslines.active
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
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,

  qf = function()
    vim.opt_local.list = false
    vim.opt_local.statusline = statuslines.active
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
vim.cmd.colorscheme('base16-seti')
vim.cmd([[
  highlight Normal             ctermbg=NONE guibg=NONE
  highlight NormalNC           ctermbg=NONE guibg=NONE
  highlight CursorLine         ctermbg=8    guibg=#282a2b
  highlight TrailingWhitespace ctermbg=8    guibg=#41535B ctermfg=0    guifg=Black
  highlight VertSplit          ctermbg=NONE guibg=NONE    ctermfg=Gray guifg=Gray
  highlight StatusLine         ctermbg=8    guibg=#313131 ctermfg=15   guifg=#cccccc
  highlight StatusLineNC       ctermbg=0    guibg=#313131 ctermfg=8    guifg=#999999
  highlight StatusLineSection  ctermbg=8    guibg=#55b5db ctermfg=0    guifg=#333333
  highlight StatusLineSectionV ctermbg=11   guibg=#a074c4 ctermfg=0    guifg=#000000
  highlight StatusLineSectionI ctermbg=10   guibg=#9fca56 ctermfg=0    guifg=#000000
  highlight StatusLineSectionC ctermbg=12   guibg=#db7b55 ctermfg=0    guifg=#000000
  highlight StatusLineSectionR ctermbg=12   guibg=#ed3f45 ctermfg=0    guifg=#000000
  highlight StatusLineLspError ctermbg=8    guifg=#313131              guibg=#ff0000
  highlight StatusLineLspWarn  ctermbg=8    guifg=#313131              guibg=#ff8800
  highlight StatusLineLspInfo  ctermbg=8    guifg=#313131              guibg=#2266cc
  highlight StatusLineLspHint  ctermbg=8    guifg=#313131              guibg=#d6d6d6
]])
-- }}}

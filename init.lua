-- luacheck: globals vim

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
vim.opt.listchars:append({ tab = '‣ ', trail = '•' })
vim.opt.fillchars:append({ msgsep = ' ', vert = '│' })
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
local packer_bootstrap
local packer_path = vim.fn.stdpath('data')
  .. '/site/pack/packer/start/packer.nvim'

if vim.fn.isdirectory(packer_path) ~= 1 then
  packer_bootstrap = vim.fn.system({
    'git',
    'clone',
    '--depth=1',
    'https://github.com/wbthomason/packer.nvim',
    packer_path,
  })
end

require('packer').startup({
  function(use)
    use({ 'wbthomason/packer.nvim' })

    use({ 'tpope/vim-commentary' })

    use({ 'sidofc/mkdx', ft = { 'markdown' } })

    use({
      'ibhagwan/fzf-lua',
      config = function()
        local fzf_lua = require('fzf-lua')

        vim.keymap.set('n', '<C-f>', function()
          fzf_lua.files({ previewer = false })
        end)

        vim.keymap.set('n', '<C-g>', function()
          fzf_lua.live_grep({ previewer = false })
        end)

        fzf_lua.setup({
          winopts_fn = function()
            local height = 10

            return {
              border = { '—', '—', '—', '', '', '', '', '' },
              row = vim.o.lines - vim.o.cmdheight - 3 - height,
              column = 1,
              height = height,
              width = vim.o.columns + 1,
            }
          end,
        })
      end,
    })

    use({
      'mhartington/formatter.nvim',
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
    })

    use({
      'aserowy/tmux.nvim',
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
    })

    use({
      'kylechui/nvim-surround',
      config = function()
        require('nvim-surround').setup()
      end,
    })

    use({
      'RRethy/nvim-base16',
      config = function()
        vim.cmd.colorscheme('base16-seti')
      end,
    })

    use({
      'neovim/nvim-lspconfig',
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
                library = vim.api.nvim_get_runtime_file('', true),
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
    })

    use({
      'sidofc/carbon.nvim',
      config = function()
        require('carbon').setup({
          sync_pwd = true,
          indicators = { collapse = '▾', expand = '▸' },
          actions = { toggle_recursive = '<s-cr>' },
          file_icons = false,
        })
      end,
    })

    use({
      'NeogitOrg/neogit',
      requires = { 'nvim-lua/plenary.nvim' },
      cmd = { 'Neogit' },
      config = function()
        require('neogit').setup({
          disable_hint = true,
          disable_signs = true,
          disable_insert_on_commit = false,
          disable_commit_confirmation = true,
          sections = {
            recent = { hidden = true },
          },
          mappings = {
            status = {
              P = 'PullPopup',
              p = 'PushPopup',
            },
          },
        })
      end,
    })

    use({
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
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
    })

    if packer_bootstrap then
      require('packer').sync()
    end
  end,
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

vim.keymap.set('n', 'q:', ':q<Cr>', { silent = true })
vim.keymap.set('n', 'Q:', ':q<Cr>', { silent = true })

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
  local bufnr = vim.api.nvim_get_current_buf()
  local windows = vim.fn.getwininfo()
  local modified = vim.api.nvim_buf_get_option(bufnr, 'modified')

  if #windows > 1 then
    local buf_win_count = 0

    vim.api.nvim_win_close(winid, false)

    for _, wininfo in ipairs(windows) do
      if wininfo.bufnr == bufnr then
        buf_win_count = buf_win_count + 1
      end
    end

    if buf_win_count == 1 and not modified then
      vim.api.nvim_buf_delete(bufnr, {})
    end
  elseif vim.bo.filetype ~= 'carbon.explorer' then
    pcall(vim.cmd.Carbon)

    if not modified then
      vim.api.nvim_buf_delete(bufnr, {})
    end
  end
end)

vim.keymap.set('n', '<leader>m', function()
  pcall(vim.cmd.Neogit)
end, { silent = true })
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
  local filename = vim.fn.fnamemodify(vim.fn.expand('%'), ':~:.')

  if string.match(filename, '^~') then
    filename = vim.fn.fnamemodify(filename, ':t')
  elseif vim.b.carbon and vim.b.carbon.path then
    filename = string.gsub(
      vim.b.carbon.path,
      vim.fn.fnamemodify(vim.loop.cwd(), ':h') .. '/',
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

-- define auto commands {{{
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

vim.api.nvim_create_autocmd('ColorScheme', {
  group = augroup,
  callback = function()
    vim.cmd([[
      highlight Normal             ctermbg=NONE guibg=NONE
      highlight NormalNC           ctermbg=NONE guibg=NONE
      highlight CursorLine         ctermbg=8    guibg=#282a2b
      highlight EndOfBuffer        ctermbg=NONE guibg=NONE    ctermfg=0    guifg=Black
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
  end,
})

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

-- luacheck: globals vim

-- globals {{{
vim.g.mapleader = ' '
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0

vim.g.fzf_preview_window = {}
vim.g.fzf_layout = { down = '20%' }
vim.g.fzf_colors = {
  fg = { 'fg', 'Normal' },
  hl = { 'fg', 'String' },
  info = { 'fg', 'PreProc' },
  prompt = { 'fg', 'Conditional' },
  pointer = { 'fg', 'Exception' },
  marker = { 'fg', 'Keyword' },
  spinner = { 'fg', 'Label' },
  header = { 'fg', 'Comment' },
  ['fg+'] = { 'fg', 'CursorLine' },
  ['bg+'] = { 'bg', 'CursorLine' },
  ['hl+'] = { 'fg', 'Statement' },
}

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
vim.opt.statusline = ' %{v:lua.custom_status_line_filename()}%= %l:%c '
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

    use({ 'tpope/vim-repeat' })
    use({ 'tpope/vim-commentary' })

    use({ 'sidofc/mkdx', ft = { 'markdown' } })
    use({ 'junegunn/fzf', requires = { 'junegunn/fzf.vim' } })

    use({
      'mhartington/formatter.nvim',
      config = function()
        require('formatter').setup({
          filetype = {
            lua = { require('formatter.filetypes.lua').stylua },
            javascript = {
              require('formatter.filetypes.javascript').prettier,
            },
            javascriptreact = {
              require('formatter.filetypes.javascript').prettier,
            },
            typescript = {
              require('formatter.filetypes.javascript').prettier,
            },
            typescriptreact = {
              require('formatter.filetypes.javascript').prettier,
            },
          },
        })
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
      'numToStr/Navigator.nvim',
      cmd = {
        'NavigatorUp',
        'NavigatorDown',
        'NavigatorLeft',
        'NavigatorRight',
      },
      config = function()
        require('Navigator').setup()
      end,
    })

    use({
      'neovim/nvim-lspconfig',
      config = function()
        local lsp = require('lspconfig')

        local function on_attach(_, bufnr)
          local opts = { noremap = true, silent = true, buffer = bufnr }

          for mapping, action in pairs({ gn = 'goto_next', gp = 'goto_prev' }) do
            vim.keymap.set('n', mapping, function()
              vim.diagnostic[action]({ float = false })
            end, opts)
          end
        end

        lsp.eslint.setup({ on_attach = on_attach })
        lsp.sumneko_lua.setup({
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
      '~/Dev/sidofc/lua/carbon.nvim',
      config = function()
        require('carbon').setup({
          sync_pwd = true,
          indicators = { collapse = '▾', expand = '▸' },
          actions = { toggle_recursive = '<s-cr>' },
          highlights = {
            CarbonDir = { fg = '#00aaff', bold = true },
            CarbonFile = { fg = '#f8f8f8', bold = true },
            CarbonExe = { fg = '#22cc22', bold = true },
            CarbonSymlink = { fg = '#d77ee0', bold = true },
            CarbonBrokenSymlink = { fg = '#ea871e', bold = true },
            CarbonIndicator = { fg = 'Gray', bold = true },
            CarbonDanger = { fg = '#ff3333', bold = true },
            CarbonPending = { fg = '#ffee00', bold = true },
            CarbonFlash = { link = 'Visual' },
          },
        })
      end,
    })

    use({
      'timuntersberger/neogit',
      requires = { 'nvim-lua/plenary.nvim' },
      cmd = { 'Neogit' },
      config = function()
        require('neogit').setup({
          disable_hint = true,
          disable_signs = true,
          disable_insert_on_commit = false,
          disable_commit_confirmation = true,
          sections = {
            recent = false,
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

vim.keymap.set('n', 'gd', function()
  local diagnostics = vim.diagnostic.get()

  if #diagnostics ~= 0 then
    vim.diagnostic.setqflist()
  else
    vim.api.nvim_echo({ { 'No diagnostics to show', 'MoreMsg' } }, false, {})
  end
end)

vim.keymap.set('n', '<C-n>', function()
  return pcall(vim.cmd.cnext) or pcall(vim.cmd.cfirst)
end)

vim.keymap.set('n', '<C-p>', function()
  return pcall(vim.cmd.cprev) or pcall(vim.cmd.clast)
end)

vim.keymap.set('n', '<C-w>', function()
  local winid = vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_get_current_buf()

  if #vim.fn.getbufinfo({ buflisted = 1, windows = { winid } }) > 2 then
    vim.api.nvim_buf_delete(bufnr, {})
  elseif #vim.fn.getwininfo() > 1 then
    vim.api.nvim_win_close(winid, false)
  elseif vim.bo.filetype ~= 'carbon' then
    vim.cmd.Carbon()
    vim.api.nvim_buf_delete(bufnr, {})
  end
end)

vim.keymap.set('n', '<leader>m', ':Neogit<Cr>', { silent = true })

vim.keymap.set('n', '<C-h>', ':NavigatorLeft<Cr>', { silent = true })
vim.keymap.set('n', '<C-j>', ':NavigatorDown<Cr>', { silent = true })
vim.keymap.set('n', '<C-k>', ':NavigatorUp<Cr>', { silent = true })
vim.keymap.set('n', '<C-l>', ':NavigatorRight<Cr>', { silent = true })

vim.keymap.set('n', '<C-f>', ':Files<Cr>', { silent = true })
vim.keymap.set('n', '<C-g>', function()
  local options = { '--delimiter=:', '--nth=2..' }
  local command = 'rg --line-number --hidden --color=always --smart-case .'

  vim.fn['fzf#vim#grep'](command, 0, { options = options })
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
  [''] = 'StatusLineSectionV',
}

function _G.custom_status_line_lsp()
  local counts = { 0, 0, 0, 0 }
  local segment = ''

  for _, diagnostic in ipairs(vim.diagnostic.get()) do
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
  local mode = vim.fn.mode():lower()
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
  { 'FocusLost', 'VimLeave', 'WinLeave', 'BufWinLeave' },
  {
    group = augroup,
    pattern = '*',
    callback = function()
      vim.opt_local.cursorline = false
      vim.opt_local.statusline = vim.opt_global.statusline:get()
    end,
  }
)

vim.api.nvim_create_autocmd(
  { 'FocusGained', 'VimEnter', 'WinEnter', 'BufWinEnter' },
  {
    group = augroup,
    pattern = '*',
    callback = function()
      vim.opt_local.cursorline = true
      vim.opt_local.statusline = '%!v:lua.custom_status_line()'
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

  fzf = function()
    local original = vim.opt_global.laststatus:get()

    vim.opt.laststatus = 0

    vim.api.nvim_create_autocmd('BufLeave', {
      buffer = vim.api.nvim_get_current_buf(),
      callback = function()
        vim.opt.laststatus = original
      end,
    })
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

-- luacheck: globals vim

-- globals {{{
vim.g.mapleader = ' '

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

vim.g.ale_echo_msg_format = '[%linter%] %severity%: %s'
vim.g.ale_lint_delay = 300
vim.g.ale_fix_on_save = 1
vim.g.ale_linters_explicit = 1
vim.g.ale_fixers = {
  javascript = { 'prettier' },
  javascriptreact = { 'prettier' },
  typescript = { 'prettier' },
  typescriptreact = { 'prettier' },
  json = { 'prettier' },
  scss = { 'prettier' },
  html = { 'prettier' },
  css = { 'prettier' },
  rust = { 'rustfmt' },
  lua = { 'stylua' },
}
vim.g.ale_linters = {
  javascript = { 'eslint' },
  javascriptreact = { 'eslint' },
  typescript = { 'eslint' },
  typescriptreact = { 'eslint' },
  rust = { 'cargo' },
  ruby = { 'rubocop' },
  lua = { 'luacheck' },
  scss = { 'stylelint' },
  css = { 'stylelint' },
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
vim.opt.statusline = ' %{fnamemodify(expand("%"), ":~:.")}%= %l:%c '
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
    use({ 'tpope/vim-surround' })
    use({ 'tpope/vim-commentary' })

    use({ 'sidofc/mkdx', ft = { 'markdown' } })
    use({ 'junegunn/fzf', requires = { 'junegunn/fzf.vim' } })

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
      'sidofc/carbon.nvim',
      config = function()
        require('carbon').setup({
          sync_pwd = true,
          indicators = { collapse = '▾', expand = '▸' },
        })
      end,
    })

    use({
      'RRethy/nvim-base16',
      config = function()
        vim.cmd([[
          colorscheme base16-seti
          highlight CursorLine ctermbg=8 guibg=#282a2b
          highlight Normal guibg=NONE ctermbg=NONE
          highlight EndOfBuffer guibg=NONE ctermbg=NONE guifg=Black ctermfg=0
          highlight TrailingWhitespace ctermfg=0 guifg=Black ctermbg=8 guibg=#41535B
          highlight VertSplit guibg=NONE ctermbg=NONE guifg=Gray ctermfg=Gray
        ]])
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
          disable_commit_confirmation = true,
          disable_insert_on_commit = false,
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
      'w0rp/ale',
      ft = {
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
        'json',
        'scss',
        'html',
        'css',
        'rust',
        'lua',
      },
    })

    use({
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = function()
        require('nvim-treesitter.configs').setup({
          indent = { enable = true },
          incremental_selection = { enable = true },
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
vim.keymap.set({ 'n', 'i' }, '<Up>', '<Nop>')
vim.keymap.set({ 'n', 'i' }, '<Down>', '<Nop>')
vim.keymap.set({ 'n', 'i' }, '<Left>', '<Nop>')
vim.keymap.set({ 'n', 'i' }, '<Right>', '<Nop>')
vim.keymap.set({ 'n', 'v' }, '>>', '<Nop>')
vim.keymap.set({ 'n', 'v' }, '<<', '<Nop>')
vim.keymap.set({ 'n', 'v' }, 'K', '{')
vim.keymap.set({ 'n', 'v' }, 'J', '}')
vim.keymap.set({ 'n', 'v' }, 'H', '^')
vim.keymap.set({ 'n', 'v' }, 'L', '$')

vim.keymap.set('n', '<S-s>', '<Nop>')
vim.keymap.set('n', '<C-z>', '<Nop>')

vim.keymap.set('n', '$', '<Nop>')
vim.keymap.set('n', '^', '<Nop>')
vim.keymap.set('n', '{', '<Nop>')
vim.keymap.set('n', '}', '<Nop>')

vim.keymap.set('n', 'q:', ':q<Cr>')
vim.keymap.set('n', 'Q:', ':q<Cr>')

vim.keymap.set('i', '<C-k>', '<Up>')
vim.keymap.set('i', '<C-j>', '<Down>')
vim.keymap.set('i', '<C-h>', '<Left>')
vim.keymap.set('i', '<C-l>', '<Right>')

vim.keymap.set('n', '<C-s>', ':write<Cr>')
vim.keymap.set('v', '<C-s>', '<C-c>:write<Cr>gv')
vim.keymap.set('i', '<C-s>', '<C-o>:write<Cr>')
vim.keymap.set('o', '<C-s>', '<Esc>:write<Cr>')

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

vim.keymap.set('n', '<C-n>', function()
  return pcall(vim.cmd, { cmd = 'cnext' }) or pcall(vim.cmd, { cmd = 'cfirst' })
end)

vim.keymap.set('n', '<C-b>', function()
  return pcall(vim.cmd, { cmd = 'cprev' }) or pcall(vim.cmd, { cmd = 'clast' })
end)

vim.keymap.set('n', '<C-w>', function()
  local winid = vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_get_current_buf()

  if #vim.fn.getbufinfo({ buflisted = 1, windows = { winid } }) > 2 then
    vim.api.nvim_buf_delete(bufnr, {})
  elseif #vim.fn.getwininfo() > 1 then
    vim.api.nvim_win_close(winid, false)
  elseif vim.bo.filetype ~= 'carbon' then
    vim.cmd({ cmd = 'Carbon' })
    vim.api.nvim_buf_delete(bufnr, {})
  end
end)

vim.keymap.set('n', '<leader>m', ':Neogit<Cr>')

vim.keymap.set('n', '<C-h>', ':NavigatorLeft<Cr>')
vim.keymap.set('n', '<C-j>', ':NavigatorDown<Cr>')
vim.keymap.set('n', '<C-k>', ':NavigatorUp<Cr>')
vim.keymap.set('n', '<C-l>', ':NavigatorRight<Cr>')

vim.keymap.set('n', '<C-p>', ':Files<Cr>')
vim.keymap.set('n', '<C-g>', function()
  local options = { '--delimiter=:', '--nth=4..' }
  local source = 'rg --line-number --hidden --smart-case --color=always .'

  vim.fn['fzf#vim#grep'](source, 1, { options = options })
end)
-- }}}

-- statusline and cursorline {{{
local status_mode_groups = {
  n = 'StatusLineSection',
  i = 'StatusLineSectionI',
  c = 'StatusLineSectionC',
  r = 'StatusLineSectionR',
  v = 'StatusLineSectionV',
  [''] = 'StatusLineSectionV',
}

function _G.status_line()
  local mode = vim.fn.mode():lower()
  local group = status_mode_groups[mode] or status_mode_groups.n
  local filename = vim.fn.fnamemodify(vim.fn.expand('%'), ':~:.')

  if string.match(filename, '^~') then
    filename = vim.fn.fnamemodify(filename, ':t')
  end

  return string.format(
    '%%#%s#%s %s %%#StatusLine#%%=%%#%s# %%l:%%c ',
    group,
    vim.bo.modified and ' + |' or '',
    filename,
    group
  )
end
-- }}}

-- define auto commands {{{
local augroup = 'init.lua'

vim.api.nvim_create_augroup(augroup, {})

vim.api.nvim_create_autocmd(
  { 'FocusLost', 'VimLeave', 'WinLeave', 'BufWinLeave' },
  {
    group = augroup,
    pattern = '*',
    callback = function()
      vim.opt_local.cursorline = vim.opt_global.cursorline:get()
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
      vim.opt_local.statusline = '%!v:lua.status_line()'

      vim.cmd({ cmd = 'checktime' })
    end,
  }
)

vim.api.nvim_create_autocmd('ColorScheme', {
  group = augroup,
  pattern = '*',
  callback = function()
    vim.cmd([[
      highlight StatusLine         ctermbg=8  guibg=#313131 ctermfg=15 guifg=#cccccc
      highlight StatusLineNC       ctermbg=0  guibg=#313131 ctermfg=8  guifg=#999999
      highlight StatusLineSection  ctermbg=8  guibg=#55b5db ctermfg=0  guifg=#333333
      highlight StatusLineSectionV ctermbg=11 guibg=#a074c4 ctermfg=0  guifg=#000000
      highlight StatusLineSectionI ctermbg=10 guibg=#9fca56 ctermfg=0  guifg=#000000
      highlight StatusLineSectionC ctermbg=12 guibg=#db7b55 ctermfg=0  guifg=#000000
      highlight StatusLineSectionR ctermbg=12 guibg=#ed3f45 ctermfg=0  guifg=#000000
    ]])
  end,
})

vim.api.nvim_create_autocmd('VimResized', {
  group = augroup,
  pattern = '*',
  callback = function()
    vim.cmd({ cmd = 'wincmd', args = { '=' } })
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup,
  pattern = '*',
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

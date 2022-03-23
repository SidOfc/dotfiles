-- luacheck: globals vim

-- utility functions {{{
local function plugin_path(plugin)
  return vim.fn.stdpath('data') .. '/site/pack/packer/start/' .. plugin
end

local function plugin_installed(plugin)
  return vim.fn.isdirectory(plugin_path(plugin)) == 1
end

local function map(mode, lhs, rhs, options)
  return vim.api.nvim_set_keymap(mode, lhs, rhs, options or {})
end

local function noremap(mode, lhs, rhs, options)
  local opts = options or {}
  opts.noremap = true

  return map(mode, lhs, rhs, opts)
end
-- }}}

-- plugins {{{
local packer_bootstrap

if not plugin_installed('packer.nvim') then
  packer_bootstrap = vim.fn.system({
    'git',
    'clone',
    '--depth=1',
    'https://github.com/wbthomason/packer.nvim',
    plugin_path('packer.nvim'),
  })
end

require('packer').startup({
  function(use)
    use({ 'lewis6991/impatient.nvim' })

    use({ 'wbthomason/packer.nvim' })
    use({ 'nvim-lua/plenary.nvim' })

    use({ 'tpope/vim-repeat' })
    use({ 'tpope/vim-surround' })
    use({ 'tpope/vim-commentary' })

    use({ 'junegunn/fzf' })
    use({ 'junegunn/fzf.vim' })

    use({ 'SidOfc/mkdx' })
    use({ 'SidOfc/carbon.nvim' })

    use({ 'w0rp/ale' })
    use({ 'TimUntersberger/neogit' })
    use({ 'chriskempson/base16-vim' })
    use({ 'christoomey/vim-tmux-navigator' })
    use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' })

    if packer_bootstrap then
      require('packer').sync()
    end
  end,
  config = {
    display = {
      open_cmd = '50vnew \\[packer\\]',
    },
  },
})
-- }}}

-- set mapleader {{{
vim.g.mapleader = ' '
-- }}}

-- set options {{{
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
vim.opt.ignorecase = true
vim.opt.cursorline = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.shiftwidth = 0
vim.opt.timeoutlen = 400
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

for _, path in ipairs({ undo_directory, backup_directory }) do
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, 'p')
  end
end
-- }}}

-- colorscheme and misc highlights {{{
if plugin_installed('base16-vim') then
  vim.cmd('colorscheme base16-seti')
end

vim.cmd([[
  highlight CursorLine ctermbg=8 guibg=#282a2b
  highlight Normal guibg=NONE ctermbg=NONE
  highlight EndOfBuffer guibg=NONE ctermbg=NONE guifg=Black ctermfg=0
  highlight TrailingWhitespace ctermfg=0 guifg=Black ctermbg=8 guibg=#41535B
  highlight VertSplit guibg=NONE ctermbg=NONE guifg=Gray ctermfg=Gray
]])
-- }}}

-- no-op bad habit mappings {{{
map('i', '<Up>', '<Nop>')
map('i', '<Down>', '<Nop>')
map('i', '<Left>', '<Nop>')
map('i', '<Right>', '<Nop>')
map('n', '<Up>', '<Nop>')
map('n', '<Down>', '<Nop>')
map('n', '<Left>', '<Nop>')
map('n', '<Right>', '<Nop>')
map('n', '<S-s>', '<Nop>')
map('n', '>>', '<Nop>')
map('n', '<<', '<Nop>')
map('v', '>>', '<Nop>')
map('v', '<<', '<Nop>')
map('', '$', '<Nop>')
map('', '^', '<Nop>')
map('', '{', '<Nop>')
map('', '}', '<Nop>')
map('', '<C-z>', '<Nop>')
-- }}}

-- sometimes instead of pressing :q, I press q:, Q:, or :Q {{{
map('', 'q:', ':q<Cr>')
map('', 'Q:', ':q<Cr>')
-- }}}

-- more intuitive navigation mappings in normal / visual / operator pending modes {{{
noremap('', 'K', '{')
noremap('', 'J', '}')
noremap('', 'H', '^')
noremap('', 'L', '$')
-- }}}

-- easier one-off navigation in insert mode {{{
noremap('i', '<C-k>', '<Up>')
noremap('i', '<C-j>', '<Down>')
noremap('i', '<C-h>', '<Left>')
noremap('i', '<C-l>', '<Right>')
-- }}}

-- save using <C-s> in every mode {{{
noremap('n', '<C-s>', ':write<Cr>')
noremap('v', '<C-s>', '<C-c>:write<Cr>gv')
noremap('i', '<C-s>', '<C-o>:write<Cr>')
noremap('o', '<C-s>', '<Esc>:write<Cr>')
-- }}}

-- make Y consistent with C and D {{{
noremap('n', 'Y', 'y$')
-- }}}

-- use qq to record, q to stop, Q to play a macro {{{
noremap('n', 'Q', '@q')
-- }}}

-- when pairing brackets, parens, or quotes, place the cursor in the middle {{{
noremap('i', '<>', '<><Left>')
noremap('i', '()', '()<Left>')
noremap('i', '{}', '{}<Left>')
noremap('i', '[]', '[]<Left>')
noremap('i', '""', '""<Left>')
noremap('i', "''", "''<Left>")
noremap('i', '``', '``<Left>')
-- }}}

-- use <Tab> and <S-Tab> to indent and unindent code {{{
noremap('n', '<Tab>', '>>')
noremap('n', '<S-Tab>', '<<')
noremap('v', '<Tab>', '>><Esc>gv')
noremap('v', '<S-Tab>', '<<<Esc>gv')
noremap('i', '<S-Tab>', '<C-d>')
-- }}}

-- use <u> to undo, <U> to redo {{{
noremap('n', 'U', '<C-r>')
-- }}}

-- enable acting on content between bar (|) characters {{{
noremap('v', 'i<Bar>', ':<C-u>normal! T<Bar>vt<Bar><Cr>')
noremap('o', 'i<Bar>', ':<C-u>normal! T<Bar>vt<Bar><Cr>')
noremap('v', 'a<Bar>', ':<C-u>normal! F<Bar>vf<Bar><Cr>')
noremap('o', 'a<Bar>', ':<C-u>normal! F<Bar>vf<Bar><Cr>')
-- }}}

-- use <C-n> and <C-b> to scroll through quickfix entries {{{
function quickfix_next() -- luacheck: ignore
  vim.cmd('try | cnext | catch | cfirst | catch | endtry')
end

function quickfix_prev() -- luacheck: ignore
  vim.cmd('try | cprev | catch | clast | catch | endtry')
end

noremap('n', '<C-n>', ':call v:lua.quickfix_next()<Cr>', { silent = true })
noremap('n', '<C-b>', ':call v:lua.quickfix_prev()<Cr>', { silent = true })
-- }}}

-- close pane using <C-w> {{{
function close_buffer() -- luacheck: ignore
  local winid = vim.fn.bufwinid('%')

  if #vim.fn.getbufinfo({ buflisted = 1, windows = { winid } }) > 1 then
    vim.cmd('bdelete')
  elseif #vim.fn.getwininfo() > 1 then
    vim.cmd('close')
  elseif vim.bo.filetype ~= 'carbon' then
    vim.cmd('Carbon')
    vim.cmd('silent! bdelete#')
  end
end

noremap('n', '<C-w>', ':call v:lua.close_buffer()<Cr>', { silent = true })
-- }}}

-- define auto commands {{{
function indent_size(spaces) -- luacheck: ignore
  vim.opt_local.expandtab = true
  vim.opt_local.tabstop = spaces
  vim.opt_local.softtabstop = spaces
end

vim.cmd([[
  augroup InitAutoCommands
    au!

    au FileType markdown,python,json,javascript,php call v:lua.indent_size(4)
    au FileType javascriptreact,jsx,typescript,html,css call v:lua.indent_size(4)

    au FileType NeogitStatus setlocal nolist

    au CmdlineEnter /,\? set hlsearch
    au CmdlineLeave /,\? set nohlsearch

    au VimResized * wincmd =

    au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=true}

    au FileType fzf
          \ set laststatus& laststatus=0 |
          \ au BufLeave <buffer> set laststatus&

    au FocusLost,VimLeave,WinLeave,BufWinLeave * setlocal cursorline&
    au FocusGained,VimEnter,WinEnter,BufWinEnter *
          \ setlocal cursorline& |
          \ setlocal cursorline |
          \ checktime
  augroup END
]])
-- }}}

-- statusline {{{
local status_mode_groups = {
  n = 'StatusLineSection',
  i = 'StatusLineSectionI',
  c = 'StatusLineSectionC',
  r = 'StatusLineSectionR',
  v = 'StatusLineSectionV',
  [''] = 'StatusLineSectionV',
}

function status_line() -- luacheck: ignore
  local group = status_mode_groups[vim.fn.mode():lower()]
    or status_mode_groups.n
  local highlight = '%#' .. group .. '#'
  local filename = vim.fn.fnamemodify(vim.fn.expand('%'), ':~:.')
  if string.match(filename, '^~') then
    filename = vim.fn.fnamemodify(filename, ':t')
  end

  return (
      highlight
      .. (vim.bo.modified and ' + |' or '')
      .. ' '
      .. filename
      .. ' %#StatusLine#%='
      .. highlight
      .. ' %l:%c '
    )
end

function status_line_colors() -- luacheck: ignore
  vim.cmd([[
    highlight StatusLine         ctermbg=8  guibg=#313131 ctermfg=15 guifg=#cccccc
    highlight StatusLineNC       ctermbg=0  guibg=#313131 ctermfg=8  guifg=#999999
    highlight StatusLineSection  ctermbg=8  guibg=#55b5db ctermfg=0  guifg=#333333
    highlight StatusLineSectionV ctermbg=11 guibg=#a074c4 ctermfg=0  guifg=#000000
    highlight StatusLineSectionI ctermbg=10 guibg=#9fca56 ctermfg=0  guifg=#000000
    highlight StatusLineSectionC ctermbg=12 guibg=#db7b55 ctermfg=0  guifg=#000000
    highlight StatusLineSectionR ctermbg=12 guibg=#ed3f45 ctermfg=0  guifg=#000000
  ]])
end

status_line_colors() -- luacheck: ignore

if vim.fn.has('vim_starting') then
  vim.opt.statusline = ' %{fnamemodify(expand("%"), ":~:.")}%= %l:%c '
end

vim.cmd([[
  augroup StatusLineAutocmds
    au!

    au FocusLost,VimLeave,WinLeave,BufWinLeave * setlocal statusline&
    au FocusGained,VimEnter,WinEnter,BufWinEnter *
          \ setlocal statusline& |
          \ setlocal statusline=%!v:lua.status_line() |
          \ checktime

    au Colorscheme * call v:lua.status_line_colors()
  augroup END
]])
-- }}}

-- carbon.nvim {{{
if plugin_installed('carbon.nvim') then
  require('carbon').setup({ indicators = { collapse = '▾', expand = '▸' } })
end
-- }}}

-- fzf {{{
if plugin_installed('fzf') and plugin_installed('fzf.vim') then
  vim.g.fzf_preview_window = {}
  vim.g.fzf_layout = { down = '20%' }
  vim.g.fzf_colors = {
    fg = { 'fg', 'Normal' },
    bg = { 'bg', 'Clear' },
    hl = { 'fg', 'String' },
    info = { 'fg', 'PreProc' },
    prompt = { 'fg', 'Conditional' },
    pointer = { 'fg', 'Exception' },
    marker = { 'fg', 'Keyword' },
    spinner = { 'fg', 'Label' },
    header = { 'fg', 'Comment' },
    ['fg+'] = { 'fg', 'CursorLine', 'CursorColumn', 'Normal' },
    ['bg+'] = { 'bg', 'CursorLine', 'CursorColumn' },
    ['hl+'] = { 'fg', 'Statement' },
  }

  vim.cmd([[
    command! -bang -nargs=* FzfMkdxJumpToHeader
      \ call cursor(str2nr(get(matchlist(<q-args>, ' *\([0-9]\+\)'), 1, '')), 1)
  ]])

  function fzf_grep() -- luacheck: ignore
    vim.fn['fzf#vim#grep'](
      'rg --column --line-number --hidden --smart-case --color=always .',
      1,
      { options = { '--delimiter=:', '--nth=4..', '--no-hscroll' } }
    )
  end

  function fzf_mkdx_headers() -- luacheck: ignore
    local lines = vim.api.nvim_buf_get_lines(0, 1, vim.fn.line('$'), 0)
    local headers = {}

    for lnum, line in ipairs(lines) do
      if line:find('^#') then
        table.insert(headers, string.format('%4d: %s', lnum + 1, line))
      end
    end

    vim.fn['fzf#run'](vim.fn['fzf#wrap']({
      source = headers,
      sink = 'FzfMkdxJumpToHeader',
    }))
  end

  noremap(
    'n',
    '<leader>I',
    ':call v:lua.fzf_mkdx_headers()<Cr>',
    { silent = true }
  )
  noremap('n', '<C-p>', ':Files<Cr>', { silent = true })
  noremap('n', '<C-g>', ':call v:lua.fzf_grep()<Cr>', { silent = true })
end
-- }}}

-- neogit {{{
if plugin_installed('neogit') then
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

  noremap('n', '<leader>m', ':Neogit<Cr>')
end
-- }}}

-- nvim-treesitter {{{
if plugin_installed('nvim-treesitter') then
  require('nvim-treesitter.configs').setup({
    highlight = { enable = true },
    incremental_selection = { enable = true },
    ensure_installed = {
      'php',
      'css',
      'fish',
      'html',
      'java',
      'javascript',
      'json',
      'lua',
      'pug',
      'python',
      'ruby',
      'rust',
      'scss',
      'toml',
      'vim',
      'yaml',
    },
  })
end
-- }}}

-- mkdx {{{
if plugin_installed('mkdx') then
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
end
-- }}}

-- ale {{{
if plugin_installed('ale') then
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
  }
end
-- }}}

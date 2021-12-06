-- utility functions {{{
function plugin_path(plugin)
  return vim.fn.stdpath('data') .. '/site/pack/paqs/start/' .. plugin
end

function map(mode, lhs, rhs, options)
  return vim.api.nvim_set_keymap(mode, lhs, rhs, options or {})
end

function noremap(mode, lhs, rhs, options)
  local opts = options or {}
  opts.noremap = true

  return map(mode, lhs, rhs, opts)
end
-- }}}

-- plugins {{{
local bootstrap_plugins = vim.fn.isdirectory(plugin_path('paq-nvim')) == 0

if bootstrap_plugins then
  vim.fn.system({
    'git',
    'clone',
    '--depth=1',
    'https://github.com/savq/paq-nvim.git',
    plugin_path('paq-nvim'),
  })
end

function nvim_treesitter_post_install()
  vim.cmd('TSUpdate')
end

require('paq')({
  'savq/paq-nvim',
  'nvim-lua/plenary.nvim',

  'tpope/vim-repeat',
  'tpope/vim-fugitive',
  'tpope/vim-surround',
  'tpope/vim-commentary',

  'junegunn/fzf',
  'junegunn/fzf.vim',

  'SidOfc/mkdx',
  'SidOfc/treevial',

  'w0rp/ale',
  'TimUntersberger/neogit',
  'chriskempson/base16-vim',
  'christoomey/vim-tmux-navigator',
  { 'nvim-treesitter/nvim-treesitter', run = nvim_treesitter_post_install },
})

if bootstrap_plugins then
  vim.cmd('PaqInstall')
end
-- }}}

-- general {{{
vim.g.mapleader = ' '

vim.opt.ttyfast = true
vim.opt.lazyredraw = true
vim.opt.hidden = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.showmode = false
vim.opt.ruler = false
vim.opt.cursorline = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.list = true
vim.opt.wrap = false
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 0
vim.opt.softtabstop = 2
vim.opt.laststatus = 2
vim.opt.showtabline = 0
vim.opt.timeoutlen = 400
vim.opt.backspace = '2'
vim.opt.inccommand = 'nosplit'
vim.opt.belloff = 'all'
vim.opt.encoding = 'utf-8'
vim.opt.background = 'dark'
vim.opt.clipboard = vim.opt.clipboard + { 'unnamedplus' }
vim.opt.path = vim.opt.path + { '**' }
vim.opt.wildignore = vim.opt.wildignore
  + { '.git', '.DS_Store', 'node_modules' }
vim.opt.listchars = { tab = '‣ ', trail = '•' }
vim.opt.fillchars = { msgsep = ' ', vert = '│' }

if vim.opt.modifiable:get() then
  vim.opt.fileencoding = 'utf-8'
  vim.opt.fileformat = 'unix'
  vim.opt.fileformats = { 'unix', 'dos' }
end

if vim.fn.has('persistent_undo') == 1 then
  local persistent_undo_directory = vim.fn.expand(
    '~/.config/vim-persisted-undo'
  )

  if vim.fn.isdirectory(persistent_undo_directory) == 0 then
    vim.fn.system({ 'mkdir', '-p', persistent_undo_directory })
  end

  vim.opt.undodir = persistent_undo_directory
  vim.opt.undofile = true
end

if not bootstrap_plugins then
  vim.cmd('colorscheme base16-seti')
end

vim.cmd([[
    highlight CursorLine ctermbg=8 guibg=#282a2b
    highlight Normal guibg=NONE ctermbg=NONE
    highlight EndOfBuffer guibg=NONE ctermbg=NONE guifg=Black ctermfg=0
    highlight TrailingWhitespace ctermfg=0 guifg=Black ctermbg=8 guibg=#41535B
    highlight VertSplit guibg=NONE ctermbg=NONE guifg=Gray ctermfg=Gray
  ]])

-- no-op bad habit mappings
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

-- sometimes instead of pressing :q, I press q:, Q:, or :Q.
-- to fix this, we map em all to :q
map('', 'q:', ':q<Cr>')
map('', 'Q:', ':q<Cr>')

-- more intuitive navigation mappings in normal / visual / operator pending modes
noremap('', 'K', '{')
noremap('', 'J', '}')
noremap('', 'H', '^')
noremap('', 'L', '$')

-- easier one-off navigation in insert mode
noremap('i', '<C-k>', '<Up>')
noremap('i', '<C-j>', '<Down>')
noremap('i', '<C-h>', '<Left>')
noremap('i', '<C-l>', '<Right>')

-- save using <C-s> in every mode
noremap('n', '<C-s>', ':write<Cr>')
noremap('v', '<C-s>', '<C-c>:write<Cr>gv')
noremap('i', '<C-s>', '<C-o>:write<Cr>')
noremap('o', '<C-s>', '<Esc>:write<Cr>')

-- make Y consistent with C and D
noremap('n', 'Y', 'y$')

-- use qq to record, q to stop, Q to play a macro
noremap('n', 'Q', '@q')

-- when pairing brackets, parens, or quotes, place the cursor in the middle
noremap('i', '<>', '<><Left>')
noremap('i', '()', '()<Left>')
noremap('i', '{}', '{}<Left>')
noremap('i', '[]', '[]<Left>')
noremap('i', '""', '""<Left>')
noremap('i', "''", "''<Left>")
noremap('i', '``', '``<Left>')

-- use <Tab> and <S-Tab> to indent and unindent code
noremap('n', '<Tab>', '>>')
noremap('n', '<S-Tab>', '<<')
noremap('v', '<Tab>', '>><Esc>gv')
noremap('v', '<S-Tab>', '<<<Esc>gv')
noremap('i', '<S-Tab>', '<C-d>')

-- use <u> to undo, <U> to redo
noremap('n', 'U', '<C-r>')

-- enable acting on content between bar (|) characters
noremap('v', 'i<Bar>', ':<C-u>normal! T<Bar>vt<Bar><Cr>')
noremap('o', 'i<Bar>', ':<C-u>normal! T<Bar>vt<Bar><Cr>')
noremap('v', 'a<Bar>', ':<C-u>normal! F<Bar>vf<Bar><Cr>')
noremap('o', 'a<Bar>', ':<C-u>normal! F<Bar>vf<Bar><Cr>')

-- show syntax

-- use <C-n> and <C-m> to scroll through quickfix entries
function quickfix_next()
  vim.cmd('try | cnext | catch | cfirst | catch | endtry')
end

function quickfix_prev()
  vim.cmd('try | cprev | catch | clast | catch | endtry')
end

noremap('n', '<C-n>', ':call v:lua.quickfix_next()<Cr>', { silent = true })
noremap('n', '<C-m>', ':call v:lua.quickfix_prev()<Cr>', { silent = true })

-- close pane using <C-w>
function close_buffer()
  if
    #vim.fn.getbufinfo({ buflisted = 1, windows = { vim.fn.bufwinid('%') } })
    > 1
  then
    vim.cmd('bdelete')
  elseif #vim.fn.getwininfo() > 1 then
    vim.cmd('close')
  end
end

noremap('n', '<C-w>', ':call v:lua.close_buffer()<Cr>', { silent = true })

-- define auto commands
function indent_size(spaces)
  vim.opt_local.expandtab = true
  vim.opt_local.tabstop = spaces
  vim.opt_local.softtabstop = spaces
end

vim.cmd([[
    augroup InitAutoCommands
      au!

      au FileType markdown,python,json,javascript call v:lua.indent_size(4)
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
local status_mode_groups = {}
status_mode_groups['n'] = 'StatusLineSection'
status_mode_groups['v'] = 'StatusLineSectionV'
status_mode_groups[''] = 'StatusLineSectionV'
status_mode_groups['i'] = 'StatusLineSectionI'
status_mode_groups['c'] = 'StatusLineSectionC'
status_mode_groups['r'] = 'StatusLineSectionR'

function status_line()
  local group = status_mode_groups[vim.fn.mode():lower()]
    or status_mode_groups['n']
  local highlight = '%#' .. group .. '#'
  local filename = vim.fn.fnamemodify(vim.fn.expand('%'), ':~:.')

  if string.match(filename, '^~') then
    filename = vim.fn.fnamemodify(filename, ':t')
  end

  return (
      highlight
      .. (vim.opt.modified:get() == 1 and ' + |' or '')
      .. ' '
      .. filename
      .. ' %#StatusLine#%='
      .. highlight
      .. ' %l:%c '
    )
end

function status_line_colors()
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

if vim.fn.has('vim_starting') then
  vim.opt.statusline = ' %{fnamemodify(expand("%"), ":~:.")}%= %l:%c '
end

status_line_colors()

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

-- netrw {{{
if not bootstrap_plugins then
  vim.g.loaded_netrwPlugin = 1
end
-- }}}

-- fzf {{{
vim.g.fzf_preview_window = {}
vim.g.fzf_layout = { down = '20%' }

vim.cmd([[
    command! -bang -nargs=* FzfMkdxJumpToHeader
      \ call cursor(str2nr(get(matchlist(<q-args>, ' *\([0-9]\+\)'), 1, '')), 1)
  ]])

function fzf_grep()
  vim.fn['fzf#vim#grep'](
    'rg --column --line-number --hidden --smart-case --color=always .',
    1,
    { options = { '--delimiter=:', '--nth=4..', '--no-hscroll' } }
  )
end

function fzf_mkdx_headers()
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
noremap('n', '<C-x>', ':call v:lua.fzf_grep()<Cr>', { silent = true })
-- }}}

-- neogit {{{
if not bootstrap_plugins then
  require('neogit').setup({
    disable_hint = true,
    disable_signs = true,
    disable_commit_confirmation = true,
    disable_insert_on_commit = false,
    sections = {
      recent = false,
    },
  })
end

noremap('n', '<leader>m', ':Neogit<Cr>')
-- }}}

-- nvim-treesitter {{{
if not bootstrap_plugins then
  require('nvim-treesitter.configs').setup({
    ensure_installed = {
      'c',
      'cpp',
      'css',
      'fish',
      'html',
      'java',
      'javascript',
      'json',
      'lua',
      'perl',
      'php',
      'pug',
      'python',
      'ruby',
      'rust',
      'scss',
      'toml',
      'tsx',
      'typescript',
      'vim',
      'vue',
      'yaml',
    },
    highlight = {
      enable = true,
    },
  })
end
-- }}}

-- mkdx {{{
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

-- ale {{{
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
  rust = { 'rustfmt' },
  lua = { 'stylua' },
}

vim.g.ale_linters = {
  javascript = { 'eslint' },
  javascriptreact = { 'eslint' },
  typescript = { 'eslint' },
  typescriptreact = { 'eslint' },
  json = { 'eslint' },
  rust = { 'cargo' },
  ruby = { 'rubocop' },
}
-- }}}

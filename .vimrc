set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
set rtp+=/usr/local/opt/fzf
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'           " let vundle manage itself
Plugin 'w0rp/ale'                       " async linting of files
Plugin 'sheerun/vim-polyglot'           " lots of language packs in one plugin
Plugin 'christoomey/vim-tmux-navigator' " seamless pane switching between tmux and vim using vim binds
Plugin 'AndrewRadev/splitjoin.vim'      " toggle single line to multiline stuff
Plugin 'chriskempson/base16-vim'        " color scheme
Plugin 'itchyny/lightline.vim'          " bottom line displaying mode / file / time etc...
Plugin 'mgee/lightline-bufferline'      " show open buffers at top of window
Plugin 'jreybert/vimagit'               " interactive git staging
Plugin 'benmills/vimux'                 " Run commands from vim
Plugin 'tpope/vim-abolish'              " smart case replace and much more
Plugin 'tpope/vim-commentary'           " code commenting
Plugin 'tpope/vim-endwise'              " auto insert 'end'-like keywords
Plugin 'tpope/vim-fugitive'             " vim git wrapper, also used by vimagit
Plugin 'tpope/vim-repeat'               " better repeat, extensible by plugins
Plugin 'tpope/vim-vinegar'              " enhance netrw
Plugin 'tpope/vim-surround'             " change/add/remove surrounding brackets
Plugin 'junegunn/vim-slash'             " auto nohlsearch and some extra search goodies
Plugin 'junegunn/vim-easy-align'        " align code easier
Plugin 'junegunn/fzf.vim'               " fzf as vim plugin

" only emable to update tmux statusline look
" Plugin 'edkolev/tmuxline.vim'

call vundle#end()

if !exists('*s:IndentSize')
  function s:IndentSize(amount)
    execute("setlocal expandtab ts=" . a:amount . " sts=" . a:amount . " sw=" . a:amount)
  endfunction
endif

filetype plugin indent on
syntax enable                   " cuz white text is going to be awesome to edit :D
set path+=**                    " add cwd and 1 level of nesting to path
set hlsearch                    " highlight search matches
set incsearch                   " highlight search matches while typing
set hidden                      " debatable, allow switching from unsaved buffer without '!'
set ignorecase                  " ignore case in search
set smartcase                   " use case-sensitive if a capital letter is included
set noshowmode                  " statusline makes -- INSERT -- info irrelevant
set number                      " show lines
set relativenumber              " show relative number
set cursorline                  " highlight cursor line
set splitbelow                  " split below instead of above
set splitright                  " split after instead of before
set termguicolors               " enable termguicolors for better highlighting
set background=dark             " set bg dark
set nobackup                    " do not keep backups
set noswapfile                  " no more swapfiles
set clipboard=unnamed           " copy into osx clipboard by default
set encoding=utf-8              " utf-8 files
set fileencoding=utf-8          " utf-8 files
set fileformat=unix             " use unix line endings
set fileformats=unix,dos        " try unix line endings before dos, use unix
set laststatus=2                " always show statusline
set expandtab                   " softtabs, always (e.g. convert tabs to spaces)
set shiftwidth=2                " tabsize 2 spaces (by default)
set softtabstop=2               " tabsize 2 spaces (by default)
set tabstop=2                   " tabsize 2 spaces (by default)
set showtabline=2               " always show statusline
set backspace=2                 " restore backspace
set nowrap                      " do not wrap text at `textwidth`
set noerrorbells                " do not show error bells
set novisualbell                " do not use visual bell
set timeoutlen=250              " mapping delay
set ttimeoutlen=50              " keycode delay
set wildignore+=.git,.DS_Store  " ignore files
colorscheme base16-default-dark " apply color scheme

let mapleader = " "                                      " remap leader
let g:ale_echo_msg_error_str = 'E'                       " error sign
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]' " status line format
let g:ale_echo_msg_warning_str = 'W'                     " warning sign
let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']   " error status format
let g:ale_lint_delay = 1000                              " relint max once per second
let g:ale_set_loclist = 0                                " do not use location list
let g:ale_set_quickfix = 1                               " but do use quickfix list
let g:jsx_ext_required = 0                               " do not require .jsx extension for correct syntax highlighting
let g:lightline#bufferline#show_number = 2               " show buf number in bufferline
let g:lightline#bufferline#shorten_path = 1              " do not show full path
let g:lightline#bufferline#modified = '[+]'              " modifier buffer label
let g:lightline#bufferline#read_only = '[!]'             " readonly buffer label
let g:lightline#bufferline#unnamed = '[*]'               " unnamed buffer label
let g:splitjoin_split_mapping = ''                       " reset splitjoin mappings
let g:splitjoin_join_mapping = ''                        " reset splitjoin mappings
let g:VimuxPromptString = '% '                           " change default vim prompt string
let g:VimuxResetSequence = 'q C-u C-l'                   " clear output before running a command
let g:fzf_layout = { 'down': '~20%' }
let g:netrw_banner = 0
let g:netrw_winsize = 20
let g:netrw_liststyle= 3
let g:netrw_altv = 1

" additional ale settings
let g:ale_linters = {
      \ 'ruby': ['rubocop'],
      \ 'javascript': ['eslint']
      \ }

" additional easyalign delims
let g:easy_align_delimiters = {
      \ '?': {'pattern': '?'},
      \ '>': {'pattern': '>>\|=>\|>'}
      \ }

" additional lightline configuration
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'tabline': {
      \    'left': [[ 'buffers' ]],
      \ },
      \ 'component_expand': {
      \    'buffers': 'lightline#bufferline#buffers',
      \ },
      \ 'component_type': {
      \    'buffers': 'tabsel',
      \ },
      \ 'component_function': {
      \    'bufferbefore': 'lightline#buffer#bufferbefore',
      \    'bufferafter':  'lightline#buffer#bufferafter',
      \    'bufferinfo':   'lightline#buffer#bufferinfo',
      \ },
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'modified', 'fugitive', 'filename' ] ],
      \   'right': [ [ 'lineinfo'],
      \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component': {
      \   'mode':     '%{lightline#mode()[0]}',
      \   'readonly': '%{&filetype=="help"?"":&readonly?"[!]":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"[+]":&modifiable?"":"[-]"}',
      \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
      \ },
      \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
      \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" }
      \ }

" tmuxline preset
let g:tmuxline_preset = {
        \    'a':    '⬤',
        \    'win':  '#I #W',
        \    'cwin': '#I #W',
        \    'y':    '%d·%m·%Y',
        \    'z':    '%R',
        \    'options': {
        \      'status-justify': 'left'
        \    }
        \ }
"
" use ripgrep as grepprg
if executable('rg')
  set grepprg=rg\ --color=never\ --vimgrep\ --no-ignore-vcs\ --follow\ --hidden\ --glob\ ''
endif

" mappings
nnoremap <C-x> :bd<CR>
nmap     ga <Plug>(EasyAlign)
xmap     ga <Plug>(EasyAlign)
nmap     <C-p> :Files<CR>
nmap     <C-m> :Ag<CR>
noremap  <Leader>j :SplitjoinJoin<CR>
noremap  <Leader>J :SplitjoinSplit<CR>
noremap  <Leader>m :MagitO<CR>
noremap  <Leader>p :VimuxRunCommand("git pull")<CR>
noremap  <Leader>P :VimuxRunCommand("git push")<CR>
noremap  <Leader>rt :VimuxRunCommand("clear;" . &ft . " " . bufname("%"))<CR>
noremap  <Leader>rr :VimuxPromptCommand<CR>
noremap  <Leader>rl :VimuxRunLastCommand<CR>
noremap  <Leader>re :VimuxCloseRunner<CR>
nmap     <Leader>1 <Plug>lightline#bufferline#go(1)
nmap     <Leader>2 <Plug>lightline#bufferline#go(2)
nmap     <Leader>3 <Plug>lightline#bufferline#go(3)
nmap     <Leader>4 <Plug>lightline#bufferline#go(4)
nmap     <Leader>5 <Plug>lightline#bufferline#go(5)
nmap     <Leader>6 <Plug>lightline#bufferline#go(6)
nmap     <Leader>7 <Plug>lightline#bufferline#go(7)
nmap     <Leader>8 <Plug>lightline#bufferline#go(8)
nmap     <Leader>9 <Plug>lightline#bufferline#go(9)
nmap     <Leader>0 <Plug>lightline#bufferline#go(10)
nmap     <Tab> >>
nmap     <S-Tab> <<
vmap     <Tab> >><ESC>gv
vmap     <S-Tab> <<<ESC>gv
noremap  <Up>    <NOP>
noremap  <Down>  <NOP>
noremap  <Left>  <NOP>
noremap  <Right> <NOP>

" fix jsx highlighting of end xml tags
hi link xmlEndTag xmlTag

" file autocmds
augroup Files
  au!
  au BufWritePre *                %s/\s\+$//e          " remove trailing whitespace
  au FileType javascript,jsx      call s:IndentSize(4) " 4 space indent languages
augroup END

" global autocmds
augroup Global
  au!
  au BufEnter,WinEnter,WinNew,VimResized *,*.*
        \ let &scrolloff=getwininfo(win_getid())[0]['height']/2 " keep cursor centered
  au VimResized * wincmd =                                      " auto resize splits on resize
augroup END

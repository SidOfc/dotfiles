set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'           " most important, manages all other plugins
Plugin 'sheerun/vim-polyglot'           " lots of language packs in one plugin
Plugin 'Shougo/unite.vim'               " required for file explorer
Plugin 'Shougo/vimfiler.vim'            " file explorer attempt #2
Plugin 'chriskempson/base16-vim'        " see lines about base16 shell below
Plugin 'christoomey/vim-tmux-navigator' " seamless pane switching between tmux and vim using vim binds
Plugin 'ctrlpvim/ctrlp.vim'             " fuzzy file finder
Plugin 'haya14busa/incsearch.vim'       " show highlight while searching, hide highlight when done
Plugin 'hail2u/vim-css3-syntax'         " CSS3 support
Plugin 'itchyny/lightline.vim'          " bottom line displaying mode / file / time etc...
Plugin 'jreybert/vimagit'               " interactive git staging
Plugin 'junegunn/gv.vim'                " git commit browser
Plugin 'junegunn/vim-easy-align'        " align code easier
Plugin 'mgee/lightline-bufferline'      " show open buffers at top of window
Plugin 'slim-template/vim-slim'         " slim-lang support
Plugin 'tpope/vim-abolish'              " smart case replace
Plugin 'tpope/vim-commentary'           " easily insert comments
Plugin 'tpope/vim-endwise'              " auto insert 'end' keyword for ruby-like languages
Plugin 'tpope/vim-fugitive'             " I will never git without it :D
Plugin 'tpope/vim-haml'                 " HAML support
Plugin 'tpope/vim-repeat'               " better repeat, extensible by plugins
Plugin 'tpope/vim-sleuth'               " autodetect indent
Plugin 'tpope/vim-surround'             " change any surrounding with ease, e.g. { to [ or (.
Plugin 'w0rp/ale'                       " async linting of files, alternative to syntastic
Plugin 'fmoralesc/vim-pad'              " take notes with vim
Plugin 'wellle/targets.vim'             " more flexible text-objects
Plugin 'AndrewRadev/splitjoin.vim'      " toggle single line to multiline stuff
Plugin 'benmills/vimux'                 " Run commands from vim

" only emable to update tmux statusline look
" Plugin 'edkolev/tmuxline.vim'

call vundle#end()

filetype plugin indent on
syntax enable                         " cuz white text is going to be awesome to edit :D
set expandtab                         " softtabs, always
set hidden                            " debatable, allow switching from unsaved buffer without '!'
set ignorecase                        " ignore case in search
set smartcase                         " use case-sensitive if a capital letter is included
set noshowmode                        " statusline makes -- INSERT -- info irrelevant
set number                            " show lines
set relativenumber                    " show relative number
set splitbelow                        " split below instead of above
set splitright                        " split after instead of before
set termguicolors                     " enable termguicolors for better highlighting
set background=dark                   " set bg dark
set nobackup
set noswapfile                        " no more swapfiles
set clipboard=unnamed                 " copy into osx clipboard by default
set encoding=utf-8                    " utf-8 files
set fileencoding=utf-8                " utf-8 files
set fileformat=unix                   " use unix line endings
set fileformats=unix,dos              " try unix line endings before dos, use unix
set laststatus=2                      " always show statusline
set shiftwidth=2                      " tabsize 2 spaces
set showtabline=2                     " always show statusline
set tabstop=2                         " tabsize 2 spaces
set backspace=2                       " restore backspace
set nowrap                            " do not wrap text at `textwidth`
set noerrorbells                      " do not show error bells
set novisualbell                      " do not use visual bell
set ttimeoutlen=50                    " keycode delay
set wildignore+=.git,.DS_Store,.,..   " ignore files
colorscheme base16-default-dark       " apply color scheme

let mapleader = " "                                      " remap leader
let g:pad#dir = expand('~/notes')                        " dir to store notes from vim-pad
let g:pad#window_height = 20                             " default window height
let g:pad#set_mappings = 0                               " do not set default vim-pad mappings
let g:ale_echo_msg_error_str = 'E'                       " error sign
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]' " status line format
let g:ale_echo_msg_warning_str = 'W'                     " warning sign
let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']   " error status format
let g:ctrlp_show_hidden = 1                              " allow ctrlp to show hidden files
let g:incsearch#auto_nohlsearch = 1                      " auto unhighlight after searching
let g:incsearch#magic = '\v'                             " sheer awesomeness
let g:incsearch#do_not_save_error_message_history = 1    " do not store incsearch errors in history
let g:incsearch#consistent_n_direction = 1               " when searching backward, do not invert meaning of n and N
let g:jsx_ext_required = 0                               " do not require .jsx extension for correct syntax highlighting
let g:lightline#bufferline#show_number = 2               " show buf number in bufferline
let g:lightline#bufferline#shorten_path = 1              " do not show full path
let g:lightline#bufferline#modified = '[+]'              " modifier buffer label
let g:lightline#bufferline#read_only = '[!]'             " readonly buffer label
let g:lightline#bufferline#unnamed = '[*]'               " unnamed buffer label
let g:vimfiler_as_default_explorer = 1                   " do not use netrw
let g:vimfiler_ignore_pattern = '.git|.DS_Store|.|..'
let g:splitjoin_split_mapping = ''                       " reset splitjoin mappings
let g:splitjoin_join_mapping = ''                        " reset splitjoin mappings
let g:VimuxPromptString = '% '                           " change default vim prompt string
let g:VimuxResetSequence = 'q C-u C-l'                   " clear output before running a command

" additional ale settings
let g:ale_linters = {
      \ 'ruby': ['rubocop'],
      \ 'javascript': ['eslint']
      \ }

" additional vimfiler settings
call vimfiler#custom#profile('default', 'context', {
      \ 'safe': 0
      \ })

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
      \   'right': [ [ 'lineinfo', 'sleuth' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component': {
      \   'mode':     '%{lightline#mode()[0]}',
      \   'sleuth':   '%{SleuthIndicator()}',
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
        \ 'a':    '⬤',
        \ 'win':  '#I #W',
        \ 'cwin': '#I #W',
        \ 'y':    '%d·%m·%Y',
        \ 'z':    '%R',
        \ 'options': {
        \   'status-justify': 'left'
        \ }
        \ }

if executable('rg')
  set grepprg=rg\ --color=never\ --vimgrep\ --no-ignore-vcs\ --hidden\ --glob\ ''             " use ripgrep as grepprg

  let g:ctrlp_use_caching  = 0                                                                " do not use caching in ctrlp
  let g:ctrlp_user_command = 'rg %s --files --color=never --no-ignore-vcs --hidden --glob ""' " use ripgrep in ctrlp
endif

" mappings
nnoremap <C-x> :bd<CR>
nmap     / <Plug>(incsearch-forward)
nmap     ? <Plug>(incsearch-backward)
nmap     g/ <Plug>(incsearch-stay)
nmap     ga <Plug>(EasyAlign)
xmap     ga <Plug>(EasyAlign)
noremap  <Leader>j :SplitjoinJoin<CR>
noremap  <Leader>J :SplitjoinSplit<CR>
noremap  <Leader>m :MagitO<CR>
noremap  <Leader>N :Pad new<CR>
noremap  <Leader>n :Pad ls<CR>
noremap  <Leader>l :GV<CR>
noremap  <Leader>p :VimuxRunCommand("git pull")<CR>
noremap  <Leader>P :VimuxRunCommand("git push")<CR>
noremap  <Leader>s :VimuxRunCommand("git status")<CR>
noremap  <Leader>O :Gdiff<CR>
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
noremap  <Up>    <NOP>
noremap  <Down>  <NOP>
noremap  <Left>  <NOP>
noremap  <Right> <NOP>

" in diff mode
if &diff
  let g:ctrlp_map = '<C-q>'

  nnoremap <C-n> ]c
  nmap     <C-p> [c
endif

" fix jsx highlighting of end xml tags
hi link xmlEndTag xmlTag

" incsearch consistent highlighting / different color for
" match on cursor
hi IncSearchMatch    guibg=#bbbbbb guifg=#121212
hi IncSearchOnCursor guibg=#c27b4d guifg=#121212
hi link IncSearchCursor IncSearchOnCursor

if !exists('*s:VimFilerOverride')
  function s:VimFilerOverride()
    nunmap <buffer> <Space>
  endfunction
endif

" file autocmds
augroup Files
  au!
  au BufWritePre *     %s/\s\+$//e               " remove trailing whitespace
  au FileType vimfiler call s:VimFilerOverride() " keep using <Space-N> to switch tabs in vimfiler buffer
augroup END

" global autocmds
augroup Global
  au!
  au BufEnter,WinEnter,WinNew,VimResized *,*.*
        \ let &scrolloff=getwininfo(win_getid())[0]['height']/2 " keep cursor centered
  au VimResized * wincmd =                                      " auto resize splits on resize
augroup END

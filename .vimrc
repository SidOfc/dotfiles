set nocompatible " required for package management
filetype off " ditto

" plugin statements / loading
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'                " most important, manages all other plugins
Plugin 'chriskempson/base16-vim'             " see lines about base16 shell below
Plugin 'christoomey/vim-tmux-navigator'      " seamless pane switching between tmux and vim using vim binds
Plugin 'ctrlpvim/ctrlp.vim'                  " fuzzy file finder
Plugin 'danilo-augusto/vim-afterglow'        " set terminal to use same background as vim
Plugin 'easymotion/vim-easymotion'           " highlight matches -> allow navigating with specific character per match
Plugin 'hail2u/vim-css3-syntax'              " CSS3 support
Plugin 'haya14busa/incsearch.vim'            " show highlight while searching, hide highlight when done
Plugin 'haya14busa/incsearch-easymotion.vim' " use easymotion with incsearch plugin
Plugin 'itchyny/lightline.vim'               " bottom line displaying mode / file / time etc...
Plugin 'jreybert/vimagit'                    " interactive git staging
Plugin 'juleswang/css.vim'                   " improved CSS highlighting
Plugin 'junegunn/gv.vim'                     " git commit browser
Plugin 'junegunn/vim-easy-align'             " align code easier
Plugin 'kchmck/vim-coffee-script'            " coffeescript support
Plugin 'mgee/lightline-bufferline'           " show open buffers at top of window
Plugin 'mxw/vim-jsx'                         " JSX support
Plugin 'pangloss/vim-javascript'             " improved JS support
Plugin 'rhysd/vim-crystal'                   " crystal-lang support
Plugin 'Shougo/unite.vim'                    " required for file explorer
Plugin 'Shougo/vimfiler.vim'                 " file explorer attempt #2
Plugin 'sjl/gundo.vim'                       " visual undo
Plugin 'slim-template/vim-slim'              " slim-lang support
Plugin 'tpope/vim-abolish'                   " smart case replace
Plugin 'tpope/vim-commentary'                " easily insert comments
Plugin 'tpope/vim-dispatch'                  " run some commands in the background
Plugin 'tpope/vim-endwise'                   " auto insert 'end' keyword for ruby-like languages
Plugin 'tpope/vim-fugitive'                  " I will never git without it :D
Plugin 'tpope/vim-haml'                      " HAML support
Plugin 'tpope/vim-repeat'                    " better repeat, extensible by plugins
Plugin 'tpope/vim-sleuth'                    " autodetect indent
Plugin 'tpope/vim-surround'                  " change any surrounding with ease, e.g. { to [ or ( for instance
Plugin 'w0rp/ale'                            " async linting of files, alternative to syntastic
Plugin 'whatyouhide/vim-lengthmatters'       " plugin for highlighting after 80 cols, has an edge over default match commands
Plugin 'fmoralesc/vim-pad'                   " take notes with vim
Plugin 'edkolev/tmuxline.vim'                " tmux statusline match lightline theme
Plugin 'airblade/vim-gitgutter'              " show git status in gutter
Plugin 'michaeljsmith/vim-indent-object'     " indentation based text-object

call vundle#end()

" set statements
filetype plugin indent on
syntax enable                         " cuz white text is going to be awesome to edit :D
set autoindent                        " auto indent code
set cursorline                        " highlight cursor line
set expandtab                         " softtabs, always
set signcolumn="yes"                  " always show signcolumn
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
set backspace=indent,eol,start        " reset backspace to gui-sanity level
set backupdir=~/.vim-tmp,~/.tmp,~/tmp " place to keep swap files
set clipboard^=unnamed                " copy into osx clipboard by default
set directory=~/.vim-tmp,~/.tmp,~/tmp " ditto
set encoding=utf-8                    " utf-8 files
set fileencoding=utf-8                " utf-8 files
set fileformat=unix                   " use unix line endings
set fileformats=unix,dos              " try unix line endings before dos, use unix
set laststatus=2                      " always show statusline
set shiftwidth=2                      " tabsize 2 spaces
set showtabline=2                     " always show statusline
set tabstop=2                         " tabsize 2 spaces
set timeoutlen=300                    " mapping delays
set ttimeoutlen=10                    " keycode delay
set updatetime=300                    " increase refresh rate
colorscheme base16-tomorrow-night     " apply color scheme

" let statements
let mapleader = " "                                                   " remap leader
let g:pad#dir = expand('~/notes')                                     " dir to store notes from vim-pad
let g:pad#window_height = 20                                          " default window height
let g:pad#open_in_split = 0                                           " open notes fullscreen
let g:pad#set_mappings = 0                                            " do not set default vim-pad mappings
let g:ale_echo_msg_error_str = 'E'                                    " error sign
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'              " status line format
let g:ale_echo_msg_warning_str = 'W'                                  " warning sign
let g:ale_linters = { 'ruby': ['rubocop'], 'javascript': ['eslint'] } " specify linters
let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']                " error status format
let g:ctrlp_show_hidden = 1                                           " allow ctrlp to show hidden files
let g:incsearch#auto_nohlsearch = 1                                   " auto unhighlight after searching
let g:incsearch#magic = '\v'                                          " sheer awesomeness
let g:jsx_ext_required = 0                                            " do not require .jsx extension for correct syntax highlighting
let g:incsearch#do_not_save_error_message_history = 1                 " do not store incsearch errors in history
let g:incsearch#consistent_n_direction = 1                            " when searching backward, do not invert meaning of n and N
let g:lightline#bufferline#show_number = 2                            " show buf number in bufferline
let g:lightline#bufferline#shorten_path = 1                           " do not show full path
let g:lightline#bufferline#modified = '[+]'                           " modifier buffer label
let g:lightline#bufferline#read_only = '[!]'                          " readonly buffer label
let g:lightline#bufferline#unnamed = '[*]'                            " unnamed buffer label
let g:gundo_width = 80                                                " visual undo screen width
let g:gundo_preview_height = 25                                       " visual undo preview diff height
let g:gundo_return_on_revert = 0                                      " stay in gundo after reverting instead
let g:gundo_prefer_python3 = 1                                        " lets move forward :P
let g:lengthmatters_highlight_one_column = 1                          " only highlight 81st column on long lines
let g:vimfiler_as_default_explorer = 1                                " do not use netrw
let g:lengthmatters_excluded = ['vimfiler', 'gundo', 'magit',
                              \ 'GV', 'help']                         " exclude highlighting > 80 cols for these filetypes

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
        \ 'a':    '#S',
        \ 'win':  '#I #W',
        \ 'cwin': '#I #W',
        \ 'y':    '%d·%m·%Y',
        \ 'z':    '%R',
        \ 'options': {
        \   'status-justify': 'left'
        \ }
        \ }

if executable('ag')
  set grepprg=ag\ --vimgrep

  let g:ctrlp_use_caching  = 0                                   " do not use caching in ctrlp
  let g:ctrlp_user_command = 'ag %s -l --hidden --nocolor -g ""' " use ag with ctrlp
endif

" sources:
"   https://github.com/chriskempson/base16-shell (Shell config)
"   https://github.com/chriskempson/base16-vim/ (Plugin)
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

" mappings
nnoremap <Tab> :make<CR>
nmap     / <Plug>(incsearch-easymotion-/)
nmap     ? <Plug>(incsearch-easymotion-?)
nmap     g/ <Plug>(incsearch-easymotion-stay)
nmap     ga <Plug>(EasyAlign)
xmap     ga <Plug>(EasyAlign)
nmap     <silent> <C-k> <Plug>(ale_previous)
nmap     <silent> <C-j> <Plug>(ale_next)
nmap     <Leader>w <Plug>(easymotion-bd-w)
nmap     <Leader>f <Plug>(easymotion-bd-f)
nmap     n <Plug>(easymotion-next)
nmap     N <Plug>(easymotion-prev)
noremap  <Leader>u :GundoToggle<CR>
noremap  <Leader>m :MagitO<CR>
noremap  <Leader>N :Pad new<CR>
noremap  <Leader>n :Pad ls<CR>
noremap  <Leader>p :Dispatch! git push<CR>
noremap  <Leader>o :Dispatch! git pull<CR>
noremap  <Leader>l :GV<CR>
noremap  <Leader>s :up<CR>
vnoremap <Leader>u :GundoToggle<CR>gv
vnoremap <Leader>m :MagitO<CR>gv
vnoremap <Leader>N :Pad ls<CR>gv
vnoremap <Leader>p :Dispatch! git push<CR>gv
vnoremap <Leader>l :Dispatch! git pull<CR>gv
vnoremap <Leader>s :up<CR>gv
nnoremap <C-x> :bd<CR>
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
hi IncSearchMatch guibg=#bbbbbb guifg=#121212
hi IncSearchOnCursor guibg=#c27b4d guifg=#121212
hi link IncSearchCursor IncSearchOnCursor

" link highlight groups of plugin that uses incsearch
" for consistent highlighting
hi link EasyMotionMoveHL IncSearchOnCursor
hi link EasyMotionIncSearch IncSearchMatch

if !exists('*s:VimFilerOverride')
  function s:VimFilerOverride()
    nunmap <buffer> <Space>
  endfunction
endif

" file autocmds
augroup Files
  au!
  au BufWritePre *              %s/\s\+$//e                     " remove trailing whitespace
  au FileType vimfiler          call s:VimFilerOverride()       " keep using <Space-N> to switch tabs in vimfiler buffer
  au FileType jsx,javascript    setlocal makeprg=node\ %        " use node as compiler for javascript files
  au FileType ruby              setlocal makeprg=ruby\ %        " use ruby as compiler for ruby files
  au FileType python            setlocal makeprg=python3\ %     " use python as compiler for python files
  au FileType crystal           setlocal makeprg=crystal\ %     " use crystal as compiler for crystal files
augroup END

" global autocmds
augroup Global
  au!
  au BufEnter,WinEnter,WinNew,VimResized *,*.*
        \ let &scrolloff=getwininfo(win_getid())[0]['height']/2 " keep cursor centered
  au VimResized * wincmd =                                      " auto resize splits on resize
augroup END

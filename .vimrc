" Init / Vundle {{{
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
  Plugin 'tpope/vim-commentary'           " code commenting
  Plugin 'tpope/vim-endwise'              " auto insert 'end'-like keywords
  Plugin 'tpope/vim-fugitive'             " vim git wrapper, also used by vimagit
  Plugin 'tpope/vim-repeat'               " better repeat, extensible by plugins
  Plugin 'tpope/vim-surround'             " change/add/remove surrounding brackets
  Plugin 'haya14busa/incsearch.vim'       " auto nohlsearch and some extra search goodies
  Plugin 'junegunn/vim-easy-align'        " align code easier
  Plugin 'junegunn/fzf.vim'               " fzf as vim plugin
  Plugin 'fmoralesc/vim-pad'              " notes

  " only emable to update tmux statusline look
  " Tmuxline lightline[_[insert|visual]] to preview
  " TmuxlineSnapshot! ~/.dotfiles/.tmuxline-colors.conf to save
  " Plugin 'edkolev/tmuxline.vim'
  call vundle#end()
" }}}

" General {{{
  let mapleader = " " " remap leader

  filetype plugin indent on
  colorscheme base16-default-dark " apply color scheme
  syntax enable                   " cuz white text is going to be awesome to edit :D
  set path+=**                    " add cwd and 1 level of nesting to path
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
  set visualbell                  " do not use visual bell
  set t_vb=                       " do not flash screen with visualbell
  set timeoutlen=500              " mapping delay
  set ttimeoutlen=10              " keycode delay
  set wildignore+=.git,.DS_Store  " ignore files (netrw)
  set scrolloff=10                " show 10 lines of context around cursor

  " change cursor shape in various modes
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"

  " remap bad habits to do nothing
  imap     <Up>    <Nop>
  imap     <Down>  <Nop>
  imap     <Left>  <Nop>
  imap     <Right> <Nop>
  nmap     <Up>    <Nop>
  nmap     <Down>  <Nop>
  nmap     <Left>  <Nop>
  nmap     <Right> <Nop>
  nmap     <S-s>   <Nop>
  nmap     >>      <Nop>
  nmap     <<      <Nop>
  vmap     >>      <Nop>
  vmap     <<      <Nop>
  map      $       <Nop>
  map      ^       <Nop>
  map      {       <Nop>
  map      }       <Nop>

  " easier navigation in normal / visual / operator pending mode
  noremap  K     {
  noremap  J     }
  noremap  H     ^
  noremap  L     $

  " save using <C-s> in every mode
  " when in operator-pending or insert, takes you to normal mode
  nnoremap <C-s> :update<Cr>
  vnoremap <C-s> <C-c>:update<Cr>
  inoremap <C-s> <Esc>:update<Cr>
  onoremap <C-s> <Esc>:update<Cr>

  " close pane using <C-w> since I know it from Chrome / Atom (cmd+w) and do
  " not use the <C-w> mappings anyway
  noremap  <C-w> :bd<Cr>

  " easier navigation in insert mode
  inoremap <C-k> <Up>
  inoremap <C-j> <Down>
  inoremap <C-h> <Left>
  inoremap <C-l> <Right>

  " make Y consistent with C and D
  nnoremap Y y$

  " use qq to record, q to stop, Q to play a macro
  nnoremap Q @q

  " use tab and shift tab to indent and de-indent code
  nnoremap <Tab>   >>
  nnoremap <S-Tab> <<
  vnoremap <Tab>   >><Esc>gv
  vnoremap <S-Tab> <<<Esc>gv

  " add i| and a| operator pending motions for pipe characters
  onoremap i\| :<C-u>normal! f\|lvt\|<Cr>
  onoremap a\| :<C-u>normal! f\|vf\|<Cr>

  " when pairing some braces or quotes, put cursor between them
  inoremap <> <><Left>
  inoremap () ()<Left>
  inoremap {} {}<Left>
  inoremap [] []<Left>
  inoremap "" ""<Left>
  inoremap '' ''<Left>
  inoremap `` ``<Left>

  if &diff
    " use familiar C-n and C-p binds to move between hunks
    nnoremap <C-n> ]c
    nnoremap <C-p> [c

    " unbind indent and de-indent keys in diff mode
    nunmap <S-tab>
    nunmap <Tab>

    " instead use tab to inject local change and shift tab for remote change
    nnoremap <Tab>   :diffg LO<Cr>
    nnoremap <S-Tab> :diffg RE<Cr>
  endif

  " fix jsx highlighting of end xml tags
  hi link xmlEndTag xmlTag

  " convenience function for setting filetype specific spacing
  if !exists('*s:IndentSize')
    function s:IndentSize(amount)
      exe "setlocal expandtab ts=" . a:amount . " sts=" . a:amount . " sw=" . a:amount
    endfunction
  endif

  " use ripgrep as grepprg
  if executable('rg')
    set grepprg=rg\ --vimgrep\ --hidden\ --no-ignore-vcs
    set grepformat=%f:%l:%c:%m,%f:%l:%m
  endif
" }}}

" Netrw {{{
  let g:netrw_banner    = 0
  let g:netrw_winsize   = 20
  let g:netrw_liststyle = 3
  let g:netrw_altv      = 1
" }}}

" Vim-pad {{{
  let g:pad#dir = '~/notes'
  let g:pad#window_height = 20
  let g:pad#set_mappings = 0
  let g:pad#open_in_split = 0

  noremap <Leader>n :Pad ls<Cr>
  noremap <Leader>N :Pad new<Cr>
" }}}

" Tmuxline {{{
  " tmux statusline custom format
  let g:tmuxline_preset = {
        \ 'a':    '⊞',
        \ 'win':  '#I #W',
        \ 'cwin': '#I #W',
        \ 'y':    '%d·%m·%Y',
        \ 'z':    '%R',
        \ 'options': { 'status-justify': 'left' }
        \ }
" }}}

" Ale {{{
  let g:ale_echo_msg_error_str = 'E'                       " error sign
  let g:ale_echo_msg_format = '[%linter%] %s [%severity%]' " status line format
  let g:ale_echo_msg_warning_str = 'W'                     " warning sign
  let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']   " error status format
  let g:ale_lint_delay = 1000                              " relint max once per second
  let g:ale_set_loclist = 0                                " do not use location list
  let g:ale_set_quickfix = 1                               " but do use quickfix list
  let g:ale_linters = {
        \ 'ruby': ['rubocop'],
        \ 'javascript': ['eslint']
        \ }
" }}}

" Incsearch {{{
  let g:incsearch#auto_nohlsearch = 1                   " auto unhighlight after searching
  let g:incsearch#magic = '\v'                          " sheer awesomeness
  let g:incsearch#do_not_save_error_message_history = 1 " do not store incsearch errors in history
  let g:incsearch#consistent_n_direction = 1            " when searching backward, do not invert meaning of n and N

  map / <Plug>(incsearch-forward)
  map ? <Plug>(incsearch-backward)
" }}}

" Lightline {{{
  let g:lightline#bufferline#show_number = 2   " show buf number in bufferline
  let g:lightline#bufferline#shorten_path = 1  " do not show full path
  let g:lightline#bufferline#modified = '[+]'  " modifier buffer label
  let g:lightline#bufferline#read_only = '[!]' " readonly buffer label
  let g:lightline#bufferline#unnamed = '[*]'   " unnamed buffer label
  let g:lightline = {
        \ 'colorscheme':      'wombat',
        \ 'tabline':          { 'left': [[ 'buffers' ]] },
        \ 'component_expand': { 'buffers': 'lightline#bufferline#buffers' },
        \ 'component_type':   { 'buffers': 'tabsel' },
        \ 'separator':        { 'left': "\ue0b0", 'right': "\ue0b2" },
        \ 'subseparator':     { 'left': "\ue0b1", 'right': "\ue0b3" },
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
        \   'paste':    '(&paste!="nopaste")',
        \   'readonly': '(&filetype!="help"&& &readonly)',
        \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
        \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
        \ }
        \ }

  nmap <Leader>1 <Plug>lightline#bufferline#go(1)
  nmap <Leader>2 <Plug>lightline#bufferline#go(2)
  nmap <Leader>3 <Plug>lightline#bufferline#go(3)
  nmap <Leader>4 <Plug>lightline#bufferline#go(4)
  nmap <Leader>5 <Plug>lightline#bufferline#go(5)
  nmap <Leader>6 <Plug>lightline#bufferline#go(6)
  nmap <Leader>7 <Plug>lightline#bufferline#go(7)
  nmap <Leader>8 <Plug>lightline#bufferline#go(8)
  nmap <Leader>9 <Plug>lightline#bufferline#go(9)
  nmap <Leader>0 <Plug>lightline#bufferline#go(10)
" }}}

" Vimux {{{
  let g:VimuxPromptString = '% '         " change default vim prompt string
  let g:VimuxResetSequence = 'q C-u C-l' " clear output before running a command

  noremap <Leader>p  :VimuxRunCommand("git pull")<Cr>
  noremap <Leader>P  :VimuxRunCommand("git push")<Cr>
  noremap <Leader>rt :VimuxRunCommand("clear;" . &ft . " " . bufname("%"))<Cr>
  noremap <Leader>rr :VimuxPromptCommand<Cr>
  noremap <Leader>rl :VimuxRunLastCommand<Cr>
  noremap <Leader>re :VimuxCloseRunner<Cr>
" }}}

" Splitjoin {{{
  let g:splitjoin_split_mapping = '' " reset splitjoin mappings
  let g:splitjoin_join_mapping = ''  " reset splitjoin mappings

  noremap <Leader>j :SplitjoinJoin<Cr>
  noremap <Leader>J :SplitjoinSplit<Cr>
" }}}

" Fzf {{{
  " use bottom positioned 20% height bottom split
  let g:fzf_layout = { 'down': '~20%' }

  " only use FZF shortcuts in non diff-mode
  if !&diff
    nnoremap <C-p> :Files<Cr>
    nnoremap <C-g> :Ag<Cr>
  endif
" }}}

" Vimagit {{{
  noremap  <Leader>m :MagitO<Cr>
" }}}

" Easyalign {{{
  " some additional easyalign patterns to use with `ga` mapping
  let g:easy_align_delimiters = {
        \ '?': {'pattern': '?'},
        \ '>': {'pattern': '>>\|=>\|>'}
        \ }

  xmap ga <Plug>(EasyAlign)
  nmap ga <Plug>(EasyAlign)
" }}}

" Autocommands {{{
  augroup Global
    au!
    au BufEnter,WinEnter,WinNew,VimResized *,*.*
          \ let &scrolloff=getwininfo(win_getid())[0]['height']/2 " keep cursor centered
    au VimResized * wincmd =                                      " auto resize splits on resize
  augroup END

  augroup Files
    au!
    au BufWritePre *                %s/\s\+$//e          " remove trailing whitespace
    au FileType javascript,jsx,json call s:IndentSize(4) " 4 space indent languages
  augroup END
" }}}

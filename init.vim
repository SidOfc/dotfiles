" Some things to remember {{{
"   - In Visual-Block mode, pressing 'o' will move to the opposite end
"   - This init.vim file depends on https://github.com/junegunn/vim-plug
"     being installed!.
" }}}

" Init / Plugins {{{
  " vim-specific 'set' statements,
  " on by default / removed in nvim.
  set ttyfast
  set nocompatible

  " needs to be defined above the plugin
  let g:polyglot_disabled = ['markdown', 'stylus', 'typescript']

  call plug#begin('~/.vim/plugged')
  Plug 'chriskempson/base16-vim'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'easymotion/vim-easymotion'
  Plug 'jreybert/vimagit'
  Plug 'junegunn/vim-easy-align'
  Plug 'junegunn/vader.vim'
  Plug 'machakann/vim-highlightedyank'
  Plug 'pangloss/vim-javascript'
  Plug 'leafgarland/typescript-vim'
  Plug 'rust-lang/rust.vim'
  Plug 'sheerun/vim-polyglot'
  Plug 'iloginow/vim-stylus'
  Plug 'styled-components/vim-styled-components', {'branch': 'main'}
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-endwise'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'
  Plug 'w0rp/ale'
  Plug 'SidOfc/treevial'
  " Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

  if has('mac')
    Plug '/usr/local/opt/fzf'
  else
    Plug '~/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  endif

  Plug 'junegunn/fzf.vim'

  if $VIM_DEV
    if !$DISABLE_MKDX
      Plug '~/Dev/sidofc/viml/mkdx'
    endif
  else
    Plug 'SidOfc/mkdx'
  endif

  call plug#end()
" }}}
" General {{{
  " my leader of choice is <space>
  let mapleader = ' '

  " substitute with live-highlight preview on matches
  if has('nvim')
    set inccommand=nosplit
  endif

  " store undo history in a file. even after closing and reopening vim
  " changes from previous editing session are still available.
  if has('persistent_undo')
    let target_path = expand('~/.config/vim-persisted-undo/')

    if !isdirectory(target_path)
      call system('mkdir -p ' . target_path)
    endif

    let &undodir = target_path
    set undofile
  endif

  " it is not 'safe' to set these
  " while resourcing $MYVIMRC in read-only files (netrw for example)
  if &modifiable
    set fileencoding=utf-8       " utf-8 files
    set fileformat=unix          " use unix line endings
    set fileformats=unix,dos     " try unix line endings before dos, use unix
  endif

  colorscheme base16-seti          " apply color scheme
  set lazyredraw                   " less redrawing during macro execution etc
  set path+=**                     " add cwd and 1 level of nesting to path
  set hidden                       " switching from unsaved buffer without '!'
  set ignorecase                   " ignore case in search
  set incsearch                    " incremental search highlighting
  set smartcase                    " case-sensitive only with capital letters
  set noshowmode                   " no need due to custom statusline
  set noruler                      " do not show ruler
  set list lcs=tab:‣\ ,trail:•     " customize invisibles
  set cursorline                   " highlight cursor line
  set splitbelow                   " split below instead of above
  set splitright                   " split after instead of before
  set background=dark              " set bg dark
  set nobackup                     " do not keep backups
  set noswapfile                   " no more swapfiles
  set clipboard+=unnamedplus       " copy into osx clipboard by default
  set encoding=utf-8               " utf-8 files
  set expandtab                    " softtabs, always (convert tabs to spaces)
  set tabstop=2                    " tabsize 2 spaces (by default)
  set shiftwidth=0                 " use 'tabstop' value for 'shiftwidth'
  set softtabstop=2                " tabsize 2 spaces (by default)
  set laststatus=2                 " always show statusline
  set showtabline=0                " never show tab bar
  set backspace=2                  " restore backspace
  set nowrap                       " do not wrap text at `textwidth`
  set belloff=all                  " do not show error bells
  set synmaxcol=1000               " do not highlight long lines
  set timeoutlen=250               " keycode delay
  set wildignore+=.git,.DS_Store,node_modules
  set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50

  if has('nvim')
    set termguicolors                " enable termguicolors for better highlighting
    set fillchars+=msgsep:\ ,vert:\│ " customize message separator in neovim
  endif

  " remap bad habits to do nothing
  imap <Up>    <Nop>
  imap <Down>  <Nop>
  imap <Left>  <Nop>
  imap <Right> <Nop>
  nmap <Up>    <Nop>
  nmap <Down>  <Nop>
  nmap <Left>  <Nop>
  nmap <Right> <Nop>
  nmap <S-s>   <Nop>
  nmap >>      <Nop>
  nmap <<      <Nop>
  vmap >>      <Nop>
  vmap <<      <Nop>
  map  $       <Nop>
  map  ^       <Nop>
  map  {       <Nop>
  map  }       <Nop>
  map <C-z>    <Nop>

  " Sometimes I press q:, Q: or :Q instead of :q,
  " I never want to open related functionality
  nmap q: :q<Cr>
  nmap Q: :q<Cr>
  command! -bang -nargs=* Q q

  " shortcut for next/prev item in quickfix list, but also wraps
  " around back to the first/last item.
  function! <SID>QuickfixNextWrapped()
    try | cnext | catch | crewind | endtry
  endfunction

  function! <SID>QuickfixPreviousWrapped()
    try | cprev | catch | clast | endtry
  endfunction

  " ctrl+p is already used by FZF's :Files
  " so use ctrl+n for next and ctrl+m for previous qf entry
  nnoremap <silent> <C-m> :call <SID>QuickfixPreviousWrapped()<Cr>
  nnoremap <silent> <C-n> :call <SID>QuickfixNextWrapped()<Cr>

  " easier navigation in normal / visual / operator pending mode
  noremap K     {
  noremap J     }
  noremap H     ^
  noremap L     $

  " save using <C-s> in every mode
  " when in operator-pending or insert, takes you to normal mode
  nnoremap <C-s> :write<Cr>
  vnoremap <C-s> <C-c>:write<Cr>
  inoremap <C-s> <Esc>:write<Cr>
  onoremap <C-s> <Esc>:write<Cr>

  " close pane using <C-w> since I know it from Chrome / Atom (cmd+w) and do
  " not use the <C-w> mappings anyway
  function! <SID>CloseBuffer()
    if len(getwininfo()) >? 1
      close
    elseif len(getbufinfo()) >? 1
      bdelete
    endif
  endfunction
  nnoremap <silent> <C-w> :call <SID>CloseBuffer()<Cr>

  " easier one-off navigation in insert mode
  inoremap <C-k> <Up>
  inoremap <C-j> <Down>
  inoremap <C-h> <Left>
  inoremap <C-l> <Right>

  " make Y consistent with C and D
  nnoremap Y y$

  " use qq to record, q to stop, Q to play a macro
  nnoremap Q @q
  vnoremap Q :normal @q

  " when pairing some braces or quotes, put cursor between them
  inoremap <>   <><Left>
  inoremap ()   ()<Left>
  inoremap {}   {}<Left>
  inoremap []   []<Left>
  inoremap ""   ""<Left>
  inoremap ''   ''<Left>
  inoremap ``   ``<Left>

  " use tab and shift tab to indent and de-indent code
  nnoremap <Tab>   >>
  nnoremap <S-Tab> <<
  vnoremap <Tab>   >><Esc>gv
  vnoremap <S-Tab> <<<Esc>gv
  inoremap <S-Tab> <C-d>

  " use `u` to undo, use `U` to redo, mind = blown
  nnoremap U <C-r>

  " maybe there is value to these? :thinking_face:
  " nnoremap <S-r> <Nop>
  " inoremap <Ins> <Nop>

  " transparent terminal background
  " never move above `colorscheme` option
  highlight Normal guibg=NONE ctermbg=NONE

  " highlight trailing whitespace
  highlight TrailingWhitespace ctermfg=0 guifg=Black ctermbg=8 guibg=#41535B

  " hide ghost tilde characters after end of file
  highlight EndOfBuffer guibg=NONE ctermbg=NONE guifg=Black ctermfg=0

  if hlexists('VertSplit')
    hi VertSplit guibg=NONE ctermbg=NONE guifg=Gray ctermfg=Gray
  endif

  " consistent CursorLine in both vim and neovim
  hi CursorLine ctermbg=8 guibg=#282a2b

  " convenience function for setting filetype specific spacing
  function! <SID>IndentSize(amount)
    exe "setlocal expandtab"
          \ . " ts="  . a:amount
          \ . " sts=" . a:amount
  endfunction

  " use ripgrep as grepprg
  if executable('rg')
    set grepprg=rg\ --vimgrep\ --hidden\ --no-ignore-vcs
    set grepformat=%f:%l:%c:%m,%f:%l:%m
  endif
" }}}

" Development {{{{
  if !exists('*VimrcDevRefresh')
    " this function must never be redefined because
    " it reloads the file it is defined in,
    " will cause an error otherwise.
    function! VimrcDevRefresh()
      if $VIM_DEV
        if (&ft == 'markdown')
          so ~/Dev/sidofc/viml/mkdx/after/syntax/markdown.vim
          so ~/Dev/sidofc/viml/mkdx/autoload/mkdx.vim
        endif

        mess clear
      else
        so $MYVIMRC
      endif
    endfunction
  endif

  nmap <silent> <Leader>R :call VimrcDevRefresh()<Cr>
  nmap <silent> <space>gp :echo map(
      \ synstack(line('.'), col('.')),
      \ 'synIDattr(v:val, "name")'
      \ )<Cr>
" }}}

" rust.vim settings {{{
  let g:rustfmt_autosave = 1
" }}}

" vim-javascript settings {{{
  let g:javascript_plugin_flow = 1
" }}}

" Highlighted yank {{{
  let g:highlightedyank_highlight_duration = 150
" }}}

" {{{
  vnoremap a<Bar> :<C-U>normal! T<Bar>vt<Bar><Cr>
  vnoremap i<Bar> :<C-U>normal! F<Bar>vf<Bar><Cr>
  omap i<Bar> :normal vi<Bar><Cr>
  omap a<Bar> :normal va<Bar><Cr>
" }}}

" Mkdx {{{
  let g:mkdx#settings = {
        \ 'restore_visual': 1,
        \ 'gf_on_steroids': 1,
        \ 'highlight': { 'enable':   1 },
        \ 'enter':     { 'shift':    1 },
        \ 'links':     { 'external': { 'enable': 1 } },
        \ 'fold':      { 'enable':   1 },
        \ 'toc': {
        \    'text': 'Table of Contents',
        \    'update_on_write': 1,
        \    'details': { 'nesting_level': 0 }
        \ }
        \ }
" }}}

" Ale {{{
  let g:ale_set_highlights        = 0
  let g:ale_echo_msg_format       = '[%linter%] %severity%: %s'
  let g:ale_lint_delay            = 300
  let g:ale_fix_on_save           = 1
  let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')
  let g:ale_fixers                = {
        \ 'javascript': ['prettier'],
        \ 'javascriptreact': ['prettier'],
        \ 'typescript': ['prettier'],
        \ 'typescriptreact': ['prettier'],
        \ 'json': ['prettier']
        \ }
  let g:ale_linters = {
        \ 'ruby': ['rubocop'],
        \ 'javascript': ['eslint'],
        \ 'javascriptreact': ['eslint'],
        \ 'typescript': ['eslint'],
        \ 'typescriptreact': ['eslint'],
        \ 'rust': ['cargo'],
        \ 'fish': [],
        \ 'sass': [],
        \ 'scss': []
        \ }
  let g:ale_linters_explicit = 1
" }}}

" Fzf {{{
  let g:fzf_preview_window = ''
  let g:fzf_layout         = { 'down': '~20%' }
  let g:fzf_colors         = {
        \ 'fg':      ['fg', 'Normal'],
        \ 'bg':      ['bg', 'Clear'],
        \ 'hl':      ['fg', 'String'],
        \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
        \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
        \ 'hl+':     ['fg', 'Statement'],
        \ 'info':    ['fg', 'PreProc'],
        \ 'prompt':  ['fg', 'Conditional'],
        \ 'pointer': ['fg', 'Exception'],
        \ 'marker':  ['fg', 'Keyword'],
        \ 'spinner': ['fg', 'Label'],
        \ 'header':  ['fg', 'Comment']
        \ }

  function! <SID>MkdxGoToHeader(header)
    call cursor(str2nr(get(matchlist(a:header, ' *\([0-9]\+\)'), 1, '')), 1)
  endfunction

  function! <SID>MkdxFormatHeader(key, val)
    let text = get(a:val, 'text', '')
    let lnum = get(a:val, 'lnum', '')

    if (empty(text) || empty(lnum)) | return text | endif
    return repeat(' ', 4 - strlen(lnum)) . lnum . ': ' . text
  endfunction

  function! <SID>MkdxFzfQuickfixHeaders()
    let headers = filter(
          \ map(mkdx#QuickfixHeaders(0),function('<SID>MkdxFormatHeader')),
          \ 'v:val != ""'
          \ )

    call fzf#run(fzf#wrap({
          \ 'source': headers,
          \ 'sink': function('<SID>MkdxGoToHeader')
          \ }))
  endfunction

  if (!$VIM_DEV)
    " when not developing mkdx, use fancier <leader>I which uses fzf
    " instead of qf to jump to headers in markdown documents.
    nnoremap <silent> <Leader>I :call <SID>MkdxFzfQuickfixHeaders()<Cr>
  endif

  " do not use fzf built-in Rg command since it also searches within filenames.
  command! -bang -nargs=* Rg
        \ call fzf#vim#grep(
          \ 'rg --column --line-number --hidden --smart-case '
            \ . '--no-heading --color=always '
            \ . shellescape(<q-args>),
          \ 1,
          \ {'options':  '--delimiter : --nth 4..'},
          \ 0)

  function! s:files_handler(lines)
    echom a:lines
  endfunction

  command! -bang -nargs=* Files
        \ call fzf#vim#grep(
          \ "rg --files --hidden --smart-case --color=always . | sed 's/$/:1:1/'",
          \ 0,
          \ {},
          \ 0)

  nnoremap <silent> <C-f> :BLines<Cr>
  nnoremap <silent> <C-p> :Files<Cr>
  nnoremap <silent> <C-g> :Rg<Cr>
" }}}

" Vimagit {{{
  noremap  <Leader>m :MagitO<Cr>
" }}}

" Easyalign {{{
  " allow 'gr' mapping to work with ? and > delimiters
  let g:easy_align_delimiters = {
        \ '?': {'pattern': '?'},
        \ '>': {'pattern': '>>\|=>\|>'}
        \ }

  xmap gr <Plug>(EasyAlign)
  nmap gr <Plug>(EasyAlign)
" }}}

" {{{ Status line
  let g:mode_colors = {
        \ 'n':  'StatusLineSection',
        \ 'v':  'StatusLineSectionV',
        \ '': 'StatusLineSectionV',
        \ 'i':  'StatusLineSectionI',
        \ 'c':  'StatusLineSectionC',
        \ 'r':  'StatusLineSectionR'
        \ }

  function! StatusLineRenderer()
    let hl = '%#' . get(g:mode_colors, tolower(mode()), g:mode_colors.n) . '#'
    let fn = fnamemodify(expand("%"), ":~:.")

    if (fn =~ '^\~')
      let fn = fnamemodify(fn, ':t')
    endif

    return hl
          \ . (&modified ? ' + │' : '')
          \ . ' ' . fn . ' %#StatusLine#%='
          \ . hl
          \ . ' %l:%c '
  endfunction

  function! <SID>StatusLineHighlights()
    hi StatusLine         ctermbg=8  guibg=#313131 ctermfg=15 guifg=#cccccc
    hi StatusLineNC       ctermbg=0  guibg=#313131 ctermfg=8  guifg=#999999
    hi StatusLineSection  ctermbg=8  guibg=#55b5db ctermfg=0  guifg=#333333
    hi StatusLineSectionV ctermbg=11 guibg=#a074c4 ctermfg=0  guifg=#000000
    hi StatusLineSectionI ctermbg=10 guibg=#9fca56 ctermfg=0  guifg=#000000
    hi StatusLineSectionC ctermbg=12 guibg=#db7b55 ctermfg=0  guifg=#000000
    hi StatusLineSectionR ctermbg=12 guibg=#ed3f45 ctermfg=0  guifg=#000000
  endfunction

  call <SID>StatusLineHighlights()

  " only set default status line once on initial startup.
  " ignored on subsequent 'so $MYVIMRC' calls to prevent
  " active buffer statusline from being 'blurred'.
  if has('vim_starting')
    let &statusline = ' %{fnamemodify(expand("%"), ":~:.")}%= %l:%c '
  endif
" }}}

" Autocommands {{{
  augroup VimrcAutoCmds
    au!

    " auto resize splits on resize
    au VimResized * wincmd =

    match TrailingWhitespace /\s\+$/
    autocmd BufWinEnter * match TrailingWhitespace /\s\+$/
    autocmd InsertEnter * match TrailingWhitespace /\s\+\%#\@<!$/
    autocmd InsertLeave * match TrailingWhitespace /\s\+$/
    autocmd BufWinLeave * call clearmatches()

    " used in conjunction with incsearch setting
    autocmd CmdlineEnter /,\? :set hlsearch
    autocmd CmdlineLeave /,\? :set nohlsearch

    " auto reload file changes outside of vim, toggle custom status bar,
    " and toggle cursorline for active buffer.
    au FocusGained,VimEnter,WinEnter,BufWinEnter *
          \ setlocal cursorline& statusline& |
          \ setlocal cursorline  statusline=%!StatusLineRenderer() |
          \ checktime

    " restore above settings when leaving buffer / vim
    au FocusLost,VimLeave,WinLeave,BufWinLeave *
          \ setlocal statusline& cursorline&

    " experimental, always have proper syntax highlighting, but may be slow
    autocmd BufEnter * :syntax sync fromstart
    autocmd BufEnter *.sss :setf stylus

    " set indent for various languages
    au FileType markdown,python,json,javascript call <SID>IndentSize(4)
    au FileType javascriptreact,jsx,typescript,html,css call <SID>IndentSize(4)

    " hide status and ruler for cleaner fzf windows
    if has('nvim')
      au FileType fzf
            \ set laststatus& laststatus=0 |
            \ au BufLeave <buffer> set laststatus&
    endif

    " restore statusline highlights on colorscheme update
    au Colorscheme * call <SID>StatusLineHighlights()
  augroup END
" }}}

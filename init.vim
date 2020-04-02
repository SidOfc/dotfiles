" Some things to remember {{{
"   - In Visual-Block mode, pressing 'o' will move to the opposite end
" }}}

" Init / Plugins {{{
  let $VIM_OSX = system('uname -a | grep -i darwin') != ''
  set nocompatible

  call plug#begin('~/.vim/plugged')
  Plug 'benmills/vimux'
  Plug 'chriskempson/base16-vim'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'haya14busa/incsearch.vim'
  Plug 'jreybert/vimagit'
  Plug 'junegunn/vim-easy-align'
  Plug 'machakann/vim-highlightedyank'
  Plug 'pangloss/vim-javascript'
  Plug 'rust-lang/rust.vim'
  Plug 'sheerun/vim-polyglot'
  Plug 'styled-components/vim-styled-components', {'branch': 'main'}
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-endwise'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'
  Plug 'w0rp/ale'

  if $VIM_OSX
    Plug '/usr/local/opt/fzf'
  else
    Plug '~/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  endif

  Plug 'junegunn/fzf.vim'

  if $VIM_DEV
    Plug 'junegunn/vader.vim'
    if !$DISABLE_MKDX
      Plug '~/Dev/mkdx'
    endif
  else
    Plug 'SidOfc/mkdx'
  endif

  call plug#end()
" }}}

" General {{{
  let mapleader = ' '

  if has('nvim')
    set inccommand=nosplit " substitute with preview
  endif

  " can't believe I didn't do this before
  if has('persistent_undo')
    let target_path = expand('~/.config/vim-persisted-undo/')

    if !isdirectory(target_path)
      call system('mkdir -p ' . target_path)
    endif

    let &undodir = target_path
    set undofile
  endif

  set lazyredraw                  " maybe make drawing faster?
  set path+=**                    " add cwd and 1 level of nesting to path
  set hidden                      " allow switching from unsaved buffer without '!'
  set ignorecase                  " ignore case in search
  set nohlsearch                  " do not highlight searches, incsearch plugin does this
  set smartcase                   " use case-sensitive if a capital letter is included
  set noshowmode                  " statusline makes -- INSERT -- info irrelevant
  set cursorline                  " highlight cursor line
  set splitbelow                  " split below instead of above
  set splitright                  " split after instead of before
  set termguicolors               " enable termguicolors for better highlighting
  set list                        " show invisibles
  set lcs=tab:·\                  " show tab as that thing
  set background=dark             " set bg dark
  set nobackup                    " do not keep backups
  set noswapfile                  " no more swapfiles
  set clipboard+=unnamedplus      " copy into osx clipboard by default
  set encoding=utf-8              " utf-8 files
  set fileencoding=utf-8          " utf-8 files
  set fileformat=unix             " use unix line endings
  set fileformats=unix,dos        " try unix line endings before dos, use unix
  set expandtab                   " softtabs, always (e.g. convert tabs to spaces)
  set shiftwidth=2                " tabsize 2 spaces (by default)
  set softtabstop=2               " tabsize 2 spaces (by default)
  set tabstop=2                   " tabsize 2 spaces (by default)
  set laststatus=2                " always show statusline
  set showtabline=0               " never show tab bar
  set backspace=2                 " restore backspace
  set nowrap                      " do not wrap text at `textwidth`
  set noerrorbells                " do not show error bells
  set visualbell                  " do not use visual bell
  set t_vb=                       " do not flash screen with visualbell
  set timeoutlen=350              " mapping delay
  set ttimeoutlen=10              " keycode delay
  set wildignore+=.git,.DS_Store  " ignore files (netrw)
  colorscheme base16-seti         " apply color scheme
  set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50

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

  " Sometimes I press q:, Q: or :Q instead of :q, I never want to open related functionality
  map <silent> q: :q<Cr>
  map <silent> Q: :q<Cr>
  map <silent> :Q :q<Cr>

  " I like things that wrap back to start after end, quickfix stops at last
  " error but if I specify cn again, I want to definitely go to the next error
  " (I can see line numbers in sidebar to track where I am anyway)
  fun! s:__qfnxt()
    try
      cnext
    catch
      crewind
    endtry
  endfun

  fun! s:__qfprv()
    try
      cprev
    catch
      clast
    endtry
  endfun

  " shortcuts for quickfix list
  nnoremap <silent> <C-n> :call <SID>__qfnxt()<Cr>
  " this one is replaced by s:CtrlPMapping which can be found
  " in FZF configuration section
  nnoremap <silent> <C-M-n> :call <SID>__qfprv()<Cr>

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

  fun! s:__bclose()
    if (len(getbufinfo({'buflisted': 1})) > 1)
      bdelete
    endif
  endfun

  " close pane using <C-w> since I know it from Chrome / Atom (cmd+w) and do
  " not use the <C-w> mappings anyway
  noremap <silent> <C-w> :call <SID>__bclose()<Cr>

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

  " I always escape from this mode anyway, best never to enter it
  nnoremap <S-r> <Nop>

  if has('nvim')
    fun! s:GitJobHandler(job_id, data, event) dict
      echo 'git push finished'
    endfun

    fun! s:GitPushAsync()
      call system('ssh-add -l')
      if (v:shell_error == 0)
        call jobstart('git push', { 'on_exit': function('<SID>GitJobHandler') })
        echo 'git push'
      else
        exe '!ssh-add'
      end
    endfun

    nnoremap <silent> <Leader>P :call <SID>GitPushAsync()<Cr>
  endif

  " fix jsx highlighting of end xml tags
  hi link xmlEndTag xmlTag

  " override markdown quote syntax highlight
  hi link mkdBlockquote rubyInterpolationDelimiter

  " transparent terminal background
  " never move above `colorscheme` option
  hi Normal guibg=NONE ctermbg=NONE

  " delete existing notes in ~/notes
  if !exists('*s:DeleteNote')
    function! s:DeleteNote(paths)
      call delete(a:paths)
    endfunction
  endif

  " create a new note in ~/notes
  if !exists('*s:NewNote')
    function! s:NewNote()
      call inputsave()
      let l:fname = input('Note name: ')
      call inputrestore()

      if strlen(l:fname) > 0
        let l:fpath = expand('~/notes/' . fnameescape(substitute(tolower(l:fname), ' ', '-', 'g')))
        exe "tabe " . l:fpath . ".md"
      endif
    endfunction
  endif

  " convenience function for setting filetype specific spacing
  if !exists('*s:IndentSize')
    function! s:IndentSize(amount)
      exe "setlocal expandtab ts=" . a:amount . " sts=" . a:amount . " sw=" . a:amount
    endfunction
  endif

  if !exists('*s:StripWS')
    fun! s:StripWS()
      if (&ft =~ 'vader' || &ft =~ 'markdown' || &ft == '' || &ft == 'help') | return | endif
      %s/\s\+$//e
    endfun
  endif

  " use ripgrep as grepprg
  if executable('rg')
    set grepprg=rg\ --vimgrep\ --hidden\ --no-ignore-vcs
    set grepformat=%f:%l:%c:%m,%f:%l:%m
  endif
" }}}

" Development {{{{
  function! <SID>SynStack()
    if !exists("*synstack")
      return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
  endfunc

  nmap <silent> <leader>gp :call <SID>SynStack()<Cr>

  if $VIM_DEV
    function! <SID>DevRefresh()
      if (&ft == 'markdown')
        if $VIM_OSX
          so ~/Dev/sidney/viml/mkdx/after/syntax/markdown/mkdx.vim
          so ~/Dev/sidney/viml/mkdx/autoload/mkdx.vim
        else
          so ~/Dev/mkdx/after/syntax/markdown/mkdx.vim
          so ~/Dev/mkdx/autoload/mkdx.vim
        endif
      endif

      mess clear
    endfunction

    nmap <silent> <Leader>R :call <SID>DevRefresh()<Cr>
  endif
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

" Netrw {{{
  let g:netrw_banner    = 0
  let g:netrw_winsize   = 20
  let g:netrw_liststyle = 3
  let g:netrw_altv      = 1
  let g:netrw_cursor    = 1
" }}}

" Mkdx {{{
  let g:mkdx#settings     = { 'highlight': { 'enable': 1 },
                            \ 'restore_visual': 1,
                            \ 'enter': { 'shift': 1 },
                            \ 'links': { 'external': { 'enable': 1 } },
                            \ 'toc': { 'text': 'Table of Contents', 'update_on_write': 1,
                            \          'details': { 'nesting_level': 0 } },
                            \ 'fold': { 'enable': 1 } }
  let g:polyglot_disabled = ['markdown']
" }}}

" Ale {{{
  let g:ale_set_highlights        = 0                              " only show errors in sign column
  let g:ale_echo_msg_error_str    = 'E'                            " error sign
  let g:ale_echo_msg_warning_str  = 'W'                            " warning sign
  let g:ale_echo_msg_format       = '[%linter%] %s [%severity%]'   " status line format
  let g:ale_statusline_format     = ['⨉ %d', '⚠ %d', '⬥ ok']       " error status format
  let g:ale_lint_delay            = 500                            " relint max once per [amount] milliseconds
  let g:ale_fix_on_save           = 1
  let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')
  let g:ale_fixers                = {
        \ 'javascript': ['prettier'],
        \ 'javascriptreact': ['prettier'],
        \ 'jsx': ['prettier'],
        \ 'json': ['prettier']
        \ } " fix JS using prettier
  let g:ale_linters               = {
        \ 'ruby': ['rubocop'],
        \ 'javascript': ['eslint', 'flow'],
        \ 'fish': []
        \ }
" }}}

" Incsearch {{{
  let g:incsearch#auto_nohlsearch                   = 1 " auto unhighlight after searching
  let g:incsearch#do_not_save_error_message_history = 1 " do not store incsearch errors in history
  let g:incsearch#consistent_n_direction            = 1 " when searching backward, do not invert meaning of n and N

  map / <Plug>(incsearch-forward)
  map ? <Plug>(incsearch-backward)
" }}}

" {{{ Status bar
let g:mode_colors = {
      \ 'n': 'StatusBarSection',
      \ 'v': 'StatusBarSectionV',
      \ '': 'StatusBarSectionV',
      \ 'i': 'StatusBarSectionI',
      \ 'c': 'StatusBarSectionC',
      \ 'r': 'StatusBarSectionR'
      \ }

fun! s:StatusBarHighlights()
  highlight default StatusBar         ctermbg=8  guibg=#313131 ctermfg=15 guifg=#cccccc
  highlight default StatusBarSection  ctermbg=8  guibg=#55b5db ctermfg=0  guifg=#333333
  highlight default StatusBarSectionV ctermbg=11 guibg=#a074c4 ctermfg=0  guifg=#000000
  highlight default StatusBarSectionI ctermbg=10 guibg=#9fca56 ctermfg=0  guifg=#000000
  highlight default StatusBarSectionC ctermbg=12 guibg=#db7b55 ctermfg=0  guifg=#000000
  highlight default StatusBarSectionR ctermbg=12 guibg=#ed3f45 ctermfg=0  guifg=#000000
endfun

call s:StatusBarHighlights()

fun! StatusBarFileName()
  let file_path = substitute(expand('%'), '^netrwtreelisting\|^' . getcwd() . '/\?', '', 'i')

  return (empty(file_path) || file_path =~# ';#FZF') ? '*' : file_path
endfun

fun! DefaultStatusBar()
  return '%#StatusBar# %{StatusBarFileName()}%= %l:%c '
endfun

fun! ActiveStatusBar()
  let section_hl = get(g:mode_colors, tolower(mode()), g:mode_colors.n)

  return '%#' . section_hl . '#'
        \ . (&modified ? ' + │' : '')
        \ . ' %{StatusBarFileName()}'
        \ . ' %#StatusBar#'
        \ . '%='
        \ . '%#' . section_hl . '#'
        \ . ' %l:%c '
endfun

augroup StatusBarHighlightCmds
  au!
  au VimEnter,WinEnter,BufWinEnter *
    \ setlocal statusline& |
    \ let statusline=&statusline |
    \ setlocal statusline=%!ActiveStatusBar()

  au VimLeave,WinLeave,BufWinLeave * setlocal statusline&
  au Colorscheme * call <SID>StatusBarHighlights()
augroup END

set statusline=%!DefaultStatusBar()
" }}}

" Vimux {{{
  let g:VimuxPromptString = '% '         " change default vim prompt string
  let g:VimuxResetSequence = 'q C-u C-l' " clear output before running a command

  noremap <Leader>rr :VimuxPromptCommand<Cr>
  noremap <C-x>      :VimuxRunLastCommand<Cr>
  noremap <Leader>re :VimuxCloseRunner<Cr>
" }}}

" Fzf {{{
  " use bottom positioned 20% height bottom split
  let g:fzf_layout = { 'down': '~20%' }
  let g:fzf_colors =
  \ { 'fg':      ['fg', 'Normal'],
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
    \ 'header':  ['fg', 'Comment'] }

  " simple notes bindings using fzf wrapper
  nnoremap <silent> <Leader>n :call fzf#run(fzf#wrap({'source': 'rg --files ~/notes', 'options': '--header="[notes:search]" --preview="cat {}"'}))<Cr>
  nnoremap <silent> <Leader>N :call <SID>NewNote()<Cr>
  nnoremap <silent> <Leader>nd :call fzf#run(fzf#wrap({'source': 'rg --files ~/notes', 'options': '--header="[notes:delete]" --preview="cat {}"', 'sink': function('<SID>DeleteNote')}))<Cr>

  fun! s:MkdxGoToHeader(header)
    call cursor(str2nr(get(matchlist(a:header, ' *\([0-9]\+\)'), 1, '')), 1)
  endfun

  fun! s:MkdxFormatHeader(key, val)
    let text = get(a:val, 'text', '')
    let lnum = get(a:val, 'lnum', '')
    if (empty(text) || empty(lnum)) | return text | endif

    return repeat(' ', 4 - strlen(lnum)) . lnum . ': ' . text
  endfun

  fun! s:MkdxFzfQuickfixHeaders()
    let headers = filter(map(mkdx#QuickfixHeaders(0), function('<SID>MkdxFormatHeader')), 'v:val != ""')
    call fzf#run(fzf#wrap(
            \ {'source': headers, 'sink': function('<SID>MkdxGoToHeader') }
          \ ))
  endfun

  if (!$VIM_DEV)
    nnoremap <silent> <Leader>I :call <SID>MkdxFzfQuickfixHeaders()<Cr>
  endif

  " keeping Rg command since the built-in one does not skip checking filenames
  " for an in-file search...
  command! -bang -nargs=* Rg
   \ call fzf#vim#grep(
   \   'rg --column --line-number --hidden --ignore-case --no-heading --color=always '.shellescape(<q-args>), 1,
   \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
   \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '§'),
   \   <bang>0)

  " only use FZF shortcuts in non diff-mode
  if !&diff
    nnoremap <silent> <C-p> :Files<Cr>
    nnoremap <C-g> :Rg<Cr>
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

  xmap gr <Plug>(EasyAlign)
  nmap gr <Plug>(EasyAlign)
" }}}

" Autocommands {{{
  augroup Windows
    au!
    au FocusGained,VimEnter,WinEnter,BufWinEnter * setlocal cursorline " enable cursorline in focussed buffer
    au FocusGained,VimEnter,WinEnter,BufWinEnter * :checktime          " reload file if it has changed on disk
    au WinLeave,FocusLost * setlocal nocursorline                      " disable cursorline when leaving buffer
    au VimResized * wincmd =                                           " auto resize splits on resize
  augroup END

  augroup Files
    au!
    au BufWritePre *                            call s:StripWS()     " remove trailing whitespace before saving buffer
    au FileType markdown,python,json,javascript call s:IndentSize(4)
    au FileType javascriptreact,jsx             call s:IndentSize(4)
    au FileType help                            nmap <buffer> q :q<Cr>
  augroup END
" }}}

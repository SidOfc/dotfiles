## SETTINGS
set fish_greeting
set -U  fish_user_paths            /usr/local/opt/openssl/bin ~/bin $HOME/.asdf/shims
set -gx FZF_DEFAULT_OPTS           '--height=50% --min-height=15 --reverse'
set -gx FZF_DEFAULT_COMMAND        'rg --files --no-ignore-vcs --hidden'
set -gx FZF_CTRL_T_COMMAND         $FZF_DEFAULT_COMMAND
set -gx EVENT_NOKQUEUE             1
set -gx EDITOR                     nvim
set -gx HOMEBREW_FORCE_VENDOR_RUBY 1
set -gx GPG_TTY                    (tty)
set -gx ASDF_DIR                   /usr/local/opt/asdf
## ABBREVIATIONS
# gpg-agent
abbr gpg-add "echo | gpg -s >/dev/null ^&1"

# config files
abbr vv  "$EDITOR ~/.config/nvim/init.vim"
abbr tt  "$EDITOR ~/.tmux.conf"
abbr zz  "$EDITOR ~/.config/fish/config.fish"
abbr ff  "$EDITOR ~/.config/fish/config.fish"
abbr ks  "kp --tcp"

# python
abbr py  'python'

# crystal
abbr cr  'crystal'

# git
abbr g   'git'
abbr ga  'git add'
abbr g.  'git add .'
abbr gc  'git commit -m'
abbr gco 'git checkout'
abbr gd  'git diff'
abbr gf  'git fetch'
abbr gl  'git log'
abbr gmt 'git mergetool'
abbr gdt 'git difftool'
abbr gp  'git push'
abbr gpl 'git pull'
abbr gg  'git status'
abbr gs  'git stash'
abbr gsp 'git stash pop'

# vim
abbr v   "$EDITOR ."
abbr vd  "set -x VIM_DEV 1; and $EDITOR .; and set -e VIM_DEV"
abbr vip "$EDITOR +PlugInstall +qall"
abbr vup "$EDITOR +PlugUpdate"
abbr vcp "$EDITOR +PlugClean +qall"

## FUNCTIONS
function reload --description "Reload fish shell"
  source ~/.config/fish/config.fish
end

function fp --description 'Search your $PATH'
  set -l loc (echo $PATH | tr ' ' '\n' | eval "fzf $FZF_DEFAULT_OPTS --header='[find:path]'")

  if test (count $loc) = 1
    set -l cmd (rg --files -L $loc | rev | cut -d'/' -f1 | rev | tr ' ' '\n' | eval "fzf $FZF_DEFAULT_OPTS --header='[find:exe] => $loc'")
    if test (count $cmd) = 1
      echo $cmd
    else
      fp
    end
  end
end

function kp --description "Kill processes"
  set -l __kp__pid ''

  if contains -- '--tcp' $argv
    set __kp__pid (lsof -Pwni tcp | sed 1d | eval "fzf $FZF_DEFAULT_OPTS -m --header='[kill:tcp]'" | awk '{print $2}')
  else
    set __kp__pid (ps -ef | sed 1d | eval "fzf $FZF_DEFAULT_OPTS -m --header='[kill:process]'" | awk '{print $2}')
  end

  if test "x$__kp__pid" != "x"
    if test "x$argv[1]" != "x"
      echo $__kp__pid | xargs kill $argv[1]
    else
      echo $__kp__pid | xargs kill -9
    end
    kp
  end
end

function bip --description "Install brew plugins"
  set -l inst (brew search | eval "fzf $FZF_DEFAULT_OPTS -m --header='[brew:install]'")

  if not test (count $inst) = 0
    for prog in $inst
      brew install "$prog"
    end
  end
end
function bcp --description "Remove brew plugins"
  set -l inst (brew leaves | eval "fzf $FZF_DEFAULT_OPTS -m --header='[brew:uninstall]'")

  if not test (count $inst) = 0
    for prog in $inst
      brew uninstall "$prog"
    end
  end
end

function pbclear --description "Provide functionality to clear from the pasteboard (the Clipboard) from command line"
  if test (which pbcopy)
    echo '' | pbcopy
  end
end

function fish_prompt --description 'Write out the prompt'
  set -l __stat $status

  switch $__stat
    case 0   ; set __stat_color 'green'
    case 127 ; set __stat_color 'yellow'
    case '*' ; set __stat_color 'red'
  end

  if test (git rev-parse --git-dir 2>/dev/null)
    set __gst (git status -s)
    set __gbr (git status | head -1 | string split ' ')[-1]

    if test -n "$__gst"
      set __git_dirty (set_color magenta) '⚑'
    else
      set __git_dirty (set_color green) '⚑'
    end

    set __git_cb (set_color yellow)" on "(set_color green)"$__gbr"(set_color normal)"$__git_dirty"
  end

  echo -n (set_color $__stat_color)'•'(set_color blue) (prompt_pwd)"$__git_cb"(set_color yellow) '❯ '
end

function fish_mode_prompt --description 'Displays the current mode'
  if test $__fish_active_key_bindings = 'fish_vi_key_bindings'
    switch $fish_bind_mode
      case default
        set_color --background red white
        echo ' '
      case insert
        set_color --background green white
        echo ' '
      case visual
        set_color --background blue white
        echo ' '
    end

    set_color normal
    echo -n ' '
  end
end

## SOURCES
[ -f /usr/local/share/autojump/autojump.fish ]; and source /usr/local/share/autojump/autojump.fish
[ -f /usr/local/opt/asdf/asdf/asdf.fish ]; and source /usr/local/opt/asdf/asdf.fish

## GPG
gpg-agent --daemon --no-grab >/dev/null ^&1

## TMUX
if status --is-interactive
and command -s tmux >/dev/null
and not set -q TMUX
  exec tmux new -A -s (whoami)
end

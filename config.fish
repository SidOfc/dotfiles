# Settings {{{
  set fish_greeting
  set -U  fish_user_paths            /usr/local/opt/openssl/bin $HOME/bin $HOME/.asdf/asdf.fish $HOME/.fzf/bin
  set -gx FZF_DEFAULT_OPTS           '--height=50% --min-height=15 --reverse'
  set -gx FZF_DEFAULT_COMMAND        'rg --files --no-ignore-vcs --hidden'
  set -gx FZF_CTRL_T_COMMAND         $FZF_DEFAULT_COMMAND
  set -gx EVENT_NOKQUEUE             1
  set -gx SHELL                      (which fish || $SHELL || 'bash')
  set -gx EDITOR                     nvim
  set -gx HOMEBREW_FORCE_VENDOR_RUBY 1
  set -gx GPG_TTY                    (tty)
# }}}

# Aliases {{{
  # don't send terminal type 'alacritty' through ssh
  alias ssh "env TERM=xterm-256color ssh"
  alias rails "env TERM=xterm-256color rails"
# }}}

# Abbreviations {{{
  # gpg-agent
  abbr gpg-add "echo | gpg -s >/dev/null ^&1"

  # config files
  abbr aa  "$EDITOR ~/.config/alacritty/alacritty.yml"
  abbr vv  "$EDITOR ~/.config/nvim/init.vim"
  abbr tt  "$EDITOR ~/.tmux.conf"
  abbr zz  "$EDITOR ~/.config/fish/config.fish"
  abbr ff  "$EDITOR ~/.config/fish/config.fish"
  abbr zx  ". ~/.config/fish/config.fish"
  abbr ks  "kp --tcp"

  # git
  abbr g.  'git add .'
  abbr gc  'git commit -m'
  abbr gco 'git checkout'
  abbr ggo 'git checkout (git branch | grep -v "^*" | sed -E "s/^ +//" | fzf)'
  abbr gd  'git diff'
  abbr gl  'git log'
  abbr gp  'git push'
  abbr gpl 'git pull'
  abbr gg  'git status'
  abbr gs  'git stash'
  abbr gsp 'git stash pop'

  # xclip stuff
  if type "xclip" >/dev/null 2>&1
    abbr pbcopy  'xclip -i -selection clipboard'
    abbr pbpaste 'xclip -o -selection clipboard'
    abbr pbclear 'echo "" | xclip -i -selection clipboard'
  end

  # vim / vim-isms
  abbr v   "$EDITOR ."
  abbr vip "$EDITOR +PlugInstall +qall"
  abbr vup "$EDITOR +PlugUpdate"
  abbr vcp "$EDITOR +PlugClean +qall"
  abbr :q  "exit"
  abbr :Q  "exit"
# }}}

# Utility functions {{{
  function kp --description "Kill processes"
    set -l __kp__pid ''
    set __kp__pid (ps -ef | sed 1d | eval "fzf $FZF_DEFAULT_OPTS -m --header='[kill:process]'" | awk '{print $2}')

    if test "x$__kp__pid" != "x"
      if test "x$argv[1]" != "x"
        echo $__kp__pid | xargs kill $argv[1]
      else
        echo $__kp__pid | xargs kill -9
      end
      exec kp
    end
  end

  function gcb --description "Delete git branches"
    set delete_mode '-d'

    if contains -- '--force' $argv
      set force_label ':force'
      set delete_mode '-D'
    end

    set -l branches_to_delete (git branch | sed -E 's/^[* ] //g' | fzf -m --header="[git:branch:delete$force_label]")

    if test -n "$branches_to_delete"
      git branch $delete_mode $branches_to_delete
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

  function bup --description "Update brew plugins"
    set -l inst (brew leaves | eval "fzf $FZF_DEFAULT_OPTS -m --header='[brew:update]'")

    if not test (count $inst) = 0
      for prog in $inst
        brew upgrade "$prog"
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

  function fish_prompt --description 'Write out the prompt'
    switch $status
      case 0   ; set_color green
      case 127 ; set_color yellow
      case '*' ; set_color red
    end

    set_color -od
    echo -n '• '
    set_color blue
    echo -n (prompt_pwd)

    if test (git rev-parse --git-dir 2>/dev/null)
      set_color yellow
      echo -n " on "
      set_color green
      echo -n (git status | head -1 | string split ' ')[-1]

      if test -n (echo (git status -s))
        set_color magenta
      end

      echo -n ' ⚑'
    end

    set_color yellow
    echo ' ❯ '
    set_color -normal
  end
# }}}

# Gpg {{{
  gpg-agent --daemon --no-grab >/dev/null 2<&1
# }}}

# Sourcing {{{
  # macOS homebrew installs into /usr/local/share, apt uses /usr/share
  [ -f /usr/local/share/autojump/autojump.fish ]; and source /usr/local/share/autojump/autojump.fish
  [ -f /usr/share/autojump/autojump.fish ]; and source /usr/share/autojump/autojump.fish

  # asdf on macOS installed via homebrew, on linux via a git clone
  [ -f /usr/local/opt/asdf/asdf/asdf.fish ]; and source /usr/local/opt/asdf/asdf.fish
  [ -f $HOME/.asdf/asdf.fish ]; and source $HOME/.asdf/asdf.fish
# }}}

# TMUX {{{
  if status --is-interactive
  and command -s tmux >/dev/null
  and not set -q TMUX
    exec tmux new -A -s (whoami)
  end
# }}}

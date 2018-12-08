set fish_greeting
set -U  fish_user_paths            ~/bin
set -gx FZF_DEFAULT_OPTS           '--height=50% --min-height=15 --reverse'
set -gx FZF_DEFAULT_COMMAND        'rg --files --no-ignore-vcs --hidden'
set -gx FZF_CTRL_T_COMMAND         $FZF_DEFAULT_COMMAND
set -gx LPS_DEFAULT_USERNAME       'sidneyliebrand@gmail.com'
set -gx EVENT_NOKQUEUE             1
set -gx EDITOR                     nvim
set -gx HOMEBREW_FORCE_VENDOR_RUBY 1

bind \cq beginning-of-line

if not set -q __initialized
  set -U __initialized

  # gpg-agent
  abbr gpg-add "echo | gpg -s >/dev/null ^&1"

  # config files
  abbr vv   "$EDITOR ~/.config/nvim/init.vim"
  abbr tt   "$EDITOR ~/.tmux.conf"
  abbr zz   "$EDITOR ~/.config/fish/config.fish"
  abbr ff   "$EDITOR ~/.config/fish/config.fish"
  abbr zx   "reload -f"
  abbr zxx  "reload"

  # python
  abbr py   'python'

  # crystal
  abbr cr   'crystal'
  abbr csh  'shards'
  abbr cpl  'crystal play'
  abbr csp  'crystal spec'

  # git
  abbr g    'git'
  abbr ga   'git add'
  abbr g.   'git add .'
  abbr gb   'git branch'
  abbr gbl  'git blame'
  abbr gc   'git commit -m'
  abbr gco  'git checkout'
  abbr gcp  'git cherry-pick'
  abbr gd   'git diff'
  abbr gf   'git fetch'
  abbr glg  'git log --pretty="format:%Cred%h%Creset - %s %Cgreen(%cr)%Creset %C(blue)<%aN>%C(yellow)%d%Creset" --graph'
  abbr gl   'git log'
  abbr gm   'git merge'
  abbr gmt  'git mergetool'
  abbr grb  'git rebase'
  abbr gp   'git push'
  abbr gpu  'git push upstream'
  abbr gpl  'git pull'
  abbr gplu 'git pull upstream'
  abbr gr   'git remote'
  abbr gg   'git status'
  abbr gs   'git stash'
  abbr gsp  'git stash pop'

  # vim
  abbr v   "$EDITOR"
  abbr vd  "set -x VIM_DEV 1; and $EDITOR; and set -e VIM_DEV"
  abbr v.  "$EDITOR ."
  abbr vd. "set -x VIM_DEV 1; and $EDITOR .; and set -e VIM_DEV"
  abbr vip "$EDITOR +PlugInstall +qall"
  abbr vup "$EDITOR +PlugUpdate"
  abbr vcp "$EDITOR +PlugClean +qall"
end

[ -f /usr/local/share/autojump/autojump.fish ]; and source /usr/local/share/autojump/autojump.fish

gpg-agent --daemon --no-grab >/dev/null ^&1
set -g -x GPG_TTY (tty)

source /usr/local/opt/asdf/asdf.fish

if status --is-interactive
and command -s tmux >/dev/null
and not set -q TMUX
  exec tmux new -A -s (whoami)
end

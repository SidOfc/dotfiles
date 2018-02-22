function reload --description "Reload fish shell"
  if contains -- -f $argv
    set -e __initialized
  end
  source ~/.config/fish/config.fish
end

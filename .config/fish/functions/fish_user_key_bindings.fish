function fish_user_key_bindings
  bind -M visual  \ce end-of-line accept-autosuggestion
  bind -M insert  \ce end-of-line accept-autosuggestion
  bind -M default \ce end-of-line accept-autosuggestion
  bind -M default H   beginning-of-line
  bind -M default J   beginning-of-line
  bind -M default K   end-of-line
  bind -M default L   end-of-line
end

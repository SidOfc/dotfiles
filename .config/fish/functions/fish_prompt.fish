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

  echo -n (set_color $__stat_color)'⬤'(set_color blue) (prompt_pwd)"$__git_cb"(set_color yellow) '❯ '
end

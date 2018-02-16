function fish_prompt --description 'Write out the prompt'
  set -l __stat $status
  switch $__stat
    case 0   ; set __stat_color 'green'
    case 127 ; set __stat_color 'yellow'
    case '*' ; set __stat_color 'red'
  end

  if not set -q __git_cb
    if test (git status 2>/dev/null ^&1 | tail -1 | cut -f1 -d',') = 'nothing to commit'
      set __git_dirty (set_color green) '⚑'
    else
      set __git_dirty (set_color magenta) '⚑'
    end

    set __git_cb (set_color yellow)" on "(set_color green)(git branch ^/dev/null | grep \* | sed 's/* //')(set_color normal)"$__git_dirty"
  end

  echo -n (set_color $__stat_color)'⬤'(set_color blue) (prompt_pwd)"$__git_cb"(set_color yellow) '❯ '
end

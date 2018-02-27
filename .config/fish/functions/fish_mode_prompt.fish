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

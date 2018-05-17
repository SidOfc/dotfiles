function lps
  set -l username $LPS_DEFAULT_USERNAME
  set -l signedin 1
  set -l errormsg ''

  if command -s lpass >/dev/null
    while test -z $username
      read --prompt-str 'lpass username: ' username
    end

    lpass status >/dev/null 2>&1

    if not test $status -eq 0
      set errormsg (lpass login --trust $username 2>&1)
    end

    if not test $status -eq 0
      echo $errormsg >&2
      return 1
    else
      set -l pass (lpass ls -l | lpfmt | eval "fzf $FZF_DEFAULT_OPTS --ansi --header='[lastpass:copy]'" | cut -d ' ' -f 1)

      if not test -z $pass
        lpass show -cp $pass
      end
    end
  else
    echo "Please install [lpass] first"
  end
end

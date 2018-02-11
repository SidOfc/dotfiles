function cani --description "Caniuse support tables"
  set -l feat (ciu | sort -rn | eval "fzf $FZF_DEFAULT_OPTS --ansi --header='[caniuse:features]'" | sed -e 's/^.*%\ *//g' | sed -e 's/   .*//g')
end


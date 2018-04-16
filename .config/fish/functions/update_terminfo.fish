function update_terminfo --description "Update terminfo for alacritty"
  echo 'downloading: https://github.com/jwilm/alacritty/files/1236221/xterm-256color.zip'
  curl -sL -O https://github.com/jwilm/alacritty/files/1236221/xterm-256color.zip
  echo 'extracting: xterm-256color.zip'
  unzip xterm-256color.zip
  echo 'removing archive: xterm-256color.zip'
  rm xterm-256color.zip
  echo 'creating: ~/.terminfo/78'
  mkdir -p ~/.terminfo/78
  echo 'moving: xterm-256color.zip to ~/.terminfo/78/xterm-256color'
  mv xterm-256color ~/.terminfo/78/xterm-256color
  echo 'done!'
  echo 'restart your terminal.'
end

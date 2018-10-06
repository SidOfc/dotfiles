function pbclear --description "Provide functionality to clear from the pasteboard (the Clipboard) from command line"
  if test (which pbcopy)
    echo '' | pbcopy
  end
end

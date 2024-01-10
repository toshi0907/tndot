let filelist_vimrc = expand("~/.vim/vimrc/vimrc*")
let splitted_vimrc = split(filelist_vimrc, "\n")
for file_vimrc in splitted_vimrc
  execute 'source' file_vimrc
endfor


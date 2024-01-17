function! s:is_plugin_installed(plugin)
  return globpath(&runtimepath, 'pack/*/*/' . a:plugin, 1) != ''
endfunction

function! MyFuncFormatWholeFile()
  " ファイル全体をフォーマットするタイプのフォーマッタ

  if &filetype == 'css' && s:is_plugin_installed('vim-jsbeautify')
    call CSSBeautify()
  elseif &filetype == 'html' && s:is_plugin_installed('vim-jsbeautify')
    call HtmlBeautify()
  elseif &filetype == 'xml' && s:is_plugin_installed('vim-jsbeautify')
    call HtmlBeautify()
  elseif &filetype == 'json' && s:is_plugin_installed('vim-jsbeautify')
    call JsonBeautify()
  elseif &filetype == 'jsx' && s:is_plugin_installed('vim-jsbeautify')
    call JsxBeautify()
  elseif &filetype == 'javascript' && s:is_plugin_installed('vim-jsbeautify')
    call JsBeautify()
  elseif &filetype == 'sh'
    call MyFuncShfmt()
  elseif &filetype == 'vim'
    call MyFuncVimfmt()
  elseif &filetype == 'python'
    call MyFuncPyFmt()
  else
    echo "Please check filetype!!!"
  endif
  execute("edit")
  echo "format done!!!"
endfunction

function! MyFuncPyFmt()
  let strfilepath = expand("%") " ファイル名
  if executable("autopep8") != 0
    " execute("!autopep8 -i --aggressive --max-line-length=200 " . strfilepath)
    execute("!autopep8 -i --aggressive --max-line-length=500 " . strfilepath)
    execute("edit")
  elseif executable("black") != 0
    execute("!black " . strfilepath)
    execute("edit")
  else
    echo "autopep8 or black command not found!!!"
    return
  endif
endfunction

function! MyFuncVimfmt()
  " 現在位置のマーク
  execute("normal mZ")
  " 整形（ファイル全体）
  execute("normal gg=G")
  " マーク位置へ移動
  execute("normal 'Z")
  " マークの削除
  execute("delmarks Z")
endfunction

function! MyFuncShfmt()
  if executable("shfmt") == 0
    echo "shfmt command not found!!!"
    return
  endif

  let strfilepath = expand("%") " ファイル名

  " let extcutestr = "!shfmt -w -s " . strfilepath
  " shfmt : -wオプションはシンボリックリンクを破壊するので一時ファイルで受ける
  let extcutestr = "!shfmt -s -i 2 " . strfilepath . " > ~/tmp.sh;"
  let extcutestr = extcutestr . "if [ $? -eq 0 ]; then cat ~/tmp.sh > " . strfilepath . "; else echo === FAILED ===; fi;"
  let extcutestr = extcutestr . "rm ~/tmp.sh"

  if stridx(strfilepath, '.sh') >= 0
    execute extcutestr
  elseif stridx(strfilepath, '.bash') >= 0
    execute extcutestr
  elseif stridx(strfilepath, 'bashrc') >= 0
    execute extcutestr
  elseif stridx(strfilepath, 'git-') >= 0
    execute extcutestr
  else
    echo "This file is not shell script [*.sh / *.bash]"
  endif
  execute "redraw!"
endfunction

" Format
autocmd FileType vim        noremap <buffer> <C-F> :call MyFuncFormatWholeFile()<CR>
autocmd FileType css        noremap <buffer> <C-F> :call MyFuncFormatWholeFile()<CR>
autocmd FileType html       noremap <buffer> <C-F> :call MyFuncFormatWholeFile()<CR>
autocmd FileType xhtml      noremap <buffer> <C-F> :call MyFuncFormatWholeFile()<CR>
autocmd FileType xml        noremap <buffer> <C-F> :call MyFuncFormatWholeFile()<CR>
autocmd FileType json       noremap <buffer> <C-F> :call MyFuncFormatWholeFile()<CR>
autocmd FileType jsx        noremap <buffer> <C-F> :call MyFuncFormatWholeFile()<CR>
autocmd FileType javascript noremap <buffer> <C-F> :call MyFuncFormatWholeFile()<CR>
autocmd FileType sh         noremap <buffer> <C-F> :call MyFuncFormatWholeFile()<CR>
autocmd FileType python     noremap <buffer> <C-F> :call MyFuncFormatWholeFile()<CR>

:command! Fmt   :call MyFuncFormatWholeFile()
:command! Shfmt :silent call MyFuncShfmt()

function! s:is_plugin_installed(plugin)
  return globpath(&runtimepath, 'pack/*/*/' . a:plugin, 1) != ''
endfunction

" ###
" ### airblade/vim-gitgutter
" ###################################################################
if s:is_plugin_installed('vim-gitgutter')
  " Hunk移動
  autocmd BufEnter,BufNewFile,BufRead * nmap {            [c
  autocmd BufEnter,BufNewFile,BufRead * nmap }            ]c
  autocmd BufEnter,BufNewFile,BufRead *.diff nmap {       :call search('^ .*\n[+-]', 'b', 'W')<CR>
  autocmd BufEnter,BufNewFile,BufRead *.diff nmap }       :call search('^ .*\n[+-]', 'W')<CR>

  nnoremap <leader>ga :GitGutterStageHunk<CR>

  " default map: nmap <Leader>hs <Plug>GitGutterStageHunk
  " default map: nmap <Leader>hu <Plug>GitGutterUndoHunk
  " default map: nmap <Leader>hp <Plug>GitGutterPreviewHunk
  " default map: nmap ]c         <Plug>GitGutterNextHunk
  " default map: nmap [c         <Plug>GitGutterPrevHunk
  " default map: omap ic         <Plug>GitGutterTextObjectInnerPending
  " default map: omap ac         <Plug>GitGutterTextObjectOuterPending
  " default map: xmap ic         <Plug>GitGutterTextObjectInnerVisual
  " default map: xmap ac         <Plug>GitGutterTextObjectOuterVisual
endif

" ###
" ### tpope/vim-fugitive
" ###################################################################
if s:is_plugin_installed('vim-fugitive')
  nnoremap <leader>gd :Gdiffsplit<CR>
  " nnoremap <leader>gs :Git<CR>
  " nnoremap <leader>gc :Gcommit<CR>
  " nnoremap <leader>gl :Gclog<CR>
  " nnoremap gb  :Git blame<CR>
endif

" ###
" ### hotwatermorning/auto-git-diff
" ###################################################################
if s:is_plugin_installed('auto-git-diff')
  let g:auto_git_diff_show_window_at_right = 1
endif

" ###
" ### ctrlpvim/ctrlp.vim
" ###################################################################
if s:is_plugin_installed('ctrlp.vim')
  let g:ctrlp_working_path_mode = 'w' " default ra 'w' means currend dir
  let g:ctrlp_switch_buffer = '0' " don't jump
  let g:ctrlp_max_depth = 2
  let g:ctrlp_follow_symlinks = 1
endif

" ###
" ### vim-scripts/taglist.vim
" ###################################################################
if s:is_plugin_installed('taglist.vim')
  let Tlist_Show_One_File           = 1
  let Tlist_Exit_OnlyWindow         = 1 " タグリストだけが表示されているときに自動的にVimを終了するか
  let Tlist_Use_Right_Window        = 1 " タグ画面を右に表示するか
  let Tlist_Compact_Format          = 1 "デフォルト表示かコンパクト表示か
  let Tlist_WinWidth                = 40 "画面を左右に分割した場合の、タグ画面の初期幅
  let Tlist_GainFocus_On_ToggleOpen = 0 "開いたときにTlistへ移動
  let Tlist_Auto_Highlight_Tag      = 1
  let Tlist_Close_On_Select         = 0
  let Tlist_Auto_Update             = 1
  let Tlist_Sort_Type               = "order"
  " 表示項目を絞る設定
  " autocmd BufEnter,BufRead *.h   let tlist_cpp_settings = 'c++;c:class'
  " autocmd BufEnter,BufRead *.cpp let tlist_cpp_settings = 'c++;c:class;f:function'
  let tlist_cpp_settings = 'c++;c:class;f:function'

  " let tlist_markdown_settings = 'markdown;r:Title;s:Title2;t:Title3;'
  let tlist_markdown_settings = 'markdown;r:Title'

  " nnoremap tl :Tlist<CR><C-w>l<CR><C-w>l<CR><C-w>l
  nnoremap tl :Tlist<CR>
  nnoremap <leader>tl :TlistOpen<CR>
endif

" ###
" ### majutsushi/tagbar
" ###################################################################
if s:is_plugin_installed('tagbar')
  let g:tagbar_autoclose      = 0
  let g:tagbar_sort           = 0
  let g:tagbar_compact        = 1
  let g:tagbar_show_data_type = 1
  let g:tagbar_width          = 30
  let g:tagbar_foldlevel      = 0
  let g:tagbar_file_size_limit = 50000
  let g:tagbar_type_markdown = {
        \ 'kinds' : [
          \ 'a:title',
          \ ]
          \ }

  " nnoremap tl :TagbarToggle<CR><C-w>=

  " 現在位置のスコープを表示
  function! MyFuncTagScopeCheck()
    echo tagbar#currenttag('[%s]','','f')
  endfunction
  nnoremap <leader>fn :call MyFuncTagScopeCheck()<CR>
endif

" ###
" ### vim-scripts/vim-auto-save
" ###################################################################
if s:is_plugin_installed('vim-auto-save')
  let g:auto_save = 1
  let g:auto_save_in_insert_mode = 0
  let g:auto_save_silent = 1
endif

" ###
" ### thinca/vim-qfreplace
" ###################################################################
if s:is_plugin_installed('vim-qfreplace')
  nnoremap QF :Qfreplace<CR>
endif

" ###
" ### tpope/vim-surround
" ###################################################################
if s:is_plugin_installed('vim-surround')
  " N/A
endif

" ###
" ### justmao945/vim-clang
" ###################################################################
if s:is_plugin_installed('vim-clang')
  let g:clang_auto = 0      " disable autocomplete
  let g:clang_diagsopt = '' " <- disable diagnostics

  " set clang options for vim-clang
  " let g:clang_c_options = '-std=c11'
  " let g:clang_cpp_options = '-std=c++1z -stdlib=libc++ --pedantic-errors'
  " let g:clang_c_options = '-std=c11'
  " let g:clang_cpp_options = '-std=c++1z -stdlib=libc++ --pedantic-errors'

  " この変換を使用するには行選択「V」が必要
  autocmd FileType cpp vnoremap <C-F> :!clang-format<CR>
  " 1行フォーマット
  autocmd FileType cpp nnoremap <C-F> <S-v>:!clang-format<CR><S-v>=j
  " Hunk単位でのフォーマット

  if s:is_plugin_installed('vim-gitgutter')
    function! MyClangFormatHunkSet()
      " need git-gutter hunk text-object : GitGutterTextObjectInnerVisual
      let g:lTnCursLinePos = line(".")
      call setreg('v', "vic")
      call setreg('b', "vic")
      call setreg('n', "vic=")
    endfunction
    autocmd FileType cpp nnoremap <Leader>f :call MyClangFormatHunkSet()<CR>@v@b:s/} else/}\relse/ge<CR>@n:call MyClangFormatPosReturn()<CR>
  endif

  function! MyClangFormatPosReturn()
    call cursor(g:lTnCursLinePos, 0)
  endfunction
endif

" ###
" ### junegunn/vim-easy-align
" ###################################################################
if s:is_plugin_installed('vim-easy-align')
  let g:easy_align_delimiters = {
        \ '>': {
          \     'pattern': '>>\|=>\|>'      
          \   },
          \ ',': {
            \     'pattern':       ',',
            \     'left_margin':   0,
            \     'right_margin':  1,
            \     'stick_to_left': 0,
            \   },
            \ '/': {
              \     'pattern'         : '//\+\|/\*\|\*/',
              \     'delimiter_align' : 'l',
              \     'ignore_groups'   : ['!Comment']
              \   },
              \ ']': {
                \     'pattern'       : '[[\]]',
                \     'left_margin'   : 0,
                \     'right_margin'  : 0,
                \     'stick_to_left' : 0
                \   },
                \ ')': {
                  \     'pattern'       : '[()]',
                  \     'left_margin'   : 0,
                  \     'right_margin'  : 0,
                  \     'stick_to_left' : 0
                  \   },
                  \ 'd': {
                    \     'pattern'      : ' \(\S\+\s*[;=]\)\@=',
                    \     'left_margin'  : 0,
                    \     'right_margin' : 0
                    \   },
                    \ ' ': {
                      \     'pattern'         : ' ',
                      \     'delimiter_align' : 'l',
                      \   },
                      \ }
endif

" ###
" ### maksimr/vim-jsbeautify
" ###################################################################
if s:is_plugin_installed('vim-jsbeautify')
  autocmd   FileType   javascript   noremap   <buffer>   <c-f>   :call   JsBeautify()<cr>
  " for json
  autocmd   FileType   json         noremap   <buffer>   <c-f>   :call   JsonBeautify()<cr>
  " for jsx
  autocmd   FileType   jsx          noremap   <buffer>   <c-f>   :call   JsxBeautify()<cr>
  " for html xml
  autocmd   FileType   html         noremap   <buffer>   <c-f>   :call   HtmlBeautify()<cr>
  autocmd   FileType   xml          noremap   <buffer>   <c-f>   :call   HtmlBeautify()<cr>
  " for css or scss
  autocmd   FileType   css          noremap   <buffer>   <c-f>   :call   CSSBeautify()<cr>
endif

" ###
" ### tomasr/molokai
" ###################################################################
if s:is_plugin_installed('molokai')
  " N/A
endif

" ###
" ### aklt/plantuml-syntax
" ###################################################################
if s:is_plugin_installed('plantuml-syntax')
  " N/A
endif

" ###
" ### vim-scripts/aspnetcs
" ###################################################################
if s:is_plugin_installed('aspnetcs')
  " N/A
endif

" ###
" ### vim-jp/vimdoc-ja
" ###################################################################
if s:is_plugin_installed('vimdoc-ja')
  set helplang=ja,en
endif

" ###
" ### xxx
" ###################################################################
if has('nvim')
  if s:is_plugin_installed('xxx')
    " N/A
  endif
endif

" end

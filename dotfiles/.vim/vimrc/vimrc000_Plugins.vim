function! s:is_plugin_installed(plugin)
  return globpath(&runtimepath, 'pack/*/*/' . a:plugin, 1) != ''
endfunction

" ###
" ### lewis6991/gitsigns.nvim
" ###################################################################
if has('nvim')
  packadd gitsigns.nvim

  highlight  GitSignsAdd                  guifg=Black guibg=Green4
  highlight  GitSignsAddInline            guifg=White guibg=#006000
  highlight  GitSignsAddVirtLnInline      guifg=Black guibg=Green4
  highlight  GitSignsChange               guifg=Black guibg=Yellow4
  highlight  GitSignsChangeInline         guifg=White guibg=#606000
  highlight  GitSignsChangeVirtLnInline   guifg=Black guibg=Yellow4
  highlight  DiffDelete                   guifg=Black guibg=Red4
  highlight  GitSignsDeleteInline         guifg=White guibg=#600000
  highlight  GitSignsDeleteVirtLnInline   guifg=Black guibg=Red4

lua << EOF
require('gitsigns').setup {
  signs = {
    add          = { text = '++' },
    change       = { text = '**' },
    delete       = { text = '--' },
    topdelete    = { text = 'TD' },
    changedelete = { text = 'CD' },
    untracked    = { text = '/' },
  },
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl      = true, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = true, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    follow_files = true
  },
  auto_attach = true,
  attach_to_untracked = true,
  current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 200,
    ignore_whitespace = false,
    virt_text_priority = 100,
  },
  current_line_blame_formatter = '<author>, <committer_time:%Y-%m-%d> - <summary> [<abbrev_sha>]',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 100000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  yadm = {
    enable = false
  },

  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '}', function()
      if vim.wo.diff then return '}' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})
    map('n', '{', function()
      if vim.wo.diff then return '{' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})
    map('v', '}', function()
      if vim.wo.diff then return '}' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})
    map('v', '{', function()
      if vim.wo.diff then return '{' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    --[[
    map('n', '<leader>hs', gs.stage_hunk)
    map('n', '<leader>hr', gs.reset_hunk)
    map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)
    ]]
    map('n', '<leader>ga', gs.stage_hunk)

    -- Text object
    -- map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>') -- default
    map({'o', 'x'}, 'ic', ':<C-U>Gitsigns select_hunk<CR>')
  end
}
require('gitsigns').setup()
EOF
endif

" ###
" ### airblade/vim-gitgutter
" ###################################################################
if 0
  packadd vim-gitgutter
  if s:is_plugin_installed('vim-gitgutter')
    " Hunk移動
    autocmd BufEnter,BufNewFile,BufRead * nmap {            [c
    autocmd BufEnter,BufNewFile,BufRead * nmap }            ]c
    autocmd BufEnter,BufNewFile,BufRead *.diff nmap {       :call search('^ .*\n[+-]', 'b', 'W')<CR>
    autocmd BufEnter,BufNewFile,BufRead *.diff nmap }       :call search('^ .*\n[+-]', 'W')<CR>

    " let g:gitgutter_highlight_lines = 1
    " let g:gitgutter_highlight_linenrs = 1

    nnoremap <leader>ga :GitGutterStageHunk<CR>

    " default map: nmap <Leader>hs <Plug>GitGutterStageHunk
    " default map: nmap <Leader>hp <Plug>GitGutterPreviewHunk
    " default map: nmap ]c         <Plug>GitGutterNextHunk
    " default map: nmap [c         <Plug>GitGutterPrevHunk
    " default map: omap ic         <Plug>GitGutterTextObjectInnerPending
    " default map: omap ac         <Plug>GitGutterTextObjectOuterPending
    " default map: xmap ic         <Plug>GitGutterTextObjectInnerVisual
    " default map: xmap ac         <Plug>GitGutterTextObjectOuterVisual
  endif
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
  let tlist_markdown_settings = 'markdown;c:chapters;s:sections;u:subsections'
  " c  chapters
  " s  sections
  " u  subsections
  " b  subsubsections

  " nnoremap tl :Tlist<CR><C-w>l<CR><C-w>l<CR><C-w>l
  nnoremap tl :Tlist<CR>:TlistUpdate<CR>
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
  let g:tagbar_width          = 50
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
"
" 無効化中！！！
"
""" if s:is_plugin_installed('vim-auto-save')
"""   let g:auto_save = 0
"""   " let g:auto_save_in_insert_mode = 0
"""   " let g:auto_save_silent = 1
"""   " let g:auto_save_no_updatetime = 1
""" endif

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

  vnoremap <leader>ea, :EasyAlign */,/<l0r1<CR>
  vnoremap <leader>ea= :EasyAlign */=/l1r1<CR>
  vnoremap <leader>ea& :EasyAlign */&/l1r1<CR>
  vnoremap <leader>ea<space> :EasyAlign */ /l0r0ig[]<CR>
  vnoremap <leader>ea# :EasyAlign */#/l1r1ig[]<CR>

  let g:easy_align_delimiters = {
        \ '>': {
        \     'pattern': '>>\|=>\|>'      
        \   },
        \ ',': {
        \     'pattern':       ',',
        \     'left_margin':   0,
        \     'right_margin':  1,
        \     'stick_to_left': 1,
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

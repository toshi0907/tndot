" ###
" ### BasicSettings
" ######################################################

set fileencodings=utf-8,euc-jp,sjis,cp932,iso-2022-jp
set autoread
set autowrite
set updatetime=100 " 更新タイミング[ms]
autocmd CursorHold * silent wall!

set clipboard&
set clipboard^=unnamedplus

" gitのコミットメッセージが勝手に改行されないようにする
autocmd BufEnter,BufNewFile,BufRead * set textwidth=0

set backspace=indent,eol,start

au QuickfixCmdPost make,grep,grepadd,vimgrep copen

set grepprg=grep\ -rnI\ --exclude-dir=.svn\ --exclude-dir=CVS\ --exclude-dir=.git\ --exclude=tags

set scrolloff=999 " 常にカーソルを中心に
set nf=""         " 数字はすべて10進数として扱う

set tags=./tags;

set autochdir " 自動的に開いているファイルのPATHへ移動する

set nowritebackup
set nobackup
set noswapfile

" ### Search ###
set ignorecase   " 大文字小文字の区別なし
set smartcase    " 小文字検索時 大文字小文字の区別なし
set hlsearch     " 検索結果をハイライト
""set incsearch    " インクリメントサーチ
set noincsearch  " インクリメントサーチ無効
set wrapscan     " 末尾まで検索したらファイル先頭に戻る

" ### 表示関係 ###
set showmatch matchtime=1 " 対応する括弧を表示
set showcmd               " ウインドウ右下に入力中のコマンドを表示
set cmdheight=2           " 表示欄を2行に
set laststatus=2          " ステータス行を常に表示

" set noexpandtab     " タブ有効
set expandtab     " タブ入力で半角スペース
set shiftwidth=2  " インデントに使う空白の数
set softtabstop=2
set tabstop=2

set smartindent
set autoindent

set wildmenu " コマンドの補完をメニュー形式で

filetype on " ファイルタイプの設定ON
autocmd BufRead,BufNewFile .gitconfig.local set filetype=gitconfig

" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

" ###
" ### Status Line
" ###################################################################

set statusline=%<
set statusline+=%F " ファイル名
set statusline+=%h " help
set statusline+=%r " RO
set statusline+=%m " Modify
" set statusline+='[%{cfi#get_func_name()}()]'
set statusline+=%1* " ハイライト設定
set statusline+=%0* " ハイライト設定解除
" set statusline+=\ \ \ %{tagbar#currenttag('[%s]','[N/A]','f')}\ \ \  重い
set statusline+=%= " 中央の区切り
set statusline+=\ 
" set statusline+=%{'['.(&fenc!=''?&fenc:&enc).']'} " エンコード
set statusline+=%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}
set statusline+=%y " ファイルタイプ
set statusline+=[%1l/%L:%c] " 行数
" set statusline+=%{fugitive#statusline()}

" ###
" ### Syntax 見た目
" ###################################################################

syntax on  " シンタックスハイライト

if has('syntax')
  """ 全角スペースをハイライト表示
  augroup ZenkakuSpace
    autocmd!
    autocmd ColorScheme       * highlight ZenkakuSpace cterm=reverse ctermfg=DarkMagenta gui=reverse guifg=DarkMagenta
    autocmd VimEnter,WinEnter * call matchadd("ZenkakuSpace", '　')
  augroup END

  """ For Markdown
  augroup MarkdownSyn
    autocmd!
    """ チェックボックス
    " 未対応
    autocmd ColorScheme       * highlight MarkdownCheckboxNone guifg=Black guibg=Yellow3
    autocmd VimEnter,WinEnter * call matchadd("MarkdownCheckboxNone",    '^- [ \] ')
    " 対応済
    autocmd ColorScheme       * highlight MarkdownCheckboxChecked guifg=Black guibg=Green4
    autocmd VimEnter,WinEnter * call matchadd("MarkdownCheckboxChecked", '^- [x\] ')
    " 保留・対応不要
    autocmd ColorScheme       * highlight MarkdownCheckboxPending guifg=Black guibg=Gray
    autocmd VimEnter,WinEnter * call matchadd("MarkdownCheckboxPending", '^- [-\] ')
    " 見出し
    autocmd ColorScheme       * highlight markdownH1 guifg=Black guibg=Grey82
  augroup END
endif

" 端末の背景色を採用 colorschemeより前に記述必要？
autocmd ColorScheme * highlight Normal ctermbg=none guibg=none
autocmd ColorScheme * highlight LineNr ctermbg=none guibg=none

set background=dark
colorscheme molokai

set list
set listchars=tab:>_,trail:･

set number " 行番号の表示
" set relativenumber " 現在行からのオフセット行数表示
set title

" ### カーソル ###
" set cursorcolumn " 強調表示
set cursorline " 強調表示

set termguicolors " tmuxで変な感じになったのでコメントアウト
set t_Co=256


" ###
" ### Commands
" ###################################################################

" vimrcファイル再読み込み
:command! VIMRC   :source ~/.vimrc

" 文字コード変更
:command! EncChangeEucjp :e ++enc=euc-jp<CR>
:command! EncChangeSjis  :e ++enc=sjis<CR>
:command! EncChangeUtf8  :e ++enc=utf-8<CR>

" ###
" ### KeyMappings
" ###################################################################

" Leaderの変更
let mapleader = "\<Space>"

" vimrcの更新
nnoremap <F1> :source ~/.vimrc<CR>

" jjでエスケープ
inoremap <silent> jj <ESC>

" 検索
nnoremap * viw"zy/<C-r>z
vnoremap * "zy:/<C-r>z
nnoremap <ESC> :noh<CR>

" {}への移動
nmap (            :call search('{', 'b')<CR>
nmap )            :call search('}')<CR>

" Markdown移動
autocmd FileType markdown nnoremap <leader>#                 /^# <CR>
autocmd FileType markdown nnoremap <leader><leader>#         /^## <CR>
autocmd FileType markdown nnoremap <leader><leader><leader># /^### <CR>
autocmd FileType markdown nnoremap <leader>- /^- <CR>

" ちょっとだけ高速移動
nnoremap <S-j>      5j
nnoremap <S-k>      5k
nnoremap <S-h>      ^
nnoremap <S-l>      $
vnoremap <S-j>      5j
vnoremap <S-k>      5k
vnoremap <S-h>      ^
vnoremap <S-l>      $
" rebase-todoでのShift+kの割り当てを消す
autocmd BufEnter,BufRead,BufNewFile git-rebase-todo nnoremap <buffer> <S-k> 5k
" autocmd BufEnter,BufRead,BufNewFile git-rebase-todo unmap <buffer> <S-k>

" 折り返し表示時も表示単位で移動
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" 入力・コマンドモードでのカーソル移動
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>

" 行末までヤンク
nnoremap Y y$

" x:削除でヤンクしない
nnoremap x "_x

" 単語ヤンク＆単語置換
" nnoremap <leader>y viwy
nnoremap <leader>y viw"zyviwy
nnoremap <leader>p viw"0P
" nnoremap <leader>p viwP

" ウインドウ移動
"nnoremap <leader>k <C-w>k
"nnoremap <leader>j <C-w>j
"nnoremap <leader>h <C-w>h
"nnoremap <leader>l <C-w>l
nnoremap <C-k> <C-w>k
nnoremap <C-j> <C-w>j
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" ウインドウ
nnoremap <leader><leader>h :vs<CR><C-w>
nnoremap <leader><leader>j :sp<CR><C-w>j
nnoremap <leader><leader>k :sp<CR><C-w>
nnoremap <leader><leader>l :vs<CR><C-w>l

" ウインドウサイズ変更
" 最大化
nnoremap <leader>jj :resize<CR>:vertical resize<CR>
" 均等
nnoremap <leader>jk <C-w>=
" 微調整
nnoremap > 5<C-w>>
nnoremap < 5<C-w><
nnoremap + <C-w>+
nnoremap - <C-w>-
" tnoremap > 5<C-w>>
" tnoremap < 5<C-w><
" tnoremap + <C-w>+
" tnoremap - <C-w>-
"
" 終了
" nnoremap <C-q>      :q<CR>
nnoremap <C-w>      :q<CR> " vscodeに合わせる
nnoremap <C-z>      <Nop>

" 数字を増加させながら下へ
nnoremap <leader>i viwy<ESC>jviw"0P<ESC><C-a>
nnoremap <leader>d viwy<ESC>jviw"0P<ESC><C-x>

" 補完表示時のEnterで改行をしない
inoremap <expr><CR>  pumvisible() ? "<C-y>" : "<CR>"

" 補完ウインドウ上下キーで移動
inoremap <expr><C-n> pumvisible() ? "<Down>" : "<C-n>"
inoremap <expr><C-p> pumvisible() ? "<Up>" : "<C-p>"

" カーソル下の単語を置換
nnoremap <leader><C-h>      viwy:%s/<C-r>"/<C-r>"/g
vnoremap <leader><C-h>      y:%s/<C-r>"/<C-r>"/g

" QuickFix移動
nnoremap <C-n> :cn<CR>
nnoremap <C-b> :cN<CR>

" ref jump
nnoremap <C-]> g<C-]>

" grep
nnoremap <expr> gr ':silent grep ' . expand('<cword>') . ' *'
vnoremap gr y:silent grep "<C-r>"" *

" ヤンクした内容をコマンドへ
nnoremap <leader>e :<C-r>"

" インデント調整を連続で
vnoremap > >gv
vnoremap < <gv

" コマンドモード
" コピペ
cmap <C-v> <C-r>"

nnoremap <C-]> g<C-]>
" nnoremap <C-]> <C-w><C-]> " 画面分割で開く

" nnoremap <C-E> :Explore<CR>
" nnoremap <C-E> :30Lexplore ~/.config<CR> " 左に分割して開く:幅30px
nnoremap <C-E> :30Lexplore<CR> " 左に分割して開く:幅30px

function! MyFuncRunSh()
  " 現在編集中のシェルスクリプトファイルを実行
  let strfilepath = expand("%:p") " ファイル名
  echo strfilepath
  if stridx(strfilepath, '.sh') > 0
    execute  "!" . strfilepath
  elseif stridx(strfilepath, '.py') > 0
    execute  "!" . strfilepath
  elseif stridx(strfilepath, 'git-rebase-todo') > 0
    execute "!preedit_rebase_todo.py " . strfilepath
    execute "edit"
  else
    echo "[MyFuncRunSh Error]This file is not *.sh or *.py file !!!"
  endif
endfunction
nnoremap <F4>      :call MyFuncRunSh()<CR>

function! MyFuncCtags()
  " ctagsを実行
  if executable("ctags") == 0
    echo "ctags command not found!!!"
    return
  endif
  execute  "!ctags -R"
endfunction
nnoremap <F9>      :call MyFuncCtags()<CR>

" 自分用メモを開く
nnoremap <C-t> :e ~/.vim/note.md<CR>

let g:markdown_fenced_languages = ['cpp', 'bash=sh', 'python', 'sql', 'html', 'javascript', 'css', 'vim', 'vb', 'cs', 'diff', 'dosbatch', 'lua']

" END OF FILE

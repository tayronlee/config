" ------ Plugins ------

set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

" fzf: fuzzy search, similar to sublime's goto anything
Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'junegunn/fzf.vim'

" tmux-vim navigation
Plugin 'christoomey/vim-tmux-navigator'

" C++ Syntax
Plugin 'bfrg/vim-cpp-modern'

" status line
Plugin 'itchyny/lightline.vim'
set laststatus=2
set noshowmode
let g:lightline = {
  \ 'colorscheme': 'one_tayron',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitstatus', 'readonly', 'filename', 'modified' ] ]
  \ },
  \ 'component_function': {
  \   'gitstatus': 'FugitiveStatusline'
  \ },
  \ }

" colorscheme
Plugin 'rakr/vim-one'

" async command dispatch
Plugin 'tpope/vim-dispatch'

" async command dispatch
Plugin 'tpope/vim-fugitive'

call vundle#end()            " required
filetype plugin indent on    " required

" --- General config ---

syntax on
set showcmd
set shm-=S
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set background=dark
colorscheme one
highlight Visual cterm=reverse ctermbg=NONE
highlight Normal ctermfg=145 ctermbg=NONE guifg=#ABB2BF guibg=NONE
let g:one_allow_italics = 1
call one#highlight('CursorLineNr', '', '333333', 'none')
call one#highlight('Search', 'e06c75', '61afef', 'bold')
call one#highlight('IncSearch', 'e06c75', '61afef', 'bold')

set wildmenu
set hidden

set autoindent
set smartindent
set smarttab
set expandtab
set tabstop=2
set shiftwidth=2

set number relativenumber

set hlsearch
set incsearch
set smartcase
set ignorecase

set foldlevel=10
set foldmethod=syntax
autocmd FileType cpp setlocal cino=N-s
autocmd FileType python setlocal foldmethod=indent

set timeoutlen=250 ttimeoutlen=0

set backspace=indent,start
"Splits
set splitbelow
set splitright

"Remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

"Custom Commands
command! DiffChanges execute 'w !diff  % -'
set grepprg=grep\ -rns
command! -nargs=+ Grep execute 'silent grep! -r <args>' | copen 15 | redraw!

function! SwitchFiles()
  let l:ext = expand("%:e")
  if l:ext == "cpp"
    let l:file = join([expand("%:r"),".hpp"], "")
  elseif l:ext == "hpp"
    let l:file = join([expand("%:r"),".cpp"], "")
  else
    let l:file = ""
  endif
  if filereadable(l:file)
    execute "edit " l:file
  endif
endfunction

function! Copy(text)
  call system("echo " . shellescape(a:text) . " | xclip -i -sel clipboard")
endfunction

function! GetCurrFileAndLine()
  return join([expand("%:."), line(".")], ":")
endfunction

function! GetVisualSelection()
  normal! gv"zy
  let raw = @z
  let text = escape(raw, '\')
  return text
endfunction

"Version Control
command! GitDiff execute "silent !git diff %" | redraw!
"Mappings
let mapleader = " "
set mouse=a
map <ScrollWheelUp> 10<C-Y>
map <ScrollWheelDown> 10<C-E>
let g:tmux_navigator_no_mappings = 1
let g:tmux_navigator_disable_when_zoomed = 1
noremap <silent> <C-[>h :TmuxNavigateLeft<CR>
noremap <silent> <C-[>j :TmuxNavigateDown<CR>
noremap <silent> <C-[>k :TmuxNavigateUp<CR>
noremap <silent> <C-[>l :TmuxNavigateRight<CR>

" Copy in visual mode
xnoremap <silent> <C-c> :call Copy(GetVisualSelection())<cr>
" <c-l> clears search highlight
if maparg('<c-l>', 'n') ==# ''
  nnoremap <silent> <c-l> :nohlsearch<c-r>=has('diff')?'<bar>diffupdate':''<cr><cr><c-l>
endif

" fzf
let g:fzf_layout = { 'down': '33%' }
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>t "zyiw:Tags <C-r>z<CR>

"custom
nnoremap <Leader>d :DiffChanges<CR>
nnoremap <Leader>g "zyiw:Grep <C-r>z .<CR>
nnoremap <silent> <Leader>s :call SwitchFiles()<CR>
nnoremap <silent> <Leader>c :call Copy(GetCurrFileAndLine())<CR>

nnoremap <silent><C-Up> :m -2<CR>
nnoremap <silent><C-Down> :m +1<CR>


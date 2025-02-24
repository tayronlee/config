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
  \             [ 'gitstatus', 'readonly', 'relativepath', 'modified' ] ]
  \ },
  \ 'component_function': {
  \   'gitstatus': 'FugitiveStatusline'
  \ },
  \ }

" LSP support
Plugin 'autozimu/LanguageClient-neovim', {
      \ 'branch': 'next',
      \ 'do': 'bash install.sh',
      \ }
let g:LanguageClient_serverCommands = {
    \ 'cpp' : ['clangd']
    \ }
let g:LanguageClient_diagnosticsList = 'Disabled'

" colorscheme
Plugin 'rakr/vim-one'

" async command dispatch
Plugin 'tpope/vim-dispatch'

" git integration
Plugin 'tpope/vim-fugitive'

Plugin 'vimwiki/vimwiki'

let g:vimwiki_list = [{'path': '/home/tayron/notes',
                     \ 'syntax': 'markdown', 'ext': '.md'}]

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
set encoding=utf-8
set termencoding=utf-8

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

highlight ExtraWhitespace ctermbg=168 guibg=DarkRed
autocmd Syntax * syn match ExtraWhitespace /\s\+$\|\t\+/

set foldlevel=10
set foldmethod=syntax
autocmd FileType python setlocal foldmethod=indent

set timeoutlen=500 ttimeoutlen=0

set backspace=indent,start
"Splits
set splitbelow
set splitright

"Remove trailing whitespace on save
"autocmd BufWritePre * :%s/\s\+$//e

"Custom Commands
command! DiffChanges execute 'w !diff  % -'
command! -nargs=+ Grep set grepprg=grep\ -rns | execute 'silent grep! <args>' | copen 15 | redraw!
command! -nargs=+ GrepCpp set grepprg=grepcpp\ -p | execute 'silent grep! <args>' | copen 15 | redraw!

function! SwitchFiles()
  let l:ext = expand("%:e")
  if l:ext == "cpp"
    "let l:file = join([expand("%:r"),".hpp"], "")
    let l:file = join([expand("%:r"),".h"], "")
  "elseif l:ext == "hpp"
  elseif l:ext == "h"
    let l:file = join([expand("%:r"),".cpp"], "")
  else
    let l:file = ""
  endif
  if filereadable(l:file)
    execute "edit " l:file
  endif
endfunction

"Depends on https://github.com/sunaku/home/blob/master/bin/yank
function! Copy(text) abort
  let escape = system('copy', a:text)
  if v:shell_error
    echoerr escape
  else
    call writefile([escape], '/dev/tty', 'b')
  endif
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
" Ctrl+l clears search highlight
if maparg('<c-l>', 'n') ==# ''
  nnoremap <silent> <c-l> :nohlsearch<c-r>=has('diff')?'<bar>diffupdate':''<cr><cr><c-l>
endif

" fzf
let g:fzf_layout = { 'down': '33%' }
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>t "zyiw:Tags <C-r>z<CR>

"LSP
nnoremap <silent> <Leader>s :call LanguageClient#textDocument_switchSourceHeader()<CR>
nnoremap <silent> <Leader>ld :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <Leader>li :call LanguageClient#textDocument_implementation()<CR>
nnoremap <silent> <Leader>lt :call LanguageClient#textDocument_typeDefinition()<CR>
nnoremap <silent> <Leader>lr :call LanguageClient#textDocument_references()<CR>
nnoremap <silent> <Leader>lh :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> <Leader>le :call LanguageClient#explainErrorAtPoint()<CR>

"custom
nnoremap <Leader>d :DiffChanges<CR>
nnoremap <Leader>g "zyiw:GrepCpp <C-r>z<CR>
nnoremap <Leader>gg "zyiw:Grep <C-r>z<CR>
nnoremap <silent> <Leader>c :call Copy(GetCurrFileAndLine())<CR>

nnoremap <silent><C-Up> :m -2<CR>
nnoremap <silent><C-Down> :m +1<CR>


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
  \ 'colorscheme': 'Tomorrow_Night_Tayron',
  \ }

" colorscheme
Plugin 'rakr/vim-one'

" Other plugins:
"  - YouCompleteMe
"  - tags? cscope?
"  - surround

call vundle#end()            " required
filetype plugin indent on    " required

" --- General config ---

syntax on
set showcmd
set shm-=S
if !has('gui_running')
  set t_Co=256
endif

colorscheme one 
highlight Visual cterm=reverse ctermbg=NONE
highlight Normal ctermfg=145 ctermbg=NONE guifg=#ABB2BF guibg=NONE

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

set foldmethod=syntax
set foldlevel=10

set timeoutlen=250 ttimeoutlen=0

"Splits
set splitbelow
set splitright

" Custom Commands
command! DiffChanges execute 'w !diff  % -'
function! SwitchFiles()
  let ext =  expand("%:e")
  if ext == "cpp"
    let file = join([expand("%:r"), ".hpp"], "")
  elseif ext == "hpp"
    let file = join([expand("%:r"), ".cpp"], "")
  elseif ext == "c"
    let file = join([expand("%:r"), ".h"], "")
  elseif ext == "h"
    let file = join([expand("%:r"), ".c"], "")
  else
    let file = ""
  endif
  if filereadable(file)
    execute "edit " file
  endif
endfunction

"Mappings
let mapleader = " "
set mouse=a
map <ScrollWheelUp> 10<C-Y>
map <ScrollWheelDown> 10<C-E>
let g:tmux_navigator_no_mappings = 1
noremap <silent> <C-[>h :TmuxNavigateLeft<CR>
noremap <silent> <C-[>j :TmuxNavigateDown<CR>
noremap <silent> <C-[>k :TmuxNavigateUp<CR>
noremap <silent> <C-[>l :TmuxNavigateRight<CR>
" Copy in selection mode
"xmap <silent> <C-c> :'<,'>w !xclip -i -sel clipboard<CR><CR> -> This takes whole lines
xnoremap <silent> <C-c> "zy:call system("echo '<C-r>z'<Bar>xclip -i -sel clipboard")<CR>
" <C-l> clears search highlight
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif
" fzf
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>t "zyiw:Tags <C-r>z<CR>
" custom
nnoremap <Leader>d :DiffChanges<CR>
nnoremap <silent> <Leader>s :call SwitchFiles<CR>


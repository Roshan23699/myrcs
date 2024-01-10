set tags=tags;/
set nocscoperelative
set csto=0
set number
set paste
set tabstop=4
set expandtab
set clipboard=unnamed
set cursorline
if has('persistent_undo')      "check if your vim version supports it
  set undofile                 "turn on the feature  
  set undodir=$HOME/.vim/undo  "directory where the undo files will be stored
  endif



" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

function GitDiff()
    :silent write
    :silent execute '!git diff  --color=always -- ' . expand('%:p') . ' | less --RAW-CONTROL-CHARS'
    :redraw!
endfunction

nnoremap <leader>gd :call GitDiff()<cr>

"no dd <Nop>

"nnoremap <silent> dd "_dd""
set title
 
set softtabstop=4
set shiftwidth=4
set incsearch
set hls
nnoremap ' :!cscope -Rb<CR><CR>:cs reset<CR>:!ctags -R --sort=yes --fields=+lS --c-kinds=f --extra=+q<CR><CR>
function GitShow()
    :silent write
    :silent execute '!git show -- % --color=always'
    :redraw!
endfunction
nnoremap <leader>gs :call GitShow()<cr>
set autoindent
set cindent
highlight ExtraWhitespace ctermbg=white
match ExtraWhitespace /\s\+$/
set ignorecase
set laststatus=2
set statusline=%f\ %{FugitiveStatusline()}
highlight clear statusline

nnoremap mm <C-w>w
nnoremap <C-b> :TagbarToggle<CR>
set runtimepath+=~/.vim/tagbar
let g:tagbar_sort = 1
set updatetime=100

call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-gitgutter'


" Make sure you use single quotes
call plug#end()

" A

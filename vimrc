if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
  \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')
Plug 'https://github.com/tpope/vim-markdown.git'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/seoul256.vim'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'kien/ctrlp.vim'
Plug 'pangloss/vim-javascript'
Plug 'mattn/emmet-vim'
Plug 'chiel92/vim-autoformat'
Plug 'bling/vim-airline'
Plug 'tpope/vim-surround'
Plug 'Valloric/YouCompleteMe'
Plug 'leafgarland/typescript-vim'
Plug 'lervag/vimtex'
"Plug 'vim-pandoc/vim-pandoc'
"Plug 'vim-pandoc/vim-pandoc-syntax'
call plug#end()
let g:goyo_width = 80
syntax on
set tabstop=4
set shiftwidth=4
set expandtab
command WQ wq
command Wq wq
command W w
command Q q
set number
filetype indent on
inoremap jj <Esc>
" Inspired by https://jennifermack.net/2017/02/01/recreating-ulysses-with-vim/
set spellsuggest=15
set linebreak
set scrolloff=3
set foldcolumn=1
map j gj
map k gk
map ; :
map $ g$
map 0 g0
map <space> <PageDown>
" Fix for Ctrl+Space sending NUL
map <NUL> <PageUp>
map <leader>s :setlocal spell<CR>
map <F1> [s
map <F2> z=
map <F3> ]s
map <F4> zg
map <F5> zG
map <caps lock> <control>
autocmd! User GoyoEnter Limelight0.7
autocmd! User GoyoLeave Limelight!
colo seoul256
map <leader>w :Goyo <enter>
map <C-n> :NERDTreeToggle<CR>
map <C-s> :w <CR> :!git add "%"; and git commit -m "%" --quiet; and git push --quiet<CR>
:filetype plugin on
"Map adding surrounding word with following character
map <leader>r ysiw
"y copy to clipboard
:set cb=unnamed

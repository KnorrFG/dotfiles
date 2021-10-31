" Basic Settings [[[
let g:python3_host_prog = '/home/felix/.pyenv/versions/neovim/bin/python3'
let g:loaded_python_provider = 1
set nocompatible
set t_Co=256

set mouse=a
set guioptions-=T
set guioptions-=m

set tabstop=2
set shiftwidth=2
set textwidth=79
set backspace=indent,eol,start
set pastetoggle=<F2>

set splitbelow
set splitright
set hidden

set hlsearch
set incsearch
set ignorecase
set colorcolumn=80
set foldcolumn=2
set number relativenumber

set nobackup       "no backup files
set nowritebackup  "only in case you don't want a backup file while editing
set noswapfile     "no swap files

" Lightline config
set laststatus=2

"CtrlP ignore patterns
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows

"completion related
" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

syntax on
filetype plugin indent on

"Highlight spelling errors
hi SpellBad cterm=underline ctermfg=red

if &shell =~# 'fish$'
	set shell=/usr/bin/bash
endif
" ]]]
" Fold Text Display [[[
set foldtext=MyFoldText()
function! MyFoldText()
  return getline(v:foldstart)
endfunction
" ]]]
" Install Plug if required  [[[
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
	  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
		  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
		endif
"]]]
" Installed Plugins [[[
call plug#begin(stdpath('data') . '/plugged')
Plug 'neovim/nvim-lspconfig'
Plug 'kien/ctrlp.vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'flazz/vim-colorschemes'
Plug 'itchyny/lightline.vim'
Plug 'majutsushi/tagbar'
Plug 'lervag/vimtex'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdcommenter'
Plug 'kien/rainbow_parentheses.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'zah/nim.vim'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'mtikekar/nvim-send-to-term'
Plug 'jeetsukumaran/vim-pythonsense'
Plug 'mattn/emmet-vim'
Plug 'nvim-lua/completion-nvim'
Plug 'HallerPatrick/py_lsp.nvim'
Plug 'rust-lang/rust.vim'
call plug#end()
" ]]]
" Plugin Config [[[
let g:nerddefaultalign = 'left'
let g:send_disable_mapping = 1
let g:user_emmet_install_global = 0
let g:completion_enable_snippet = 'UltiSnips'
"  	LSP Server [[[
lua << EOF
lsp_config = require'lspconfig'

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  require'completion'.on_attach()

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<localleader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<localleader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<localleader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<localleader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<localleader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<localleader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<localleader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<localleader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<localleader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

local servers = {'pyright', 'nimls'}
for _, lsp in ipairs(servers) do
  lsp_config[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

EOF
" 	]]]
"   Ultisnips [[[
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
"]]]
"   Vimtex options [[[
let g:tex_flavor = 'latex'
let g:vimtex_compiler_method = 'latexrun'
let g:vimtex_fold_enabled = 1
let g:vimtex_view_method = 'zathura'
let g:vimtex_view_forward_search_on_start = 0
let g:vimtex_compiler_progname = 'nvr'
"]]]
"]]]
" Color scheme [[[
set background=dark
colorscheme gruvbox
"]]]
" MD Functions [[[
function! InsertImgFromCB(name)
    execute "!xclip -sel clip -t image/png -o > " . 
					\ "/home/felix/Nextcloud/mdn.d/assets/" . a:name
    execute "norm a![](" . a:name . ")"
endf
command! -nargs=1 PasteImage call InsertImgFromCB(<f-args>)

function! MarkdownOptions()
	hi SpellBad cterm=underline ctermfg=red
	set tw=79
	set spelllang=de_20,en
	nnoremap <localleader>ppi :PasteImage
			\ paper_imgs/
	nnoremap <localleader>pi :PasteImage

	" Make a marked text into a link with a link from the clipboard
	vmap <localleader>k S]%a(<esc>"*pa)<esc>
endf
" ]]]
" Autocommands [[[
augroup vimrc
	autocmd!
	au FileType vim setlocal foldmarker=[[[,]]] foldmethod=marker 
	au BufNewFile,BufRead *.py,*.hs set
		\ tabstop=4
		\ softtabstop=4
		\ shiftwidth=4
		\ expandtab
		\ autoindent
		\ fileformat=unix

	"auto insert most basic latex template
	au BufNewFile *.tex :execute
		\"normal!  i
		\\\documentclass{article}\<cr>\<cr>
		\\\usepackage[utf8]{inputenc}\<cr>\<cr>
		\\\title{}\<cr>
		\\\date{}\<cr>
		\\\author{}\<cr>
		\\\begin{document}\<cr>
		\\\maketitle\<cr>\<cr>
		\\\end{document}"

	au filetype python nmap <localleader>rsi :w<CR> :%! isort -d %<CR>
	au filetype markdown call MarkdownOptions()
	au filetype html,css EmmetInstall

	au VimEnter * RainbowParenthesesToggle
	au Syntax * RainbowParenthesesLoadRound
	au Syntax * RainbowParenthesesLoadSquare
	au Syntax * RainbowParenthesesLoadBraces
augroup END
" ]]]
" Keyboard Mappings [[[
let mapleader = ' '
let maplocalleader = ','
map <leader>ev :e /home/felix/.local/share/chezmoi/dot_config/nvim/init.vim<CR>
map <leader>sv :!chezmoi apply<CR>:source $MYVIMRC<CR>
map <leader>sn :noh<CR>
map <leader>st :set spell!<CR>
map <leader>sg :set spelllang=de_20<CR>
map <leader>se :set spelllang=en<CR>
map <leader>sb :set spelllang=de_20,en<CR>
nnoremap <leader>md :set mouse-=a<CR> 
nnoremap <leader>me :set mouse+=a<CR>

"Use Tab to toggle folds
nnoremap <silent> <Tab> @=(foldlevel('.')?'za':"\<Tab>")<CR>
vnoremap <Tab> zf

"use tab for completion
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"


imap jj <Esc>
imap <C-d> <DEL>

"Plugin mappings
nmap <leader>tb :TagbarOpenAutoClose<CR>
nmap <leader>ff :CtrlP<CR>
nmap <leader>bb :CtrlPBuffer<CR>
nmap <leader>fr :CtrlPMRUFiles<CR>
map <leader>tc <plug>NERDCommenterToggle
imap <silent> <c-p> <Plug>(completion_trigger)


" Interactive Repl stuff
nmap <c-s><c-s> <Plug>SendLine
nmap <c-s> <Plug>Send
vmap <c-s> <Plug>Send
tmap <c-w><c-w> <c-\><c-n><c-w><c-w>
"]]]

" Basic Settings [[[
let g:python3_host_prog = '/home/felix/.pyenv/versions/neovim/bin/python3'
let g:loaded_python_provider = 1
set nocompatible
set t_Co=256

set mouse=a
set guioptions-=T
set guioptions-=m

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
"Plug 'kien/ctrlp.vim'
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
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'Maxattax97/coc-ccls'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
call plug#end()
" ]]]
" Plugin Config [[[
let g:nerddefaultalign = 'left'
let g:send_disable_mapping = 1
let g:user_emmet_install_global = 0
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
    let host = substitute(system('hostname'), '\n\+$', '', '')
    if host == "TP-Felix"
        let save_path = "/home/felix/.mdn.d/assets/" . a:name
    else
        let save_path = "/home/felix/Nextcloud/mdn.d/assets/" . a:name
    endif


    if $XDG_SESSION_TYPE == "wayland"
        execute "!wl-paste > " . save_path
    else
        execute "!xclip -sel clip -t image/png -o > " . save_path
    endif
					\ 
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
" C Config [[[
function! COptions()
    nmap ,mm :make<CR>
    nmap ,mr :make run<CR>
endf
" ]]]
" Autocommands [[[
augroup vimrc
	autocmd!
	au FileType vim setlocal foldmarker=[[[,]]] foldmethod=marker 
	au filetype python,haskel,c,sh set
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
    au filetype c call COptions()

	au VimEnter * RainbowParenthesesToggle
	au Syntax * RainbowParenthesesLoadRound
	au Syntax * RainbowParenthesesLoadSquare
	au Syntax * RainbowParenthesesLoadBraces
augroup END
" ]]]
" My commands [[[
command Ev :e /home/felix/.local/share/chezmoi/dot_config/nvim/init.vim
command -bar Ca :!chezmoi apply
command Sv :Ca|:source $MYVIMRC

" ]]]
" Keyboard Mappings [[[
let mapleader = ' '
let maplocalleader = ','
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
"inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

imap jj <Esc>
imap <C-d> <DEL>

"Plugin mappings
nmap <leader>tb :TagbarOpenAutoClose<CR>
nmap <leader>ff :Files<CR>
nmap <leader>fb :Buffers<CR>
nmap <leader>fr :History<CR>
nmap <leader>fl :Lines<CR>
map <leader>tc <plug>NERDCommenterToggle
imap <silent> <c-p> <Plug>(completion_trigger)


" Interactive Repl stuff
nmap <c-s><c-s> <Plug>SendLine
nmap <c-s> <Plug>Send
vmap <c-s> <Plug>Send
tmap <c-w><c-w> <c-\><c-n><c-w><c-w>

" Coc specific keys [[[
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <localleader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <localleader>f  <Plug>(coc-format-selected)
nmap <localleader>f  <Plug>(coc-format-selected)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <localleader>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <localleader>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <localleader>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <localleader>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <localleader>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <localleader>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <localleader>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <localleader>p  :<C-u>CocListResume<CR>
"]]]
"]]]

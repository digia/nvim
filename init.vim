filetype plugin indent on
syntax enable

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set Options
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set guicursor=

set number
" set relativenumber

set autoindent
set cindent
set wrap

" Make it so that long lines wrap smartly
set breakindent
let &showbreak=repeat(' ', 3)
set linebreak

set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store,*/.idea/*,*/tmp/*,*/node_modules/**,*/bower_components/**,**/venv/**,*.pyc

if has('nvim-0.4')
  " Use floating wildmenu opacity options
  set pumblend=17

  set wildmode-=list
  set wildmode+=longest
  set wildmode+=full

  " Floating PopUpMenu for completing command line things, similar to
  " completing in insert mode
  set wildoptions+=pum
else
  set wildmode=longest,list,full

  " Vim Galore recommended mappings: next and previous use smart history
  cnoremap <C-N> <Up>
  cnoremap <C-P> <Down>
end

set tabstop=4
set shiftwidth=4
set softtabstop=4

" Always use spaces instead of tab characters
set expandtab

" Just turn the dang bell off
set belloff=all
"set noerrorbells

set nohlsearch
set hidden
set smartindent
set noswapfile
set nobackup
set undofile
set termguicolors
set noshowmode
set completeopt=menuone,noinsert,noselect

set noequalalways                     " I don't like my windows changing all the time
set splitright                        " Prefer windows splitting to the right
set splitbelow                        " Prefer windows splitting to the bottom
set updatetime=1000                   " Make updates happen faster

set scrolloff=3
set sidescrolloff=5

set inccommand=split " Show :%s within a preview pane
"set list " :listchars

set mouse=n " Enable the mouse in normal (n) mode
set mousehide

set signcolumn=yes

set exrc
set secure
set cursorline
set gdefault " Use 'g' flag by default with :s/foo/bar/.
set hlsearch " Highlight search results.

set ignorecase " Make searching case insensitive
set wildignorecase
set smartcase " ... unless the query has capital letters.
set infercase " :help infercase

set incsearch " Incremental search.

set autoread " Automatically read files that have changed outside of vim

" Clipboard
" Always have the clipboard be the same as my regular clipboard
set clipboard+=unnamedplus

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Fix cursor not working within tmux
set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TODO(digia): Finalize moving plugins to lua/plugins
call plug#begin()

" General plugins
Plug '/usr/local/opt/fzf' "Plug '/usr/bin/fzf'
Plug 'junegunn/fzf.vim'

" Styling plugins
Plug 'lifepillar/vim-solarized8'

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Style
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if &t_Co == 8 && $TERM !~# '^linux'
    " Allow color schemes to do bright colors without forcing bold.
    set t_Co=256
endif

" NOTE: Suggested https://github.com/lifepillar/vim-solarized8#troubleshooting
if exists('+termguicolors')
    set termguicolors
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" Column colors
let &colorcolumn="80,".join(range(120,999),",") " Join columns 120+ for danger color markers.
" let &colorcolumn="80" " Only show col 80

colorscheme solarized8_flat
set background=dark

" vimscript
func! NvimGps() abort
	return luaeval("require('nvim-gps').is_available()") ?
		\ luaeval("require('nvim-gps').get_location()") : ''
endf

set statusline=""
set statusline+=%<%f:%l:%v " filename:col:line/total lines
set statusline+=\ "
set statusline+=%h%m%r " help/modified/readonly
set statusline+=\ "
set statusline+=[%{&ft}] " filetype
" set statusline+=\ "
" set statusline+=%{NvimGps()}
set statusline+=%= " alignment group
set statusline+=\ "

hi StatusLine guifg=#839496 guibg=#073642
hi StatusLineNC guifg=#596f71 guibg=#073642

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Lua & Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" NOTE(digia): Plugins are managed within the `lua/plugins` lua module
lua require('init')

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Variables
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader="\<space>"

let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
let g:completion_trigger_keyword_length = 2
" Completion settings
" Use <Tab> and <S-Tab> to navigate through popup menu
" inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" imap <tab> <Plug>(completion_smart_tab)
" imap <s-tab> <Plug>(completion_smart_s_tab)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Check for documentation within the man files with a fallback to LSP
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    :lua vim.lsp.buf.hover()
  endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
inoremap <C-c> <Esc>

" Reload the _this_ configuration
nnoremap <leader><leader>r :source $MYVIMRC<CR>

" Reselect visual block after indent
vnoremap < <gv
vnoremap > >gv

nnoremap j gj
nnoremap k gk
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
nnoremap <c-h> <c-w>h

" Make windows to be basically the same size
nnoremap <leader>= <C-w>=
nnoremap <leader>+ :vertical resize +5<CR>
nnoremap <leader>- :vertical resize -5<CR>

" Use Y yank from cursor to end of line, as you'd expect
nnoremap Y y$

" Keep things centered when manipulating lines
"  * Remap n, to n -> zz -> zv
"  * Next, center, expand any folds
nnoremap n nzzzv
nnoremap N Nzzzv
"  * Create mark of z, perform J, go back to z marking line and column
nnoremap J mzJ`z

" Undo break points, no longer losing a whole insert but instead using break
" points which match stop characters.
" inoremap , ,<C-g>u
" inoremap . .<C-g>u
inoremap ! !<C-g>u
inoremap ? ?<C-g>u
" NOTE(digia): Testing if these stop characters are worth having 2021-08-08
" inoremap ; ;<C-g>u
" inoremap : :<C-g>u
" inoremap ( (<C-g>u
" inoremap ) )<C-g>u
" inoremap [ [<C-g>u
" inoremap ] ]<C-g>u

" Add movement to jumplist when greater than N lines
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

" Text movement
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv
" TODO(digia): Doesn't work with window navigation
" nnoremap <C-j> :m .+1<CR>==
" nnoremap <C-k> :m .-2<CR>==
" TODO(digia): Fix insert variation to go back into insert mode, currently
" leaves once the line movement is performed
inoremap <C-j> <esc>:m .+1<CR>==
inoremap <C-k> <esc>:m .-2<CR>==

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Void paste, or paste over text without losing current paste
vnoremap <leader>p "_dp

" Clear highlight
if has('win32')
  nmap <silent> <C-/> :nohl<CR>
else
  nmap <silent> <C-_> :nohl<CR>
endif

" For moving quickly up and down, goes to the first line above/below that
" isn't whitespace -- http://vi.stackexchange.com/a/213
nnoremap gj :let _=&lazyredraw<CR>:set lazyredraw<CR>/\%<C-R>=virtcol(".")<CR>v\S<CR>:nohl<CR>:let &lazyredraw=_<CR>
nnoremap gk :let _=&lazyredraw<CR>:set lazyredraw<CR>?\%<C-R>=virtcol(".")<CR>v\S<CR>:nohl<CR>:let &lazyredraw=_<CR>

" Run the last command
nnoremap <leader><leader>c :<up>

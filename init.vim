autocmd!
syntax on
filetype plugin indent on
let mapleader="\<space>"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:get_cache_dir(suffix)
  return resolve(expand(s:cache_dir . '/' . a:suffix))
endfunction

" Relative numbering
function! NumberToggle()
  if(&relativenumber == 1)
    set nornu
    set number
  else
    set rnu
  endif
endfunc

function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>m :call RenameFile()<cr>

function! OpenChangedFiles()
  only " Close all windows, unless they're modified
  let status = system('git status -s | grep "^ \?\(M\|A\|UU\)" | sed "s/^.\{3\}//"')
  let filenames = split(status, "\n")
  exec "edit " . filenames[0]
  for filename in filenames[1:]
    exec "sp " . filename
  endfor
endfunction
command! OpenChangedFiles :call OpenChangedFiles()

function! DerekFugitiveStatusLine()
  let status = fugitive#statusline()
  let trimmed = substitute(status, '\[Git(\(.*\))\]', '\1', '')
  let trimmed = substitute(trimmed, '\(\w\)\w\+\ze/', '\1', '')
  let trimmed = substitute(trimmed, '/[^_]*\zs_.*', '', '')
  if len(trimmed) == 0
    return ""
  else
    return '(' . trimmed[0:10] . ')'
  endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin()

Plug 'benmills/vimux'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-dispatch' " [Review when testing]
Plug 'tpope/vim-sleuth' " Auto detect indent style
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'scrooloose/syntastic'
Plug 'rstacruz/sparkup'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'FelikZ/ctrlp-py-matcher'
Plug 'christoomey/vim-tmux-navigator'
Plug 'altercation/vim-colors-solarized'
Plug 'MarcWeber/vim-addon-local-vimrc'
Plug 'vim-scripts/bufkill.vim'
Plug 'airblade/vim-gitgutter'

" Language specific
Plug 'hdima/python-syntax', { 'for': 'python' }
Plug 'mitsuhiko/vim-jinja', { 'for': 'jinja' }
Plug 'shawncplus/phpcomplete.vim', { 'for': 'php' }
Plug 'xsbeats/vim-blade', { 'for': ['php', 'blade'] }
Plug 'mustache/vim-mustache-handlebars', { 'for': ['mustache', 'handlebar'] }
Plug 'digitaltoad/vim-jade', { 'for': 'jade' }
Plug 'moll/vim-node', { 'for': 'javascript' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'jelera/vim-javascript-syntax', { 'for': 'javascript' }
Plug 'elzr/vim-json', { 'for': 'json' }
Plug 'othree/html5-syntax.vim', { 'for': 'html' }
Plug 'othree/html5.vim', { 'for': 'html' }
Plug 'mattn/emmet-vim', { 'for': 'html' }
Plug 'gregsexton/MatchTag', { 'for': 'html' }
Plug 'wavded/vim-stylus', { 'for': ['stylus', 'markdown'] }
Plug 'groenewege/vim-less', { 'for': ['less', 'scss', 'sass'] }
Plug 'groenewege/vim-less', { 'for': 'less' }
Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
Plug 'ap/vim-css-color', { 'for': 'css' }
Plug 'hail2u/vim-css3-syntax', { 'for': 'css' }
Plug 'tpope/vim-markdown', { 'for': 'markdown' }
Plug 'fatih/vim-go', { 'for': 'go' }

call plug#end()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set showcmd             " Show (partial) command in status line.
set showmatch           " Show matching brackets.
set showmode            " Show current mode.
set showtabline=2
set ruler               " Show the line and column numbers of the cursor.
set number              " Show the line numbers on the left side.
set formatoptions+=o    " Continue comment marker in new lines.
set textwidth=0         " Hard-wrap long lines as you type them.

set smarttab
set expandtab           " Insert spaces when TAB is pressed.

set tabstop=2           " Render TABs using this many spaces.
set shiftwidth=2        " Indentation amount for < and > commands.

set noerrorbells visualbell        " No beeps.
set modeline            " Enable modeline.
set esckeys             " Cursor keys in insert mode.
set linespace=0         " Set line-spacing to minimum.
set nojoinspaces        " Prevents inserting two spaces after punctuation on a join (J)

" More natural splits
set splitbelow          " Horizontal split below current.
set splitright          " Vertical split to right of current.

if !&scrolloff
  set scrolloff=3       " Show next 3 lines while scrolling.
endif
if !&sidescrolloff
  set sidescrolloff=5   " Show next 5 columns while side-scrolling.
endif
set display+=lastline
set nostartofline       " Do not jump to first character with page commands.

set hidden
set history=10000
set backup
set backupdir=/tmp,/var/tmp,~/tmp
set directory=/tmp,/var/tmp,~/tmp

set autoindent
set smartindent

set cursorline
set cmdheight=2

" Path/file expansion in colon-mode.
set wildmenu
set wildmode=list:longest
set wildchar=<TAB>
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store,*/.idea/*,*/tmp/*,*/vendor/*,*/node_modules/*,*/bower_components/*

set clipboard=unnamed
set autoread

set mouse=a
set mousehide

set ambiwidth=double

set hlsearch            " Highlight search results.
set ignorecase          " Make searching case insensitive
set smartcase           " ... unless the query has capital letters.
set incsearch           " Incremental search.
set gdefault            " Use 'g' flag by default with :s/foo/bar/.
set magic               " Use 'magic' patterns (extended regular expressions).

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
endif

" Tell Vim which characters to show for expanded TABs,
" trailing whitespace, and end-of-lines. VERY useful!
"if &listchars ==# 'eol:$'
  "set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
"endif

"set listchars=tab:▸\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
set listchars=tab:▸\ ,trail:⋅,extends:❯,precedes:❮
highlight SpecialKey ctermbg=none " make the highlighting of tabs less annoying
set invlist " toggle invisible characters
set showbreak=↪

nmap <leader>si :set invlist!<cr> " Toggle invisible characters
nmap <leader>sl :set list!<cr> " Toggle list showing

" Also highlight all tabs and trailing whitespace characters.
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$\|\t/

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Style
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux'
  set t_Co=256
endif

set guifont=Ubuntu\ Mono:h15
set encoding=utf-8
set guioptions-=T
set guioptions-=r                                         " turn off GUI right scrollbar
set guioptions-=L                                         " turn off GUI left scrollbar

" Cursor styles 
" Use a blinking upright bar cursor in Insert mode, a blinking block in normal
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

" Column colors
"let &colorcolumn=join(range(81,999),",") " Join columns 81+ for warning color markers. 
"let &colorcolumn="80,".join(range(120,999),",") " Join columns 120+ for danger color markers.
let &colorcolumn="80" " Only show col 80

set background=dark
colorscheme solarized

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" STATUS LINE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set statusline=%<%f\ %m%r%w\ %{DerekFugitiveStatusLine()}\ [%{&ft}]\ %*\ %=\ B:%n\ %*\ L:%l/%L[%P]\ %*\ C:%v\ %*\ [%b][0x%B]

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM AUTOCMDS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!

  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd! BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  "Autoindent with two spaces, always expand tabs
  autocmd! BufRead,BufNewFile,FileType ruby,haml,eruby,yaml,html,sass,scss,cucumber,blade,javascript,html.handlebars set ai sw=2 sts=2 et
  autocmd! BufRead,BufNewFile,FileType python,php set sw=4 sts=4 et

  autocmd! BufRead,BufNewFile *.sass,*.scss setfiletype sass

  autocmd! BufRead,BufNewFile *.md,*.mkd,*.markdown set ai formatoptions=tcroqn2 comments=n:&gt; filetype=markdown

  " Indent p tags
  autocmd FileType html,eruby if g:html_indent_tags !~ '\\|p\>' | let g:html_indent_tags .= '\|p\|li\|dt\|dd' | endif

  " Don't syntax highlight markdown because it's often wrong
  " autocmd! FileType mkd setlocal syn=off

  " Leave the return key alone when in command line windows, since it's used
  " to run commands there.
  autocmd! CmdwinEnter * :unmap <cr>
  autocmd! CmdwinLeave * :call MapCR()
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap j gj
nnoremap k gk

" Exit insert mode
inoremap kj <esc>

" Go back to previous buffer
nmap <c-e> :e#<cr>

" Clear search
nmap <silent> ,/ :nohlsearch<cr>

" Path to current files directory
cnoremap %% <c-R>=expand('%:h').'/'<cr>

" Edit file, starting in current directory
map <leader>e :e %%

nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
nnoremap <c-h> <c-w>h

" Hack becuase the proper way nnoremap <c-h> <c-w>h does not currently work in
" neovim
if has('nvim')
  nmap <bs> :<c-u>TmuxNavigateLeft<cr>
endif

" Toggle between normal and relative numbering.
nnoremap <leader>r :call NumberToggle()<cr>

" Reselect visual block after indent
vnoremap < <gv
vnoremap > >gv

" Make the directory of the file in the buffer
nmap <silent> ,md :!mkdir -p %:p:h<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CTRLP
map <C-b> :CtrlPBuffer<CR>
map <C-t> :CtrlPTag<CR>
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'r'
let g:ctrl_user_command = 'ag %s -i --nocolor --nogroup --hidden 
  \ --ignore .git
  \ --ignore .svn
  \ --ignore .hg
  \ --ignore .DS_Store
  \ --ignore "**/*.pyc"
  \ -g ""'
"let g:ctrlp_match_func = {'match': 'pymatcher#PyMatch'}

" NerdTree
" map <leader>n ;NERDTreeToggle<CR>
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=0
let NERDTreeShowLineNumbers=1
let NERDTreeChDirMode=0
let NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.git$','\.hg&', '\.pyc$']
nnoremap <F2> :NERDTreeToggle<CR>
nnoremap <F3> :NERDTreeFind<CR>

" Fugitive
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gp :Git push<CR>
nnoremap <silent> <leader>gw :Gwrite<CR>
nnoremap <silent> <leader>gr :Gremove<CR>
nnoremap <silent> <leader>gm :Gmove<CR>
nnoremap <silent> <leader>gm :Gedit<CR>

" python-syntax
let python_highlight_all = 1

" Syntastic
let g:syntastic_check_on_open = 1
let g:syntastic_mode_map = { 'passive_filetypes': ['sass'] }
let g:syntastic_javascript_checkers = ['jshint', 'jscs']
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'

" Vimux
map <leader>vp :VimuxPromptCommand<cr>
map <Leader>vz :VimuxZoomRunner<CR>
map <Leader>vl :VimuxRunLastCommand<CR>
map <Leader>vi :VimuxInspectRunner<CR>
map <Leader>vq :VimuxCloseRunner<CR>
map <Leader>vx :VimuxInterruptRunner<CR>

nmap <leader>tm :w\|:call VimuxRunCommand("clear; echo " . bufname("%") . "; NODE_ENV='test' mocha " . bufname("%"))<cr>
nmap <leader>ap :w\|:call VimuxRunCommand("clear; python -m unittest discover")<cr>
nmap <leader>tp :w\|:call VimuxRunCommand("clear; echo " . bufname("%") . "; ./venv/bin/nosetests --config test.cfg --nocapture " . bufname("%"))<cr>
nmap <leader>th :w\|:call VimuxRunCommand("clear; phpunit " . bufname("%"))<cr>
nmap <leader>st :w\|:Silent echo "phpunit" > test-commands<cr>
nmap <leader>s :w\|:Silent echo "vendor/bin/phpspec run %" > test-commands<cr> 
nmap <leader>ss :w\|:Silent echo "vendor/bin/phpspec run" > test-commands<cr>

" elzr/vim-json
let g:vim_json_syntax_conceal = 0 " Don't hide quotes in json files

" airblade/vim-gitgutter
nmap <leader>sg :GitGutterToggle<cr>
nmap <leader>sgh :GitGutterLineHighlightsToggle<cr>


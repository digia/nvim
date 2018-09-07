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

function! StrTrim(txt)
  return substitute(a:txt, '^\n*\s*\(.\{-}\)\n*\s*$', '\1', '')
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
"Plug 'tpope/vim-sleuth' " Auto detect indent style
"Plug 'scrooloose/syntastic'
" Plug 'benekastah/neomake' " Async syntastic
Plug 'rstacruz/sparkup'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'altercation/vim-colors-solarized'
Plug 'MarcWeber/vim-addon-local-vimrc'
Plug 'vim-scripts/bufkill.vim'
Plug 'airblade/vim-gitgutter'

Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree'

Plug 'ervandew/supertab'
Plug 'Yggdroot/indentLine'
" Plug 'Shougo/neocomplete.vim'
Plug 'jmcantrell/vim-virtualenv'
" Plug 'Valloric/YouCompleteMe'

" Language specific
" Plug 'tmhedberg/SimpylFold', { 'for': 'python' } " Better foldering in python
Plug 'hdima/python-syntax', { 'for': 'python' }
" Plug 'nvie/vim-flake8', { 'for': 'python' }
Plug 'FelikZ/ctrlp-py-matcher', { 'for': 'python' }
Plug 'vim-scripts/indentpython.vim', { 'for': 'python' }
" Plug 'davidhalter/jedi-vim', { 'for': 'python' }
Plug 'vheon/JediHTTP', { 'for': 'python' }
" Plug 'heavenshell/vim-jsdoc'

Plug 'shawncplus/phpcomplete.vim', { 'for': 'php' }
Plug 'xsbeats/vim-blade', { 'for': ['php', 'blade'] }
Plug 'mustache/vim-mustache-handlebars'
Plug 'digitaltoad/vim-jade', { 'for': ['jade', 'pug'] }
Plug 'moll/vim-node', { 'for': 'javascript' }
"Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'jelera/vim-javascript-syntax'
"Plug 'othree/yajs.vim', { 'for': 'javascript', 'tag': '1.6' }
Plug 'isRuslan/vim-es6', { 'for': 'javascript' }
"Plug 'heavenshell/vim-jsdoc', { 'for': 'javascript' } // Needs keybindings
Plug 'elzr/vim-json', { 'for': 'json' }
Plug 'othree/html5-syntax.vim', { 'for': ['html', 'blade'] }
Plug 'othree/html5.vim', { 'for': ['html', 'blade'] }
Plug 'mattn/emmet-vim'
Plug 'niftylettuce/vim-jinja', { 'for': ['jinja', 'njk'] }
Plug 'gregsexton/MatchTag', { 'for': ['html', 'blade'] }
Plug 'groenewege/vim-less', { 'for': ['less', 'scss', 'sass'] }
Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
Plug 'ap/vim-css-color', { 'for': 'css' }
Plug 'hail2u/vim-css3-syntax', { 'for': 'css' }
Plug 'godlygeek/tabular'
Plug 'gabrielelana/vim-markdown', { 'for': 'markdown' }
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'elixir-lang/vim-elixir', { 'for': 'elixir' }
Plug 'chr4/nginx.vim', { 'for': 'nginx' }
Plug 'posva/vim-vue', { 'for': 'vue' }

Plug 'rhysd/vim-grammarous', { 'for': ['text', 'markdown', 'html', 'blade', 'json'] }

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

" Plug 'ternjs/tern_for_vim', { 'for': 'javascript' }
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }

Plug 'w0rp/ale' " Async linting engine
Plug 'wellle/tmux-complete.vim'
" Plug 'fszymanski/deoplete-emoji'
Plug 'zchee/deoplete-jedi'

call plug#end()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set showcmd             " Show (partial) command in status line.
" Was causing lag in JS acceptance tests, really annoying when typing
"set showmatch           " Show matching brackets.
set showmode            " Show current mode.
set showtabline=1
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
"set cmdheight=2

" Path/file expansion in colon-mode.
set wildmenu
set wildmode=longest,list:longest
set wildchar=<TAB>
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store,*/.idea/*,*/tmp/*,*/node_modules/**,*/bower_components/**,**/venv/**,*.pyc

" NOTE(digia): 2018-04-22 The astrick register can be used for system level
" copy/paste which can be used within the ui using the middle mouse button.
" set clipboard=unnamed
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

set foldmethod=syntax
set foldlevel=99
" set nofoldenable

" Reduce the delay after pressing the leader key
set timeoutlen=350

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

set tags=tags

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Style
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux'
  set t_Co=256
endif

set guifont=Roboto\ Mono:h15
set encoding=utf-8
set guioptions-=T
set guioptions-=r                                         " turn off GUI right scrollbar
set guioptions-=L                                         " turn off GUI left scrollbar

" Column colors
"let &colorcolumn=join(range(81,999),",") " Join columns 81+ for warning color markers. 
"let &colorcolumn="80,".join(range(120,999),",") " Join columns 120+ for danger color markers.
let &colorcolumn="80" " Only show col 80

set background=dark
colorscheme solarized

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" STATUS LINE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set statusline=%<%f\ %m%r%w\ %{DerekFugitiveStatusLine()}\ [%{&ft}]\ %*\ %=\ B:%n\ %*\ L:%l/%L[%P]\ %*\ C:%v\ %*\ [%b][0x%B]
set statusline=%<%f\ %m%r%w\ [%{&ft}]\ %*\ %=\ B:%n\ %*\ L:%l/%L[%P]\ %*\ C:%v\ %*\ [%b][0x%B]
set laststatus=2

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
  autocmd! BufRead,BufNewFile *.md,*.mkd,*.markdown set spell ai formatoptions=tcroqn2 comments=n:&gt; filetype=markdown
  autocmd! BufRead,BufNewFile,FileType php set sw=4 sts=4 et
  autocmd! BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79 expandtab autoindent fileformat=unix filetype=python
  autocmd! BufRead,BufNewFile *.sass,*.scss setfiletype sass
  autocmd! BufNewFile,BufRead,FileType html,css,sass,scss,blade,cucumber,yaml,html.handlebars,javascript,pug,htmldjango set tabstop=2 softtabstop=2 shiftwidth=2 fileformat=unix

  " Indent p tags
  "autocmd FileType html,eruby if g:html_indent_tags !~ '\\|p\>' | let g:html_indent_tags .= '\|p\|li\|dt\|dd' | endif

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

" Path to current files directory
cnoremap %% <c-R>=expand('%:h').'/'<cr>

" Edit, starting in current directory
" map <leader>e :e %%
map <leader>n :e %%

" Move to the next buffer
nmap <leader>l :bnext<CR>
" Move to the previous buffer
"nmap <c-e> :e#<cr>
nmap <leader>h :bprevious<CR>

" Clear search
nmap <silent> ,/ :nohlsearch<cr>

nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
nnoremap <c-h> <c-w>h

" Hack becuase the proper way nnoremap <c-h> <c-w>h does not currently work in
" neovim
if has('nvim')
  nmap <silent> <bs> :<c-u>TmuxNavigateLeft<cr>
endif

" Toggle between normal and relative numbering.
nnoremap <leader>r :call NumberToggle()<cr>

" Reselect visual block after indent
vnoremap < <gv
vnoremap > >gv

" Make the directory of the file in the buffer
nmap <silent> ,md :!mkdir -p %:p:h<CR>

" Move lines up and down
" http://vim.wikia.com/wiki/Moving_lines_up_or_down_in_a_file
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Point neovim to python
let g:python3_host_prog = '/usr/bin/python'

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
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=0
let NERDTreeShowLineNumbers=1
let NERDTreeChDirMode=0
let NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.git$','\.hg&', '\.pyc$']
nnoremap <F2> :NERDTreeToggle<CR>
nnoremap <F3> :NERDTreeFind<CR>

" Tagbar
nnoremap <F4> :TagbarToggle<CR>

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
let g:syntastic_mode_map = {
    \ 'mode': 'passive',
    \ 'active_filetypes': [],
    \ 'passive_filetypes': ['sass'] }
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_html_tidy_exec = 'tidy5'
let g:syntastic_javascript_checkers = ['eslint']
map <leader>sc :SyntasticCheck<cr>

" Vimux
map <leader>vp :VimuxPromptCommand<cr>
map <Leader>vz :VimuxZoomRunner<CR>
map <Leader>vl :VimuxRunLastCommand<CR>
map <Leader>vi :VimuxInspectRunner<CR>
map <Leader>vq :VimuxCloseRunner<CR>
map <Leader>vx :VimuxInterruptRunner<CR>

nmap <leader>tj :w\|:call VimuxRunCommand("clear; echo " . bufname("%") . "; NODE_ENV='test' mocha " . bufname("%"))<cr>
" nmap <leader>tj :w\|:call VimuxRunCommand(\"clear; echo \" . bufname(\"%\") . \"; NODE_ENV='test' mocha-grey-patch \" . bufname(\"%\"))<cr>
nmap <leader>tji :w\|:call VimuxRunCommand("clear; echo " . bufname("%") . "; NODE_ENV='test' mocha --inspect-brk " . bufname("%"))<cr>
nmap <leader>ap :w\|:call VimuxRunCommand("clear; python -m unittest discover")<cr>
" nmap <leader>tp :w\|:call VimuxRunCommand('clear; echo ' . bufname("%") . '; ./venv/bin/nosetests --config test.cfg --nocapture ' . bufname('%'))<cr>
nmap <leader>tp :w\|:call VimuxRunCommand("clear; echo " . bufname("%") . "; ./venv/bin/py.test " . bufname("%"))<cr>
nmap <leader>td :w\|:call VimuxRunCommand("clear; echo " . bufname("%") . "; ./manage.py test " . bufname("%"))<cr>
nmap <leader>th :w\|:call VimuxRunCommand("clear; phpunit " . bufname("%"))<cr>
nmap <leader>sr :w\|:call VimuxRunCommand("clear; ~/bin/run-script " . bufname("%"))<cr>
nmap <leader>st :w\|:Silent echo "phpunit" > test-commands<cr>
nmap <leader>s :w\|:Silent echo "vendor/bin/phpspec run %" > test-commands<cr>
nmap <leader>ss :w\|:Silent echo "vendor/bin/phpspec run" > test-commands<cr>

" elzr/vim-json
let g:vim_json_syntax_conceal = 0 " Don't hide quotes in json files

" airblade/vim-gitgutter
nmap <leader>sg :GitGutterToggle<cr>
nmap <leader>sgh :GitGutterLineHighlightsToggle<cr>

" 'Yggdroot/indentLine'
let g:indentLine_color_term = 0
let g:indentLine_faster = 1

" 'heavenshell/vim-jsdoc'
" FIXME(digia): Set keybindings

" 'plasticboy/vim-markdown
" https://github.com/plasticboy/vim-markdown
let g:vim_markdown_folding_style_pythonic = 1
let g:vim_markdown_fenced_languages = ['csharp=cs', 'c++=cpp', 'viml=vim', 'bash=sh', 'ini=dosini', 'nginx=nginx']

" 'Valloric/YouCompleteMe'
" let g:ycm_add_preview_to_completeopt = 1
" let g:ycm_autoclose_preview_window_after_insertion = 1
" let g:ycm_autoclose_preview_window_after_completion=1
" let g:ycm_collect_identifiers_from_tags_files = 1 " Let YCM read tags from Ctags file
" let g:ycm_use_ultisnips_completer = 1 " Default 1, just ensure
" let g:ycm_seed_identifiers_with_syntax = 1 " Completion for programming language's keyword
" let g:ycm_complete_in_comments = 0 " Completion in comments
" let g:ycm_complete_in_strings = 0 " Completion in string
" map <leader>gt :YcmCompleter GoToDefinitionElseDeclaration<cr>

" 'heavenshell/vim-jsdoc'
" https://github.com/heavenshell/vim-jsdoc
let g:jsdoc_allow_input_prompt = 1
let g:jsdoc_input_description = 1
let g:jsdoc_underscore_private = 1
let g:jsdoc_enable_es6 = 1
let g:jsdoc_access_descriptions = 1
nmap <silent> <leader>jd <Plug>(jsdoc)


" TESTING
" https://www.reddit.com/r/node/comments/6jfb68/vim_nodejs_completion/
" enhance YCM JS completion with tern's smarts
autocmd FileType javascript setlocal omnifunc=tern#Complete
set completeopt-=preview

" Python with virtualenv support
" https://realpython.com/blog/python/vim-and-python-a-match-made-in-heaven/
" python3 << EOF
" import os
" import sys
" if 'VIRTUAL_ENV' in os.environ:
"   project_base_dir = os.environ['VIRTUAL_ENV']
"   activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
"   # execfile(activate_this, dict(__file__=activate_this))
"   exec(compile(open(activate_this, "rb").read(), activate_this, 'exec'), globals, locals)
" EOF

" 'davidhalter/jedi-vim'


" Cursor styles
" Use a blinking upright bar cursor in Insert mode, a blinking block in normal
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1
" " insert mode - line
"let &t_SI .= "\<Esc>[5 q"
" "replace mode - underline
"let &t_SR .= "\<Esc>[4 q"
" "common - block
"let &t_EI .= "\<Esc>[3 q"

" if exists('$TMUX')
"     let &t_SI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
"     let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
" else
"     let &t_SI = "\e[5 q"
"     let &t_EI = "\e[2 q"
" endif

" let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
" let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"

" http://vim.wikia.com/wiki/Configuring_the_cursor
" Tmux details: http://reza.jelveh.me/2011/09/18/zsh-tmux-vi-mode-cursor
if &term =~ "xterm\\|rxvt"
  " echo 'xterm|rxvt'
  " Insert
  let &t_SI  = "\<Esc>]12;gray\x7"
  let &t_SI .= "\<Esc>[3 q"
  " Normal
  let &t_EI  = "\<Esc>]12;green\x7"
  let &t_EI .= "\<Esc>[2 q"
  autocmd VimLeave * silent !echo -ne "\033]112\007"
elseif &term =~ "screen-it\\|tmux\\|gnome-terminal"
  " echo 'screen-it|tmux|gnome-terminal'
  " Insert
  let &t_SI  = "\<Esc>Ptmux;\<Esc>\<Esc>]12;gray\x7\<Esc>\\"
  let &t_SI .= "\<Esc>Ptmux;\<Esc>\<Esc>[3 q\<Esc>\\"
  " Normal
  let &t_EI  = "\<Esc>Ptmux;\<Esc>\<Esc>]12;gray\x7\<Esc>\\"
  let &t_EI .= "\<Esc>Ptmux;\<Esc>\<Esc>[2 q\<Esc>\\"
  autocmd VimLeave * silent !printf "\033Ptmux;\033\033]12;gray\007\033\\"
endif

" Fix cursor not working within tmux
set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20

" Shougo/deoplete.nvim
" https://github.com/Shougo/deoplete.nvim
"
" TESTING: 2017-12-1
"
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#ternjs#docs = 1
let g:deoplete#sources#ternjs#filetypes = [
  \ 'jsx',
  \ 'javascript.jsx',
  \ 'vue',
  \ 'js',
  \ 'mjs'
  \ ]

" Use tern_for_vim.
let g:tern#command = ["tern"]
let g:tern#arguments = ["--persistent"]

" ALE
" https://github.com/w0rp/ale
let g:ale_lint_on_text_changed = 'never'
let g:ale_fixers = {
\   'javascript': ['eslint'],
\   'markdown': ['markdownlint'],
\}

nmap <silent> <leader>lf <Plug>(ale_fix)
nmap <silent> <leader>lp <Plug>(ale_previous_wrap)
nmap <silent> <leader>ln <Plug>(ale_next_wrap)

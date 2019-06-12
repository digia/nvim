autocmd!
syntax on
filetype plugin indent on
let mapleader="\<space>"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin()

"Plug 'ctrlpvim/ctrlp.vim'
"Plug 'FelikZ/ctrlp-py-matcher'
Plug 'Shougo/denite.nvim'

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

Plug 'MarcWeber/vim-addon-local-vimrc'
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'altercation/vim-colors-solarized'
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh', }
Plug 'benizi/vim-automkdir'
Plug 'benmills/vimux'
Plug 'christoomey/vim-tmux-navigator'
Plug 'easymotion/vim-easymotion'
Plug 'editorconfig/editorconfig-vim'
Plug 'ervandew/supertab'
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'majutsushi/tagbar'
Plug 'matze/vim-move'
Plug 'rstacruz/sparkup'
Plug 'scrooloose/nerdtree'
" Plug 'sheerun/vim-polyglot' Conflicting with typescript auto complete
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch' " [Review when testing]
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-scripts/bufkill.vim'
Plug 'w0rp/ale' " Async linting engine
Plug 'wellle/tmux-complete.vim'

" Language specific
Plug 'hdima/python-syntax', { 'for': 'python' }
Plug 'jmcantrell/vim-virtualenv'
Plug 'mitsuhiko/vim-jinja', { 'for': 'jinja' }
Plug 'vheon/JediHTTP', { 'for': 'python' }
Plug 'vim-scripts/indentpython.vim', { 'for': 'python' }
" Plug 'zchee/deoplete-jedi'

Plug 'chr4/nginx.vim'

Plug 'elixir-lang/vim-elixir'

Plug 'fatih/vim-go', { 'for': 'go' }

Plug 'shawncplus/phpcomplete.vim', { 'for': 'php' }
Plug 'xsbeats/vim-blade', { 'for': ['php', 'blade'] }

Plug 'elzr/vim-json', { 'for': 'json' }

Plug 'gregsexton/MatchTag', { 'for': ['html', 'blade'] }
Plug 'othree/html5.vim', { 'for': ['html', 'blade'] }
Plug 'othree/html5-syntax.vim', { 'for': ['html', 'blade'] }

Plug 'hail2u/vim-css3-syntax', { 'for': 'css' }
Plug 'ap/vim-css-color', { 'for': 'css' }

Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
Plug 'groenewege/vim-less', { 'for': ['less', 'scss', 'sass'] }

Plug 'posva/vim-vue'

"Plug 'mattn/emmet-vim' ?

Plug 'cespare/vim-toml'

Plug 'mustache/vim-mustache-handlebars'
Plug 'jelera/vim-javascript-syntax'
" Plug 'othree/yajs.vim' Yello object keys :(
Plug 'digitaltoad/vim-jade', { 'for': ['jade', 'pug'] }
Plug 'moll/vim-node', { 'for': 'javascript' }
Plug 'isRuslan/vim-es6', { 'for': 'javascript' }


"Plug 'HerringtonDarkholme/yats.vim'
Plug 'leafgarland/typescript-vim'
Plug 'mhartington/nvim-typescript'

" TODO: Formalize tern solution
"Plug 'ternjs/tern_for_vim', { 'for': 'javascript' }
"Plug 'carlitux/deoplete-ternjs', { 'for': 'javascript', 'do': 'npm install -g tern' }

call plug#end()


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

function! StrTrim(txt)
  return substitute(a:txt, '^\n*\s*\(.\{-}\)\n*\s*$', '\1', '')
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
scriptencoding utf8
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

set noerrorbells " No beeps.
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
set backupdir=/tmp,~/tmp
set directory=/tmp,~/tmp
set undofile
set undodir=/tmp,~/tmp

set exrc " enable per-directory .vimrc files
set secure " disable unsafe commands in local .vimrc files

set autoindent
set smartindent

set cursorline

" Path/file expansion in colon-mode.
set wildmenu
set wildmode=longest,list:longest
set wildchar=<TAB>
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store,*/.idea/*,*/tmp/*,*/node_modules/**,*/bower_components/**,**/venv/**,*.pyc

" See thought Zp4ylImW3 for VIM clipboard explanation
set clipboard+=unnamed
set autoread

set mouse=a
set mousehide

set ambiwidth=double

set completeopt-=preview
set noshowmode " disable extraneous messages

set hlsearch " Highlight search results.
set ignorecase " Make searching case insensitive
set smartcase " ... unless the query has capital letters.
set infercase " :help infercase
set incsearch " Incremental search.
set diffopt=filler,vertical
set gdefault " Use 'g' flag by default with :s/foo/bar/.
set magic " Use 'magic' patterns (extended regular expressions).

set foldmethod=syntax
set foldlevel=99
" set nofoldenable

" Reduce the delay after pressing the leader key
set timeoutlen=350

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
endif

highlight SpecialKey ctermbg=none " make the highlighting of tabs less annoying
set listchars=tab:▸\ ,trail:⋅,extends:❯,precedes:❮
set invlist " toggle invisible characters
set showbreak=↪

set inccommand=split

set tags=tags

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

set guifont=Roboto\ Mono:h15
set encoding=utf-8
set guioptions-=T
set guioptions-=r " turn off GUI right scrollbar
set guioptions-=L " turn off GUI left scrollbar

" Column colors
"let &colorcolumn=join(range(81,999),",") " Join columns 81+ for warning color markers. 
"let &colorcolumn="80,".join(range(120,999),",") " Join columns 120+ for danger color markers.
let &colorcolumn="80" " Only show col 80

set background=dark
colorscheme solarized

set nomodeline

hi clear IncSearch
hi link IncSearch StatusLine
hi clear Search
hi link Search StatusLine

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" STATUS LINE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! LinterStatus() abort
  let l:counts = ale#statusline#Count(bufnr(''))

  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors

  " return l:counts.total == 0 ? '' : printf(' %d🔺 %d❌', all_non_errors, all_errors)
  return  printf(' %d🔺 %d❌', all_non_errors, all_errors)
endfunction
" set statusline=""
" set statusline+=%<%f
" set statusline+=\ %m%r%w\ [%{&ft}]\ %*\ %=\ B:%n\ %*\ L:%l/%L[%P]\ %*\ C:%v\ %*\ [%b][0x%B]

hi StatusLine guifg=#7FC1CA guibg=#556873
hi StatusLineNC guifg=#3C4C55 guibg=#556873
hi StatusLineError guifg=#DF8C8C guibg=#556873

set statusline=""
" set statusline+=\ "
" filename:col:line/total lines
set statusline+=%<%f:%l:%v
set statusline+=\ "
" help/modified/readonly
set statusline+=%h%m%r
set statusline+=\ "
set statusline+=[%{&ft}]
" alignment group
set statusline+=%=
" lsp status
set statusline+=%{LanguageClient_statusLine()}
" start error highlight group
" set statusline+=%#StatusLineError#
" errors from w0rp/ale
set statusline+=%{LinterStatus()}
" reset highlight group
" set statusline+=%#StatusLine#
set statusline+=\ "

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
  autocmd! BufRead,BufNewFile *.md,*.mkd,*.markdown set spell textwidth=80 ai formatoptions=tcroqn2 comments=n:&gt; filetype=markdown
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

nmap <leader>si :set invlist!<cr> " Toggle invisible characters
nmap <leader>sl :set list!<cr> " Toggle list showing

" search visual selection
vnoremap // y/<C-R>"<CR>

if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading\ -S
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" Save cursor pos, splits, etc.
autocmd FileWritePre *.* silent! mkview
autocmd FileReadPre *.* silent! loadview

" Exit insert mode
inoremap kj <esc>

" Path to current files directory
cnoremap %% <c-R>=expand('%:h').'/'<cr>

" Edit, starting in current directory
map <leader>n :e %%

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
" nnoremap <leader>r :call NumberToggle()<cr>

" Reselect visual block after indent
vnoremap < <gv
vnoremap > >gv

" Make the directory of the file in the buffer
nmap <silent> <leader>md :!mkdir -p %:p:h<CR>

" Use vim-move instead
" Move lines up and down
" http://vim.wikia.com/wiki/Moving_lines_up_or_down_in_a_file
" nnoremap <A-j> :m .+1<CR>==
" nnoremap <A-k> :m .-2<CR>==
" inoremap <A-j> <Esc>:m .+1<CR>==gi
" inoremap <A-k> <Esc>:m .-2<CR>==gi
" vnoremap <A-j> :m '>+1<CR>gv=gv
" vnoremap <A-k> :m '<-2<CR>gv=gv

" Paste toggle
set pastetoggle=<Insert>

" Point neovim to python
let g:python3_host_prog = '/usr/bin/python'

" Cursor styles
" Use a blinking upright bar cursor in Insert mode, a blinking block in normal
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1

" Changing cursor shape per mode; https://gist.github.com/andyfowler/1195581#gistcomment-993604
" 1 or 0 -> blinking block
" 2 -> solid block
" 3 -> blinking underscore
" 4 -> solid underscore
if exists('$TMUX')
    " tmux will only forward escape sequences to the terminal if surrounded by a DCS sequence
    let &t_SI .= "\<Esc>Ptmux;\<Esc>\<Esc>[5 q\<Esc>\\"
    let &t_EI .= "\<Esc>Ptmux;\<Esc>\<Esc>[2 q\<Esc>\\"
    autocmd VimLeave * silent !echo -ne "\033Ptmux;\033\033[0 q\033\\"
else
    let &t_SI .= "\<Esc>[5 q"
    let &t_EI .= "\<Esc>[2 q"
    autocmd VimLeave * silent !echo -ne "\033[0 q"
endif

" Fix cursor not working within tmux
set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Shougo/Denite: https://github.com/Shougo/denite.nvim
"
" Denite is a dark powered plugin for Neovim/Vim to unite all interfaces. It
" can replace many features or plugins with its interface. It is like a fuzzy
" finder, but is more generic. You can extend the interface and create the
" sources.
"
" Reset 50% winheight on window resize
augroup deniteresize
  autocmd!
  autocmd VimResized,VimEnter * call denite#custom#option('default', 'winheight', winheight(0) / 2)
augroup end

call denite#custom#option('default', { 'prompt': '❯' })

"call denite#custom#var('file_rec', 'command', ['rg', '--files', '--glob', '!.git'])
call denite#custom#var('file_rec', 'command', ['ag', '--follow', '--nocolor', '--nogroup', '-u', '-g', ''])
call denite#custom#alias('source', 'file_rec/git', 'file_rec')
call denite#custom#var('file_rec/git', 'command', ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])

" ripgrep
call denite#custom#var('grep', 'command', ['rg'])
call denite#custom#var('grep', 'default_opts', ['--hidden', '--vimgrep', '--smart-case'])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])

" ag
"call denite#custom#source('grep', 'matchers', ['matcher_regexp'])
"call denite#custom#var('grep', 'command', ['ag'])
"call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep']) ? smartcase ?

call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

call denite#custom#map('insert', '<Esc>', '<denite:enter_mode:normal>', 'noremap')
call denite#custom#map('insert', '<C-v>', '<denite:do_action:vsplit>', 'noremap')
"call denite#custom#map('normal', '<Esc>', '<NOP>', 'noremap') ? Do nothing when escape is pressed in normal mode
call denite#custom#map('normal', '<C-v>', '<denite:do_action:vsplit>', 'noremap')
call denite#custom#map('normal', 'dw', '<denite:delete_word_after_caret>', 'noremap')

call denite#custom#map('normal', '<C-n>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('normal', '<C-p>', '<denite:move_to_previous_line>', 'noremap')
call denite#custom#map('insert', '<C-n>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-p>', '<denite:move_to_previous_line>', 'noremap')

nnoremap <C-p> :<C-u>DeniteProjectDir file_rec/git<CR>
nnoremap <C-o> :<C-u>DeniteProjectDir file_rec<CR>
nnoremap <C-b> :<C-u>Denite buffer -mode=normal<CR>
" nnoremap <leader><Space>s :<C-u>DeniteBufferDir buffer<CR> ?
nnoremap <leader>8 :<C-u>DeniteCursorWord grep:. -mode=normal<CR>
"nnoremap <leader>/ :DeniteProjectDir -buffer-name=grep -default-action=quickfix grep:::!<CR> ? quickfix ?
nnoremap <leader>/ :<C-u>DeniteProjectDir grep:. -mode=normal<CR>
nnoremap <leader><Space>/ :<C-u>DeniteBufferDir grep:. -mode=normal<CR>
nnoremap <leader>p :<C-u>DeniteBufferDir file_rec/git<CR>
nnoremap <leader>r :<C-u>Denite -resume -cursor-pos=+1<CR>
"nnoremap <leader>lr :<C-u>Denite references -mode=normal<CR> ?

call denite#custom#option('_', 'highlight_mode_insert', 'CursorLine')
call denite#custom#option('_', 'highlight_matched_range', 'None')
call denite#custom#option('_', 'highlight_matched_char', 'CursorLine')

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

" testing
" https://www.reddit.com/r/node/comments/6jfb68/vim_nodejs_completion/
" enhance ycm js completion with tern's smarts
" autocmd filetype javascript setlocal omnifunc=tern#complete

" Fugitive
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>

" airblade/vim-gitgutter
if exists('&signcolumn')  " Vim 7.4.2201
  set signcolumn=yes
else
  let g:gitgutter_sign_column_always = 1
endif

" python-syntax
let python_highlight_all = 1

" Vimux
map <leader>vp :VimuxPromptCommand<cr>
map <Leader>vz :VimuxZoomRunner<CR>
map <Leader>vl :VimuxRunLastCommand<CR>
map <Leader>vi :VimuxInspectRunner<CR>
map <Leader>vq :VimuxCloseRunner<CR>
map <Leader>vx :VimuxInterruptRunner<CR>

" nmap <leader>tj :w\|:call VimuxRunCommand("clear; echo " . bufname("%") . "; NODE_ENV='test' mocha " . bufname("%"))<cr>
" nmap <leader>tj :w\|:call VimuxRunCommand(\"clear; echo \" . bufname(\"%\") . \"; NODE_ENV='test' mocha-grey-patch \" . bufname(\"%\"))<cr>
" nmap <leader>ap :w\|:call VimuxRunCommand("clear; python -m unittest discover")<cr>
" nmap <leader>tp :w\|:call VimuxRunCommand('clear; echo ' . bufname("%") . '; ./venv/bin/nosetests --config test.cfg --nocapture ' . bufname('%'))<cr>
" nmap <leader>tp :w\|:call VimuxRunCommand("clear; echo " . bufname("%") . "; ./venv/bin/py.test " . bufname("%"))<cr>
" nmap <leader>td :w\|:call VimuxRunCommand("clear; echo " . bufname("%") . "; ./manage.py test " . bufname("%"))<cr>
" nmap <leader>th :w\|:call VimuxRunCommand("clear; phpunit " . bufname("%"))<cr>
" nmap <leader>sr :w\|:call VimuxRunCommand("clear; ~/bin/run-script " . bufname("%"))<cr>
" nmap <leader>st :w\|:Silent echo "phpunit" > test-commands<cr>
" nmap <leader>s :w\|:Silent echo "vendor/bin/phpspec run %" > test-commands<cr>
" nmap <leader>ss :w\|:Silent echo "vendor/bin/phpspec run" > test-commands<cr>

" elzr/vim-json
let g:vim_json_syntax_conceal = 0 " Don't hide quotes in json files

" 'Yggdroot/indentLine'
let g:indentLine_color_term = 0
let g:indentLine_faster = 1

" 'plasticboy/vim-markdown
" https://github.com/plasticboy/vim-markdown
let g:vim_markdown_folding_style_pythonic = 1
let g:vim_markdown_fenced_languages = ['csharp=cs', 'c++=cpp', 'viml=vim', 'bash=sh', 'ini=dosini', 'nginx=nginx']

" editorconfig/editorconfig-vim
let g:EditorConfig_core_mode = 'external_command'
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" Shougo/deoplete.nvim
" https://github.com/Shougo/deoplete.nvim
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#auto_complete_start_length = 1
" let g:deoplete#auto_complete_delay = 50
let g:deoplete#sources#ternjs#docs = 1

" Use tern_for_vim.
" let g:tern#command = ["tern"]
" let g:tern#arguments = ["--persistent"]

" ALE
" https://github.com/w0rp/ale
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_save = 1
let g:ale_lint_on_enter = 1
let g:ale_fixers = {
  \ 'javascript': ['eslint'],
  \ 'typescript': ['tslint']
  \}

" https://github.com/w0rp/ale/blob/master/doc/ale-typescript.txt
let g:ale_linters_ignore = {
  \ 'typescript': ['tslint', 'eslint']
  \}

" let g:ale_sign_error = '>>' Default
let g:ale_sign_error = '❌'
" let g:ale_sign_warning = '--' Default
let g:ale_sign_warning = '🔺'

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

nmap <silent> <leader>lf <Plug>(ale_fix)
nmap <silent> <leader>lp <Plug>(ale_previous_wrap)
nmap <silent> <leader>ln <Plug>(ale_next_wrap)

" let g:tsuquyomi_completion_detail = 1
" autocmd FileType typescript nmap <buffer> <leader>d : <C-u>echo tsuquyomi#hint()<Cr>

" HerringtonDarkholme/yats.vim: https://github.com/HerringtonDarkholme/yats.vim
"
" Syntax for TypeScript
let g:yats_host_keyword = 1

" mhartington/nvim-typescript: https://github.com/mhartington/nvim-typescript
" nvim language service plugin for typescript
let g:nvim_typescript#type_info_on_hold = 0
let g:nvim_typescript#javascript_support = 1
let g:nvim_typescript#diagnostics_enable = 0 " ALE handles linting errors
" let g:nvim_typescript#max_completion_detail = 100
nnoremap <buffer> <silent> <leader>tt :TSType<CR>
nnoremap <buffer> <silent> <leader>td :TSDoc<CR>
nnoremap <buffer> <silent> <leader>tdd :TSTypeDef<CR>
nnoremap <buffer> <silent> <leader>tdp :TSDefPreview<CR>
nnoremap <buffer> <silent> <leader>tr :TSRefs<CR>
nnoremap <buffer> <silent> <leader>ti :TSImport<CR>

" easymotion/vim-easymotion
map <leader>e <Plug>(easymotion-prefix)

let g:EasyMotion_do_shade = 0

hi EasyMotionTarget ctermfg=1 cterm=bold,underline
hi link EasyMotionTarget2First EasyMotionTarget
hi EasyMotionTarget2Second ctermfg=1 cterm=underline

" incsearch
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

" incsearch-easymotion
map / <Plug>(incsearch-easymotion-/)
map ? <Plug>(incsearch-easymotion-?)
map g/ <Plug>(incsearch-easymotion-stay)

" javascript functions
autocmd! BufNewFile,BufRead,FileType javascript,typescript nmap <leader>rt :call VimuxRunCommand("clear; echo " . bufname("%") . "; npm run test " . bufname("%"))<cr>

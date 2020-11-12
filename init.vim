autocmd!
syntax on
filetype plugin indent on
let mapleader="\<space>"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin()

"Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh', }
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'

Plug '/usr/local/opt/fzf'
"Plug '/usr/bin/fzf'
Plug 'junegunn/fzf.vim'

Plug 'MarcWeber/vim-addon-local-vimrc'
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'

" NOTE(2020-05-15): Testing out better 24 bit color support with vim-solarized8
" Plug 'altercation/vim-colors-solarized'
Plug 'lifepillar/vim-solarized8'

Plug 'benizi/vim-automkdir'
Plug 'easymotion/vim-easymotion'
Plug 'editorconfig/editorconfig-vim'
Plug 'ervandew/supertab'
Plug 'haya14busa/incsearch.vim'
Plug 'majutsushi/tagbar'
Plug 'matze/vim-move'
Plug 'scrooloose/nerdtree'

" NOTE(2020-05-15): Support for checking if files changed on focus events
" https://github.com/tmux-plugins/vim-tmux-focus-events
Plug 'tmux-plugins/vim-tmux-focus-events'

" NOTE(2020-01-20): Testing nerdcommenter instead of vim-commentary due to
" FatBoyXPC suggestion in #laravel-offtopic
"
" NOTE(2020-01-20): Testing caw.vim instead of vim-commentary due to
" dshoreman suggestion in #laravel-offtopic

" https://github.com/preservim/nerdcommenter
Plug 'preservim/nerdcommenter'

Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'vim-scripts/bufkill.vim'
Plug 'dense-analysis/ale' " Async linting engine
Plug 'wellle/tmux-complete.vim'

Plug 'junegunn/vim-easy-align'

Plug 'AndrewRadev/splitjoin.vim'

" Language specific
" Plug 'jmcantrell/vim-virtualenv'
Plug 'mitsuhiko/vim-jinja', { 'for': 'jinja' }
" Plug 'vheon/JediHTTP', { 'for': 'python' }
" Plug 'vim-scripts/indentpython.vim', { 'for': 'python' }
Plug 'chr4/nginx.vim'
Plug 'elixir-lang/vim-elixir'
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'shawncplus/phpcomplete.vim', { 'for': 'php' }
Plug 'gregsexton/MatchTag', { 'for': ['html', 'blade'] }
Plug 'othree/html5.vim', { 'for': ['html', 'blade'] }
Plug 'othree/html5-syntax.vim', { 'for': ['html', 'blade'] }
Plug 'hail2u/vim-css3-syntax', { 'for': 'css' }
Plug 'ap/vim-css-color', { 'for': 'css' }
Plug 'moll/vim-node'
Plug 'isRuslan/vim-es6'
Plug 'leafgarland/typescript-vim'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'amadeus/vim-mjml'
Plug 'digitaltoad/vim-jade', { 'for': ['jade', 'pug'] }
Plug 'sheerun/vim-polyglot'

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Style
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux'
  set t_Co=256
endif

if (has("termguicolors"))
  set termguicolors
endif

set guifont=Roboto\ Mono:h15
set encoding=utf-8
set guioptions-=T
set guioptions-=r " turn off GUI right scrollbar
set guioptions-=L " turn off GUI left scrollbar

" Column colors
let &colorcolumn="80,".join(range(120,999),",") " Join columns 120+ for danger color markers.
"let &colorcolumn="80" " Only show col 80

" NOTE(digia): Suggested https://github.com/lifepillar/vim-solarized8#troubleshooting
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" Not sure this is doing anything; see hi StatusLine
let g:solarized_statusline="normal"

set background=dark
colorscheme solarized8_flat

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LSP
"
" NOTE: This needs to happen after setting up styles, not sure why...
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
lua require'nvim_lsp'.tsserver.setup{ on_attach=require'completion'.on_attach }
lua require'nvim_lsp'.pyls.setup{ on_attach=require'completion'.on_attach }
lua require'nvim_lsp'.html.setup{ on_attach=require'completion'.on_attach }
lua require'nvim_lsp'.cssls.setup{ on_attach=require'completion'.on_attach }
lua require'nvim_lsp'.bashls.setup{ on_attach=require'completion'.on_attach }
" lua require'nvim_lsp'.gopls.setup{ on_attach=require'completion'.on_attach }

" autocmd BufEnter * lua require'completion'.on_attach() " Attach with all buffers

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

" Replace unicode punctuation with ASCII
" https://github.com/machuga/dotfiles/blob/master/init.vim
function! ReplaceUnicodePunctuationCharacters()
    let typo = {}
    let typo["“"] = '"'
    let typo["”"] = '"'
    let typo["‘"] = "'"
    let typo["’"] = "'"
    let typo["–"] = '--'
    let typo["—"] = '---'
    let typo["…"] = '...'
    :exe ":%s/".join(keys(typo), '\|').'/\=typo[submatch(0)]/ge'
endfunction
command! ReplaceUnicodePunctuationCharacters :call ReplaceUnicodePunctuationCharacters()

" Check for documentation within the man files with a fallback to LSP
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    :lua vim.lsp.buf.hover()
  endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
scriptencoding utf8
set showcmd             " Show (partial) command in status line.

" Was causing lag in JS acceptance tests, really annoying when typing
set showmatch           " Show matching brackets.

set showtabline=1
set ruler               " Show the line and column numbers of the cursor.
set number              " Show the line numbers on the left side.
set rnu
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
set pumheight=15

set wildmenu " Path/file expansion in colon-mode.
"set wildmode=longest,list:longest
set wildmode=list:longest,full
set wildchar=<TAB>
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store,*/.idea/*,*/tmp/*,*/node_modules/**,*/bower_components/**,**/venv/**,*.pyc

" https://github.com/chemzqm/vimrc/blob/master/general.vim
set complete+=k " Scan with the dictionary
set complete-=t " Don't scan tags
set completeopt=menuone,noinsert,noselect
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

" See thought Zp4ylImW3 for VIM clipboard explanation
set clipboard+=unnamed
set autoread

set mouse=a
set mousehide

set ambiwidth=double

set noshowmode " disable extraneous messages

set hlsearch " Highlight search results.
set ignorecase " Make searching case insensitive
set wildignorecase
set smartcase " ... unless the query has capital letters.
set infercase " :help infercase
set incsearch " Incremental search.
set diffopt=filler,vertical
set gdefault " Use 'g' flag by default with :s/foo/bar/.
set magic " Use 'magic' patterns (extended regular expressions).

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=50

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
  " return  printf(' %d🔺 %d❌', all_non_errors, all_errors)
  return  printf(' W:%d E:%d', all_non_errors, all_errors)
endfunction
" set statusline=""
" set statusline+=%<%f
" set statusline+=\ %m%r%w\ [%{&ft}]\ %*\ %=\ B:%n\ %*\ L:%l/%L[%P]\ %*\ C:%v\ %*\ [%b][0x%B]

" hi StatusLine guifg=#7FC1CA guibg=#556873
hi StatusLine guifg=#839496 guibg=#073642
hi StatusLineNC guifg=#596f71 guibg=#073642
" hi StatusLineNC guifg=#3C4C55 guibg=#556873
" hi StatusLineError guifg=#DF8C8C guibg=#556873

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
"set statusline+=%{LanguageClient_statusLine()}

" NOTE(digia): 2020-08-13 Trying out having coc status in statusline
"set statusline+=%{coc#status()}
" set statusline+=%{coc#status()}%{get(b:,'coc_current_function','')}
set statusline+=\ "

set statusline+=%{LinterStatus()}

"set statusline+=\ \ POWER\ MODE!!!\ Combo\:\ 9001
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

  autocmd! BufRead,BufNewFile,FileType php set sw=4 sts=4 et
  autocmd! BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=80 expandtab autoindent fileformat=unix filetype=python
  autocmd! BufRead,BufNewFile *.sass,*.scss setfiletype sass
  autocmd! BufNewFile,BufRead,FileType html,css,sass,scss,blade,cucumber,yaml,html.handlebars,javascript,pug,htmldjango set tabstop=2 softtabstop=2 shiftwidth=2 fileformat=unix

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
" inoremap kj <esc> ctrl-c should be more than sufficient with caplock being CTRL
inoremap <C-c> <Esc>
"inoremap <C-]> <C-c>

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

nnoremap <leader>+ :vertical resize +5<CR>
nnoremap <leader>- :vertical resize -5<CR>

" Hack becuase the proper way nnoremap <c-h> <c-w>h does not currently work in
" neovim
if has('nvim')
  nmap <silent> <bs> :<c-u>TmuxNavigateLeft<cr>
endif

" Reselect visual block after indent
vnoremap < <gv
vnoremap > >gv

" Make the directory of the file in the buffer
nmap <silent> <leader>md :!mkdir -p %:p:h<CR>

" Paste toggle
set pastetoggle=<Insert>

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

" Trigger `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
        \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif

" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <silent> gd :lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gi :lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gr :lua vim.lsp.buf.references()<CR>
nnoremap <silent> grr :lua vim.lsp.buf.rename()<CR>
nnoremap <silent> gh :lua vim.lsp.buf.hover()<CR>
nnoremap <silent> ga :lua vim.lsp.buf.code_action()<CR>
" nnoremap <leader>vsh :lua vim.lsp.buf.signature_help()<CR>

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

" FZF
" https://github.com/junegunn/fzf.vim
"
" References:
" * https://www.reddit.com/r/neovim/comments/3oeko4/post_your_fzfvim_configurations/
" * https://github.com/zenbro/dotfiles/blob/master/.nvimrc
" * https://github.com/euclio/vimrc/blob/master/plugins.vim
" * https://github.com/erkrnt/awesome-streamerrc/blob/master/ThePrimeagen/init.vim

"let g:fzf_nvim_statusline = 0
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }

command! -bang -nargs=? -complete=dir ProjectFiles
      \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'source': 'rg --files --hidden --follow --glob "!.git/*"', 'options': ['--info=inline']}), <bang>0)

" Clear highlight
if has('win32')
  nmap <C-/> :nohl<CR>
else
  nmap <C-_> :nohl<CR>
endif

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

let g:fzf_action = {
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit'
  \ }

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" All files within the project following .gitignore rules
nnoremap <silent> <C-p> :ProjectFiles<CR>
" All files within git index or working branch
nnoremap <silent> <leader>p :GFiles<CR>
" All files within CWD
nnoremap <silent> <leader>o :FZF<CR>
nnoremap <silent> <leader>/ :execute 'RG ' . input('RG/')<CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>h :History<CR>
" gh as in git history for the current buffer
nnoremap <silent> <leader>gh :BCommits<CR>

imap <C-x><C-f> <plug>(fzf-complete-file-ag)
imap <C-x><C-l> <plug>(fzf-complete-line)
" Need a dictionary for this to work propery /usr/share/dict/words
"imap <C-x><C-w> <plug>(fzf-complete-word)

augroup fzf
  autocmd!
  autocmd! FileType fzf

  " Tweaks visuals of fzf split
  autocmd FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup END


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
set signcolumn=yes
autocmd FileType tagbar,nerdtree setlocal signcolumn=no

" python-syntax
let python_highlight_all = 1

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

" Yggdroot/indentLine
let g:indentLine_color_term = 0
let g:indentLine_faster = 1

" editorconfig/editorconfig-vim
let g:EditorConfig_core_mode = 'external_command'
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" Shougo/echodoc.vim
let g:echodoc_enable_at_startup=1
"let g:echodoc#type="virtual"

" ALE
" https://github.com/w0rp/ale
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_save = 1
let g:ale_lint_on_enter = 1

let g:ale_fixers = {
  \ 'javascript': ['eslint'],
  \ 'typescript': ['eslint']
  \}

let g:ale_linters = {
\  'javascript': ['eslint'],
\  'typescript': ['eslint'],
\}

" https://github.com/w0rp/ale/blob/master/doc/ale-typescript.txt
let g:ale_linters_ignore = {
  \ 'typescript': ['tslint']
  \}

let g:ale_sign_column_always = 1
" let g:ale_sign_error = '>>' " Default
"let g:ale_sign_error = '❌'
" let g:ale_sign_warning = '--' " Default
"let g:ale_sign_warning = '🔺'

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s'

nmap <silent> <leader>af <Plug>(ale_fix)
nmap <silent> <leader>ap <Plug>(ale_previous_wrap)
nmap <silent> <leader>an <Plug>(ale_next_wrap)

" HerringtonDarkholme/yats.vim: https://github.com/HerringtonDarkholme/yats.vim
" Syntax for TypeScript
let g:yats_host_keyword = 1

" easymotion/vim-easymotion
map <leader>e <Plug>(easymotion-prefix)
" let g:EasyMotion_do_shade = 0
" hi EasyMotionTarget ctermfg=1 cterm=bold,underline
" hi link EasyMotionTarget2First EasyMotionTarget
" hi EasyMotionTarget2Second ctermfg=1 cterm=underline

" incsearch
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

" junegunn/vim-easy-align -- align text, specifically markdown tables
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" preservim/nerdcommenter
" https://github.com/preservim/nerdcommenter#default-mappings

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Do not create the default mappings since they're <leader> prefixed
let g:NERDCreateDefaultMappings = 0

" map gcc <plug>NERDCommenterComment
map gcc <plug>NERDCommenterToggle
map gcn <plug>NERDCommenterNested
map gci <plug>NERDCommenterInvert
map gcy <plug>NERDCommenterYank
map gc$ <plug>NERDCommenterToEOL
map gcA <plug>NERDCommenterAppend
map gcu <plug>NERDCommenterUncomment
map gcm <plug>NERDCommenterMinimal
map gcs <plug>NERDCommenterSexy


" javascript functions
autocmd! BufNewFile,BufRead,FileType javascript,typescript nmap <leader>rt :call VimuxRunCommand("clear; echo " . bufname("%") . "; npm run --silent test " . bufname("%"))<cr>

" php functions
autocmd! BufNewFile,BufRead,FileType php setlocal commentstring=//\ %s


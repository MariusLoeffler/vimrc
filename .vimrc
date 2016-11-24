"-------------------------------------------------------------------------------
"                        ~/.vimrc: VIM CONFIGURATION FILE
"-------------------------------------------------------------------------------

"------------------------------ `:set` commands --------------------------------
" {{{1

" file encoding vim displays {{{2
set encoding=utf-8
" }}}2

" file encoding vim writes to file {{{2
set fileencoding=utf-8
" }}}2

" settings for vim folding {{{2
set foldmethod=syntax
set foldcolumn=4
" }}}2

" show line numbers {{{2
set number
set relativenumber
" }}}2

" no idea what this does {{{2
" TODO: look it up
set iminsert=0
" }}}2

" highlight current search {{{2
set hlsearch
" }}}2

" incremental search {{{2
set incsearch
" }}}2

" options for case sensitivity {{{2
" (with these settings vim's search is case-insensitive if we search only for
" lower case characters and case-sensitive when at least one upper case
" character is included)
set ignorecase
set smartcase
" }}}2

" number of terminal colors {{{2
set t_Co=256
" }}}2

" preferred position when opening a split {{{2
set splitbelow
set splitright
" }}}2

" changes to the grep program vim uses {{{2
set grepprg=grep\ -rnH\ --exclude='.*.swp'\ --exclude='*~'\ --exclude=tags\ $*
" }}}2

" key for paste mode {{{2
set pastetoggle=<F12>
" }}}2

" highlight the current line {{{2
set cursorline
" }}}2

" highlight the column with the currently set textwidth + 1 {{{2
set colorcolumn=+1
" }}}2

" some options for vim diff mode {{{2
" (always vertical splits, insert filler lines where the files differ)
set diffopt=vertical,filler
" }}}2

" work with a dark background {{{2
set background=dark
" }}}2

" settings for spell checking {{{2
" turn on spell-checking globally and set the languages the spell-checker uses
set nospell
set spelllang=en_us
" TODO: download de dic
",de_de
" }}}2

" place yanked text into the global system clipboard {{{2
set clipboard=unnamed,unnamedplus
" }}}2

" turn of vi compatibility and make vim "behave in a useful way" {{{2
set nocompatible
" }}}2

" set the default width of the text (=hard wrapping) {{{2
" this setting is overwritten for different filetypes below
set textwidth=80
" }}}2

" vim default for formatoptions is tcq, with `+=a` vim reformats the paragraph
" every time a line has changed
" set formatoptions+=a
" }}}2

" break a line at characters specified in 'breakat' {{{2
" (e.g. word boundaries) rather than fitting in any character
set linebreak
" }}}2

" enable the use of hidden buffers {{{2
set hidden
" }}}2

" automatically save the buffer when using commands like :make and :next {{{2
set autowrite
" }}}2

" string to filter out compiler warnings and display only errors {{{2
set errorformat^=%-G%f:%l:%n:\ warning:%m " gcc
" set errorformat=%f:%l:%c:%m " latex compiler (doesn't work correctly)
" }}}2

" wildmenu configuration {{{2
" This makes tab-completion in vim's command line fancier and behave more like
" bash. It prints a list of possible completions and completes to the longest
" possible string. Pressing <Tab> again it cycles through the possible
" completions
if has("wildmenu")
  set wildchar=<Tab>
  set wildmode=longest:list,full " print a list of possible completions
  " set wildmenu " this would put completions into the line powerline is in
  set wildignore+=*.a,*.o " ignore some filetypes when completing
  set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
  set wildignore+=.DS_Store,.git,.hg,.svn
  set wildignore+=*~,*.swp,*.tmp
endif
" }}}2

" always round indent to multiple of 'shiftwidth' {{{2
set shiftround
" }}}2

" configure characters to show for tabs and EOLs when `:set list` is on {{{2
set listchars=tab:▸\ ,eol:¬
" }}}2

" default indentation setting: 4 spaces {{{2
" Drew Neil: keep the three settings at the same value and switch between tabs
" and spaces by changing expandtab(=only spaces)/noexpandtab(=only tabs)
set tabstop=4      " Number of spaces that a <Tab> in the file counts for
set softtabstop=4  " Number of spaces that a <Tab> is when using <Tab>/<BS>
set shiftwidth=4   " Number of spaces >> and << indent with
set expandtab      " use tabs(off) or spaces(on) exclusively for indentation
" }}}2

if has("autocmd")
      au InsertEnter *
              \ if v:insertmode == 'i' |
              \   silent execute "!gnome-terminal-cursor-shape.sh ibeam" |
              \ elseif v:insertmode == 'r' |
              \   silent execute "!gnome-terminal-cursor-shape.sh underline" |
              \ endif
          au InsertLeave * silent execute "!gnome-terminal-cursor-shape.sh block"
              au VimLeave * silent execute "!gnome-terminal-cursor-shape.sh block"
endif
"}}}1
"-------------------------------------------------------------------------------

"--------------------------- functions/`:command`s -----------------------------
" {{{1

" function that prompts for indentation width and method (tabs/spaces) {{{2
command! SetIndentation call SetIndentation()
function! SetIndentation()

  call indent_guides#disable()
  call inputsave()

  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')

  call inputrestore()
  if l:tabstop > 0
    let &l:tabstop     = l:tabstop
    let &l:softtabstop = l:tabstop
    let &l:shiftwidth  = l:tabstop
  endif

  call inputsave()
  let l:which = input('indent with (t)abs/(s)paces = ')
  call inputrestore()

  if l:which == 't'
    let &l:expandtab = 0
  elseif l:which == 's'
    let &l:expandtab = 1
  endif

  call indent_guides#enable()
  call SummarizeIndentation()
endfunction
" }}}2

" Function to print out indentation information {{{2
command! SumIndent call SummarizeIndentation()
function! SummarizeIndentation()
  try
    echohl ModeMsg
    echo 'current indentation settings: '
    echon 'tabstop='.&l:tabstop
    echon ' softtabstop='.&l:softtabstop
    echon ' shiftwidth='.&l:shiftwidth

    if &l:expandtab
      echon ' expandtab (=spaces only)'
    else
      echon ' noexpandtab (=tabs only)'
    endif

  finally
    echohl None
  endtry
endfunction
"}}}2

" Command to turn off hard-wrapping of text {{{2
" To go back to hard wrapping at `val` just set textwidth to `val` again
command! -nargs=* SoftWrap setlocal tw=0 wrap linebreak nolist
" }}}2

" }}}1
"-------------------------------------------------------------------------------

"---------------------------------- pathogen -----------------------------------
" {{{1

" use pathogen to manage plugins
execute pathogen#infect()
execute pathogen#helptags()

" }}}
"-------------------------------------------------------------------------------

"------------------------------ `:let` commands --------------------------------
" {{{1

" set default tex flavor {{{2
" (other alternatives are 'plain' and 'context')
let g:tex_flavor='latex'
" }}}2

" display this at the beginning of a soft-wrapped line {{{2
let &showbreak='↳……|'
" }}}2

" define my leader key {{{2
let mapleader      = "\<Space>"
let maplocalleader = "\<Space>"
" }}}2

" }}}1
"-------------------------------------------------------------------------------

"------------------------------- abbreviations ---------------------------------
" {{{1

" some abbreviations
ab #b #!/bin/bash

" }}}1
"-------------------------------------------------------------------------------

"--------------------------------- `autocmd`s ----------------------------------
" {{{1

" Only do this part when vim was compiled with support for autocommands {{{2
if has("autocmd")
  " Enable filetype detection, plugin loading and indentation settings {{{3
  " depending on the filetype
  filetype plugin indent on
  " }}}3

  augroup filetype " {{{3
    " let vim know some filetypes {{{4
    autocmd! BufRead,BufNewFile *.cmake,*.cmake.in,CMakeLists.txt setfiletype cmake
    autocmd! BufRead,BufNewFile *.md                              setfiletype markdown
    " }}}4

    " set comment leader for various file types for commentary.vim {{{4
    autocmd FileType c,cpp,java,javascript,scala    setlocal commentstring=//\ %s
    autocmd FileType cmake,make,python,ruby,sh,text setlocal commentstring=#\ %s
    autocmd FileType fortran,xdefaults              setlocal commentstring=!\ %s
    autocmd FileType mail                           setlocal commentstring=>\ %s
    autocmd FileType tex                            setlocal commentstring=%\ %s
    autocmd FileType vim                            setlocal commentstring=\"\ %s
    " }}}4

    " set text wrapping, indentation, folding, and spellchecking depending on the filetype {{{4
    autocmd Filetype cpp,cmake,python setlocal   expandtab tabstop=4 softtabstop=4 shiftwidth=4 textwidth=80 foldmethod=syntax
    autocmd Filetype tex              setlocal   expandtab tabstop=4 softtabstop=4 shiftwidth=4 textwidth=0  errorformat=%f:%l:\ %m
    autocmd Filetype mail             setlocal   expandtab tabstop=4 softtabstop=4 shiftwidth=4 textwidth=72 spell nocindent noautoindent spell formatoptions+=a
    autocmd Filetype gitcommit        setlocal   expandtab tabstop=4 softtabstop=4 shiftwidth=4 textwidth=72 spell foldmethod=syntax
    autocmd Filetype vim              setlocal   expandtab tabstop=2 softtabstop=2 shiftwidth=2 textwidth=80 foldmethod=marker keywordprg=:help
    autocmd Filetype make             setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4 textwidth=80
    autocmd Filetype markdown         setlocal   expandtab tabstop=4 softtabstop=4 shiftwidth=4 textwidth=80 autoindent makeprg=pandoc\ %\ -o\ \/tmp\/%:r.pdf
  " }}}4
  augroup END
  " }}}3

  " fix broken spell checking when in latex mode {{{3
  autocmd BufRead,BufNewFile *.tex set spell
  autocmd BufRead,BufNewFile *.tex syntax spell toplevel
  " }}}3

  " resize splits when the window is resized {{{3
  autocmd VimResized * exe "normal! \<C-W>="
  " }}}3

  " augroup vimrc " {{{3
  "   autocmd BufReadPre * setlocal foldmethod=indent
  "   autocmd BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
  " augroup END
  " " }}}3

  " Change local current directory to the directory of the current file {{{3
  " We do not use "set autochdir" because this might lead to problems with some
  " plugins
  autocmd BufEnter * silent! lcd %:p:h
  " }}}3
endif
" }}}2

" }}}1
"-------------------------------------------------------------------------------

"---------------------- syntax highlighting/colorscheme ------------------------
" {{{1

" enable syntax highlighting and set default color scheme
syntax enable
colorscheme molokai

" }}}1
"-------------------------------------------------------------------------------

"---------------------------------- mappings -----------------------------------
" {{{1

" swapping keys for neo keyboard layout {{{2
"        key     functionality of key in standard mapping
nnoremap r       h
nnoremap H       H
nnoremap t       l
nnoremap L       L
nnoremap ü       t
nnoremap Ü       T
nnoremap ß       r
nnoremap ẞ       R

vnoremap r       h
vnoremap H       H
vnoremap t       l
vnoremap L       L
vnoremap ü       t
vnoremap Ü       T
vnoremap ß       r
vnoremap ẞ       R

onoremap r       h
onoremap H       H
onoremap t       l
onoremap L       L
onoremap ü       t
onoremap Ü       T
onoremap ß       r
onoremap ẞ       R
" }}}2

" yank rest of line (why is this not vim default?) {{{2
map Y y$
" }}}2

" always keep search pattern at the center of the screen {{{2
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz
nnoremap <silent> g# g#zz
" }}}2

" mappings for soft-wrapped lines {{{2
nmap <C-j> gj
nmap <C-k> gk
vmap <C-j> gj
vmap <C-k> gk
" }}}2

" start a new undo chain before using C-U and C-W in insert mode {{{2
" this way accidental deletions with these commands can be recovered
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>
" }}}2

" resize vertical splits {{{2
nnoremap <silent> <C-w>+ :exe "vertical resize " . (winwidth(0) * 3/2)<CR>
nnoremap <silent> <C-w>- :exe "vertical resize " . (winwidth(0) * 2/3)<CR>
" }}}2

" mappings on the F keys {{{2
map <F8> :nohlsearch <CR>
" }}}2

" clear the highlighting of `:set hlsearch` {{{2
nnoremap <silent> <C-L> :nohlsearch<CR><C-L>

" }}}1
"-------------------------------------------------------------------------------

"------------------------------ leader mappings --------------------------------
" {{{1

" some maps for working in diffmode {{{2
nnoremap <silent> <Leader>j ]c
nnoremap <silent> <Leader>k [c
nnoremap <silent> <Leader>du :diffupdate<CR>
" }}}2

" some maps for working with splits {{{2
nnoremap <silent> <Leader>w> :exe "vertical resize " . (winwidth(0) * 3/2)<CR>
nnoremap <silent> <Leader>w< :exe "vertical resize " . (winwidth(0) * 2/3)<CR>
nnoremap <silent> <Leader>w+ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <Leader>w- :exe "resize " . (winheight(0) * 2/3)<CR>
nnoremap <silent> <Leader>w= :wincmd =<CR>
nnoremap <silent> <Leader>ws :split<CR>
nnoremap <silent> <Leader>wv :vsplit<CR>
nnoremap <silent> <Leader>wq :q<CR>
nnoremap <silent> <Leader>ww :wincmd w<CR>
nnoremap <silent> <Leader>wk :wincmd k<CR>
nnoremap <silent> <Leader>wr :wincmd h<CR>
nnoremap <silent> <Leader>wt :wincmd l<CR>
nnoremap <silent> <Leader>wj :wincmd j<CR>
nnoremap <silent> <Leader>wK :wincmd K<CR>
nnoremap <silent> <Leader>wR :wincmd H<CR>
nnoremap <silent> <Leader>wT :wincmd L<CR>
nnoremap <silent> <Leader>wJ :wincmd J<CR>
nnoremap <silent> <Leader>wc :wincmd c<CR>
nnoremap <silent> <Leader>wx :wincmd x<CR>
nnoremap <silent> <Leader>wo :wincmd o<CR>
nnoremap <silent> <Leader>w} <C-w>}
" }}}2

" mappings for using ":make" to compile from within vim {{{2
nnoremap <Leader>ma :Make!<CR>
nnoremap <Leader>mc :Make! clean<CR>
nnoremap <Leader>mi :Make! install<CR>
nnoremap <Leader>mt :Make! test<CR>
nnoremap <Leader>oq :Copen<CR>
nnoremap <Leader>ol :lopen<CR>
" }}}2

" mapping for git-grepping the word under the cursor {{{2
" The upper version gives the focus to the quickfix list, the lower to the
" buffer the search string is first found in
" nmap <leader>gg :let @/="\\<<C-R><C-W>\\>"<CR>:set hls<CR>:silent Ggrep -w "<C-R><C-W>"<CR>:ccl<CR>:cw<CR><CR>
" vmap <leader>gg y:let @/=escape(@", '\\[]$^*.')<CR>:set hls<CR>:silent Ggrep -F "<C-R>=escape(@", '\\"#')<CR>"<CR>:ccl<CR>:cw<CR><CR>
nmap <leader>gg :let @/="\\<<C-R><C-W>\\>"<CR>:set hls<CR>:silent Ggrep -w "<C-R><C-W>"<CR>:ccl<CR>:cw<CR>:wincmd w<CR>
vmap <leader>gg y:let @/=escape(@", '\\[]$^*.')<CR>:set hls<CR>:silent Ggrep -F "<C-R>=escape(@", '\\"#')<CR>"<CR>:ccl<CR>:cw<CR>:wincmd w<CR>
" }}}2

" }}}1
"-------------------------------------------------------------------------------

"--------------------------------- diff mode -----------------------------------
" {{{1

"  no syntax highlighting, turn of cursorline because of gruvbox colorscheme
if &diff
  syntax off
  set nocursorline
else
  set cursorline
endif

" }}}1
"-------------------------------------------------------------------------------

"----------------------- settings/mappings for plugins -------------------------
" {{{1

" some settings for "vim-powerline"-plugin {{{2
set laststatus=2
" set showtabline=2
set noshowmode
" }}}2

" settings and mappings for "YouCompleteMe"-plugin {{{2

" settings {{{3
" let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
" }}}3

" mappings {{{3

" general Ycm commands {{{4
nnoremap <leader>ydd :YcmShowDetailedDiagnostic<CR>
nnoremap <leader>ydi :YcmDebugInfo<CR>
nnoremap <leader>yge :YcmDiags<CR>
nnoremap <leader>yrc :YcmForceCompileAndDiagnostics<CR>
nnoremap <leader>yrs :YcmRestartServer<CR>
nnoremap <leader>ytl :YcmToggleLogs<CR>
" }}}4

" YcmCompleter commands {{{4
nnoremap <leader>yfi :YcmCompleter FixIt<CR>

" provide two commands for GoTo: one close to vim tags mapping, one based on
" phonetics
nnoremap <leader>] :YcmCompleter GoTo<CR>
nnoremap <leader>ygt :YcmCompleter GoTo<CR>

" this one is intended for a quick access to the commands I didn't map
nnoremap <leader>yc :YcmCompleter<Space>

" }}}4

" }}}3

" }}}2

" mapping for "vim-trailing-whitespace"-plugin {{{2
nnoremap <silent> <Leader>fw :FixWhitespace<CR>
" }}}2

" some settings for "vim-indent-guides" plugin {{{2
let g:indent_guides_auto_colors = 1           " automatic coloring
let g:indent_guides_guide_size = 1            " bar is 1 cipher wide
let g:indent_guides_start_level = 2           " first bar is at level 1
let g:indent_guides_enable_on_vim_startup = 1 " show bars at startup
let g:indent_guides_color_change_percent = 5  " makes colors very dark
" }}}2

" mappings for the "tagbar" plugin {{{2
nmap <leader>tt :TagbarToggle<CR>
" }}}2

" settings for the "vim-rsi" plugin {{{2
" this fixes the problem with ä
let g:rsi_no_meta = 1
" }}}2

" mappings for "vim-tabularize" {{{2
nmap <leader>tb= :Tabularize /=<Cr>
vmap <leader>tb= :Tabularize /=<Cr>
nmap <leader>tb: :Tabularize /:<Cr>
vmap <leader>tb: :Tabularize /:<Cr>
nmap <leader>tb; :Tabularize /;<Cr>
vmap <leader>tb; :Tabularize /;<Cr>
nmap <leader>tb, :Tabularize /,<Cr>
vmap <leader>tb, :Tabularize /,<Cr>
nmap <leader>tb( :Tabularize /(<Cr>
vmap <leader>tb( :Tabularize /(<Cr>
nmap <leader>tb) :Tabularize /)<Cr>
vmap <leader>tb) :Tabularize /)<Cr>
nmap <leader>tb[ :Tabularize /[<Cr>
vmap <leader>tb[ :Tabularize /[<Cr>
nmap <leader>tb] :Tabularize /]<Cr>
vmap <leader>tb] :Tabularize /]<Cr>
nmap <leader>tb{ :Tabularize /{<Cr>
vmap <leader>tb{ :Tabularize /{<Cr>
nmap <leader>tb} :Tabularize /}<Cr>
vmap <leader>tb} :Tabularize /}<Cr>
nmap <leader>tb+ :Tabularize /+<Cr>
vmap <leader>tb+ :Tabularize /+<Cr>
nmap <leader>tb- :Tabularize /-<Cr>
vmap <leader>tb- :Tabularize /-<Cr>
" }}}2

" mappings for the "vim-clang-format" plugin {{{2
let g:clang_format#style_options = {
          \ "AccessModifierOffset" : -4,
          \ "AllowShortIfStatementsOnASingleLine" : "false",
          \ "AlwaysBreakTemplateDeclarations" : "false",
          \ "Standard" : "C++11",
          \ "BreakBeforeBraces" : "Stroustrup"}
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
autocmd FileType c,cpp,objc map <buffer><Leader>x <Plug>(operator-clang-format)
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>af :ClangFormatAutoToggle<CR>
" autocmd FileType c,cpp,objc ClangFormatAutoEnable
" }}}2

" }}}1
"-------------------------------------------------------------------------------

"----------------------------- experimental stuff ------------------------------
" {{{1

" experimental mappings for folding {{{2
" (I don't know if I like them yet)
" nnoremap <Leader>tf za
" nnoremap <Leader>tF zA
" }}}2

" experimental mappings for the tag stack {{{2
" (I don't know if I like them yet)
" map <Leader>] <C-]>zz
" map <Leader>[ <C-t>zz
" }}}2

" automatically save when vim looses its focus {{{2
" this is just left here for documentary reasons
" :autocmd FocusLost * silent! wa
" }}}2

" use '%%' to refer to current directory in command-mode {{{2
" cnoremap <expr> %% getcmdtype() == ':' ? fnameescape(expand('%:h')).'/' : '%%'
" }}}2

" some configuration and mappings for clang-check {{{2
" this was taken from the official clang website:
" http://clang.llvm.org/docs/HowToSetupToolingForLLVM.html
function! ClangCheckImpl(cmd)
  if &autowrite | wall | endif
  echo "Running " . a:cmd . " ..."
  let l:output = system(a:cmd)
  cexpr l:output
  cwindow
  let w:quickfix_title = a:cmd
  if v:shell_error != 0
    cc
  endif
  let g:clang_check_last_cmd = a:cmd
endfunction

function! ClangCheck()
  let l:filename = expand('%')
  if l:filename =~ '\.\(cpp\|cxx\|cc\|c\)$'
    call ClangCheckImpl("clang-check " . l:filename)
  elseif exists("g:clang_check_last_cmd")
    call ClangCheckImpl(g:clang_check_last_cmd)
  else
    echo "Can't detect file's compilation arguments and no previous clang-check invocation!"
  endif
endfunction

nmap <Leader>cc :call ClangCheck()<CR><CR>
" }}}2

" }}}1
"-------------------------------------------------------------------------------

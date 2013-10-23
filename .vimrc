" reset to vim-defaults
if &compatible          " only if not set before:
    set nocompatible      " use vim-defaults instead of vi-defaults (easier, more user friendly)
endif

" source cscope vim settings
" set nocscopeverbose
" source ~/.vim/plugin/cscope_maps.vim

" Pathogen plugin
execute pathogen#infect()

" color settings (if terminal/gui supports it)
if &t_Co > 2 || has("gui_running")
    syntax on          " enable colors
    set hlsearch       " highlight search (very useful!)
endif

" display settings
set t_Co=256
set background=dark     " enable for dark terminals
colorscheme wombat256mod
set scrolloff=2         " 2 lines above/below cursor when scrolling

" highlight columns > 80 chars long and trailing white spaces
hi OverLength ctermbg=88

" set number              " show line numbe231
set showmatch           " show matching bracket (briefly jump)
set matchtime=2         " show matching bracket for 0.2 seconds
set showmode            " show mode in status bar (insert/replace/...)
set showcmd             " show typed command in status bar
set ruler               " show cursor position in status bar
set title               " show file in titlebar
set wildmenu            " completion with menu
set wildmode=longest,list
set wildignore=*.o,*.obj,*.bak,*.exe,*.py[co],*.swp,*~,*.pyc,.svn
set laststatus=2        " use 2 lines for the status bar
set matchpairs+=<:>     " specially for html

" editor settings
set esckeys             " map missed escape sequences (enables keypad keys)
set ignorecase          " case insensitive searching
set smartcase           " but become case sensitive if you type uppercase characters
set smartindent         " smart auto indenting
set smarttab            " smart tab handling for indenting
set bs=indent,eol,start " Allow backspacing over everything in insert mode
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR> " Clear search highlighting with space
set tabstop=4           " number of spaces a tab counts for
set shiftwidth=4        " spaces for autoindents
"set expandtab           " turn a tabs into spaces

set fileformat=unix     " file mode is unix
"set fileformats=unix,dos    " only detect unix file format, displays that ^M with dos files

" system settings
set tags=./tags;/       " look for tags file from cwd up to root
set cpoptions-=o
set lazyredraw          " no redraws in macros
set confirm             " get a dialog when :q, :w, or :wq fails
set nobackup            " no backup~ files.
set directory=~/.vimswap,.,/tmp
set viminfo='20,\"500   " remember copy registers after quitting in the .viminfo file -- 20 jump links, regs up to 500 lines'
set hidden              " remember undo after quitting
set history=50          " keep 50 lines of command history
"set mouse=v             " use mouse in visual mode (not normal,insert,command,help mode


" paste mode toggle (needed when using autoindent/smartindent)
map <F10> :set paste<CR>
map <F11> :set nopaste<CR>
imap <F10> <C-O>:set paste<CR>
imap <F11> <nop>
set pastetoggle=<F11>

nmap <C-l> :bn<CR>
nmap <C-h> :bp<CR>

" Remove all trailing whitespaces
nnoremap <F4> :%s/\s\+$//e<CR>

" Use of the filetype plugins, auto completion and indentation support
filetype plugin indent on

" abbreviations (cab = commandline ab)
cab vsb vertical sb
cab vsn vertical sn
cab sgrep grep -R --include=\*.{c,h} * -e

" file type specific settings
if has("autocmd")
    " For debugging
    "set verbose=9

    " if bash is sh.
    let bash_is_sh=1

    " change to directory of current file automatically
    "autocmd BufEnter * lcd %:p:h

    " reset grouping (useful when we resource the configuration)
    if exists("#mysettings")
        au! mysettings FileType
    endif

    " Put these in an autocmd group, so that we can delete them easily.
    augroup mysettings
        au FileType xslt,xml,css,html,xhtml,javascript,sh,config,c,cpp,docbook set smartindent shiftwidth=4 softtabstop=4 expandtab
        au FileType c,cpp,java match OverLength /\%81v.\+\|\s\+$\|[^\t]\zs\t\+/
        au FileType tex set wrap shiftwidth=2 softtabstop=2 expandtab
        au FileType python set expandtab tabstop=4 softtabstop=4 shiftwidth=4 cinwords=if,elif,else,for,while,try,except,finally,def,class nosmartindent
        au FileType python match OverLength /\%80v.\+/
    augroup END

    augroup perl
        " reset (disable previous 'augroup perl' settings)
        au!

        au BufReadPre,BufNewFile
                    \ *.pl,*.pm
                    \ set formatoptions=croq smartindent shiftwidth=2 softtabstop=2 cindent cinkeys='0{,0},!^F,o,O,e' " tags=./tags,tags,~/devel/tags,~/devel/C
        " formatoption:
        "   t - wrap text using textwidth
        "   c - wrap comments using textwidth (and auto insert comment leader)
        "   r - auto insert comment leader when pressing <return> in insert mode
        "   o - auto insert comment leader when pressing 'o' or 'O'.
        "   q - allow formatting of comments with "gq"
        "   a - auto formatting for paragraphs
        "   n - auto wrap numbered lists
        "
    augroup END


    " Always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside
    " an event handler (happens when dropping a file on gvim).
    autocmd BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \   exe "normal g`\"" |
                \ endif

endif " has("autocmd")set wildmenu

" Delete buffer while keeping window layout (don't close buffer's windows).
" Version 2008-11-18 from http://vim.wikia.com/wiki/VimTip165
if v:version < 700 || exists('loaded_bclose') || &cp
    finish
endif
let loaded_bclose = 1
if !exists('bclose_multiple')
    let bclose_multiple = 1
endif

" Display an error message.
function! s:Warn(msg)
    echohl ErrorMsg
    echomsg a:msg
    echohl NONE
endfunction

" Command ':Bclose' executes ':bd' to delete buffer in current window.
" The window will show the alternate buffer (Ctrl-^) if it exists,
" or the previous buffer (:bp), or a blank buffer if no previous.
" Command ':Bclose!' is the same, but executes ':bd!' (discard changes).
" An optional argument can specify which buffer to close (name or number).
function! s:Bclose(bang, buffer)
    if empty(a:buffer)
        let btarget = bufnr('%')
    elseif a:buffer =~ '^\d\+$'
        let btarget = bufnr(str2nr(a:buffer))
    else
        let btarget = bufnr(a:buffer)
    endif
    if btarget < 0
        call s:Warn('No matching buffer for '.a:buffer)
        return
    endif
    if empty(a:bang) && getbufvar(btarget, '&modified')
        call s:Warn('No write since last change for buffer '.btarget.' (use :Bclose!)')
        return
    endif
    " Numbers of windows that view target buffer which we will delete.
    let wnums = filter(range(1, winnr('$')), 'winbufnr(v:val) == btarget')
    if !g:bclose_multiple && len(wnums) > 1
        call s:Warn('Buffer is in multiple windows (use ":let bclose_multiple=1")')
        return
    endif
    let wcurrent = winnr()
    for w in wnums
        execute w.'wincmd w'
        let prevbuf = bufnr('#')
        if prevbuf > 0 && buflisted(prevbuf) && prevbuf != w
            buffer #
        else
            bprevious
        endif
        if btarget == bufnr('%')
            " Numbers of listed buffers which are not the target to be deleted.
            let blisted = filter(range(1, bufnr('$')), 'buflisted(v:val) && v:val != btarget')
            " Listed, not target, and not displayed.
            let bhidden = filter(copy(blisted), 'bufwinnr(v:val) < 0')
            " Take the first buffer, if any (could be more intelligent).
            let bjump = (bhidden + blisted + [-1])[0]
            if bjump > 0
                execute 'buffer '.bjump
            else
                execute 'enew'.a:bang
            endif
        endif
    endfor
    execute 'bdelete'.a:bang.' '.btarget
    execute wcurrent.'wincmd w'
endfunction
command! -bang -complete=buffer -nargs=? Bclose call s:Bclose('<bang>', '<args>')
nnoremap <silent> <Leader>bd :Bclose<CR>

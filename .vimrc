syntax on
filetype plugin on
colorscheme antiphoton

highlight ColorColumn ctermbg=darkred ctermfg=white guibg=#FFD9D9
call matchadd('ColorColumn', '\%81v', 100)

let g:notes_path = '/Users/levi/notes/'

let g:netrw_banner          = 0
let g:netrw_liststyle       = 3
let g:netrw_browse_split    = 4
let g:netrw_altv            = 1
let g:netrw_winsize         = 25
let g:netrw_list_hide       = g:netrw_gitignore#Hide()
let g:netrw_list_hide      .= '\.sw[po]$'

set timeoutlen=1000
set ttimeoutlen=5
"set noesckeys

set mouse=
set laststatus=2
set hidden
set exrc
set noerrorbells
set belloff=esc
set number relativenumber
set backspace=start,eol,indent
set tabstop=4 shiftwidth=4 softtabstop=4 expandtab
set nocindent
"set indentexpr=

"ignore case, unless used
set ignorecase
set smartcase

"search
set path+=**
set wildmenu
set incsearch
set wildcharm=<Cz>
set wildmode=list:full
set wildignorecase

set splitbelow splitright
"set signcolumn=yes
"set pastetoggle=<F2>

"navigating text
set scrolloff=2
set matchpairs+=<:>

" fix ctrl-6 / ctrl-^ on norwegian mac
nnoremap § :e #<CR>

" simple drag visual block
vnoremap <xUp> xkP`[V`]
vnoremap <xDown> xp`[V`]
vnoremap <xRight> xpgvlolo
vnoremap <xLeft> xhPgvhoho
vnoremap > >gv
vnoremap < <gv

" simple delete surrounding
nnoremap <expr> ds DelSurr() .. ' '
fun! DelSurr()
    let l:char      = nr2char(getchar())
    let l:command   = "normal f".l:char."xF".l:char."x"
    if index(['w','p','t','s','b','B','{','}','[',']','(',')','<','>'], l:char) >= 0
        let l:command = "normal yi".l:char.(l:char=='t' ? 'b' : '')."va".l:char."p"
    endif
    let &operatorfunc = function('Execute', [l:command])
    return 'g@'
endfun

" simple add surrounding
vnoremap s :<c-u>call AddSurr((line("'<") < line("'>") ? 'line' : 'char'), "<", ">")<CR>
nmap S s$
nmap ss 0S
nnoremap s :set operatorfunc=AddSurr<CR>g@
fun! AddSurr(type,...)
    let l:open      = nr2char(getchar())
    let l:close     = get({'{':'}', '[':']', '(':')', '<':'>'},l:open,l:open)
    if l:open == 't'
        let l:open  = input('Tag: ')??'span'
        let l:close = '</'.split(l:open)[0].'>'
        let l:open  = '<'.l:open.'>'
    endif
    let l:command   = "normal g`".get(a:,1,"[")."ms"
    let l:command  .= "g`".get(a:,2,"]").(a:type=='line' ? "A\n":'a').l:close."\e"
    let l:command  .= "g`si".l:open.(a:type=='line' ? "\n":'')."\e"
    execute l:command
    let &opfunc     = function('Execute',[l:command])
endfun

" toggle markdown checkbox
nnoremap <leader>cc ma:s/\[ \]/[§]/e \| s/\[x\]/[ ]/e \| s/\[§\]/[x]/e<CR>`a
vnoremap <leader>cc :normal <leader>cc<CR>gv
" check
nnoremap <leader>cx ma:s/\[ \]/[x]/e<CR>`a
vnoremap <leader>cx :normal <leader>cx<CR>gv
" uncheck
nnoremap <leader>c<space> ma:s/\[x\]/[ ]/e<CR>`a
vnoremap <leader>c<space> :normal <leader>c<space><CR>gv

" manage buffers
nnoremap <leader>bd :bd<CR>
nnoremap <leader>bD :bd!<CR>
nnoremap gb :ls<CR>:b<Space>
nnoremap gB :ls<CR>:sb<Space>

fun! Execute(command,...)
    execute a:command
endfun

fun! GetAllNotes(ArgLead, CmdLine, CursorPos)
    return reverse( readdir(g:notes_path, {n -> n =~ '.\{-}'.a:ArgLead.'.\{-}\.md$'}) )
endfun

fun! EditNote(...)
    let note = g:notes_path.a:1
    if ! filereadable(note)
       let note = g:notes_path . strftime('%Y.%m.%d - '.a:1.'.md')
    endif
    execute "e ".note
    lcd %:h
endfun

command! -nargs=1 -complete=customlist,GetAllNotes Note call EditNote("<args>")
command! Vimrc e ~/.vimrc

fun! TrimWS()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

" ask to make dirs when not existent
augroup AutoMkdir
    autocmd!
    autocmd  BufNewFile  *  :call EnsureDirExists()
augroup END

function! EnsureDirExists ()
    let required_dir = expand("%:h")
    if !isdirectory(required_dir)
        call AskQuit("Directory '" . required_dir . "' doesn't exist.", "&Create it?")

        try
            call mkdir( required_dir, 'p' )
        catch
            call AskQuit("Can't create '" . required_dir . "'", "&Continue anyway?")
        endtry
    endif
endfunction

function! AskQuit (msg, proposed_action)
    if confirm(a:msg, "&Quit?\n" . a:proposed_action) == 1
        exit
    endif
endfunction

" plugins
vmap <expr> ++ VMATH_YankAndAnalyse()
nmap        ++ vip++

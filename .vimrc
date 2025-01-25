set nocompatible

" This is used to remove 'ESC[?4m' error whenever we open the vim
set keyprotocol=
let &term=&term
let colorscheme_name = ""

if v:version >= 900
    let colorscheme_name = "retrobox"
else
    let colorscheme_name = "murphy"
endif

" ##==[START]:(Vundle-Package-Manager):===================================
" Set the runtime path to include Vundle and initialize
" set rtp+=~/.vim/bundle/Vundle.vim
set rtp+=/u/dmanish/.vim/bundle/Vundle.vim
set rtp+=/u/dmanish/custompackages/packages/

" Download plug-ins to the ~/.vim/plugged/ directory
" call vundle#begin('~/.vim/plugged')
call vundle#begin('/u/dmanish/.vim/plugged')

" Let Vundle manage Vundle
Plugin 'VundleVim/Vundle.vim'

" Tome Plugin
Plugin 'laktak/tome'

" diffchar.vim
Plugin 'rickhowe/diffchar.vim.git'
call vundle#end()
" ##==[END]:(Vundle-Package-Manager):===================================

syntax on
se nu
" set ttymouse=xterm2 " Setting Mouse for Tmux
" set mouse=a " Enable mouse drag on window splits
set tabstop=4
set shiftwidth=4
set expandtab
set incsearch " Enable incremental search
set hlsearch " Enable highlight search



execute "colorscheme " . colorscheme_name

" colorscheme retrobox
set background=dark


" Setting Backspace Key
" Normal Mode
nnoremap <Char-0x07F> <BS>
noremap! <C-?> <C-h>

" Insert Mode
inoremap <Char-0x07F> <BS>

" Adding Ctrl + q for the visual block selection
nnoremap <C-q> <C-V>


let g:DiffUnit = 'Char'
let g:DiffColors = 3

windo set wrap
if &diff
    set wrap
    set linebreak
    " colorscheme darkblue 
    execute "colorscheme " . colorscheme_name
    set background=dark
    syntax off
endif

" Key Mapping for Diff Get and Diff Put
nnoremap <leader>do V:diffget<CR>
nnoremap <leader>dp V:diffput<CR>

" Set 'diffopt' option for diff mode
nnoremap <leader>df :set diffopt=filler,context:1<CR>

" Set command for :windo diffthis
nnoremap <leader>wd :windo diffthis<CR>

" Set command for :windo set wrap
nnoremap <leader>ww :windo set wrap<CR>

" Set command for :diffupdate
nnoremap <leader>du :diffupdate<CR>

" Set command for toggling line numbers
nnoremap <leader>ln :windo set number!<CR>

" Set command for toggling list
nnoremap <leader>hc :windo set list!<CR>

" Set command for toggling syntax
nnoremap <leader>lr :set relativenumber!<CR>

" Set command for opening file explorer
nnoremap <leader>fe :vsplit .<CR>

" Set command for spell check 
nnoremap <leader>sp :set spell!<CR>

" Set command for toggling syntax
nnoremap <leader>sy :syntax enable!<CR>

" Set command for toggling the display of trailing whitespace
nnoremap <leader>tw :match Error /\s\+$/<CR>

" Yank the selected text to the system clipboard
" vnoremap <leader>y :w !xclip -i -selection clipboard<CR>
" This copy the whole line
" vnoremap <leader>y :w !/u/dmanish/local/bin/xclip -i -selection clipboard<CR>
" Copy selecte text in visaul
" vnoremap <leader>y y:call system('/u/dmanish/local/bin/xclip -i -selection clipboard', @")<CR>
vnoremap <leader>y "*y
" Function to cycle through color schemes
function! CycleColorScheme()
    " Get a list of all color scheme files
    let color_scheme_files = globpath(&runtimepath, 'colors/*.vim')

    " Extract the color scheme names from the file names
    let color_schemes = map(split(color_scheme_files, '\n'), 'fnamemodify(v:val, ":t:r")')

    " Get the current color scheme index
    let color_scheme_index = index(color_schemes, g:colors_name)

    " Increment the index (wrapping around to the start of the list if necessary)
    let color_scheme_index = (color_scheme_index + 1) % len(color_schemes)

    " Set the color scheme to the new index
    execute 'colorscheme ' . color_schemes[color_scheme_index]

  " Display the current color scheme in the command line
    if exists('g:colors_name')
        echo 'Current color scheme: ' . g:colors_name
    else
        echo 'No color scheme set'
    endif


endfunction

" Mapping to call the function
nnoremap <leader>cs :call CycleColorScheme()<CR>

" Toogle the listchars to show the listchars=tab:▸▸⋮,eol:$ and space:. + toogle set list
noremap <leader>tl :set listchars=tab:▸▸⋮,eol:$,space:.,trail:~,extends:>,precedes:<<CR>:set list!<CR>

" Custom mappings help
let g:custom_map_help = {
    \ '\tl': 'Toggle listchars',
    \ '\do': 'Diff Get Single Line',
    \ '\dp': 'Diff Put Single Line',
    \ '\df': 'Set diffopt for diff mode',
    \ '\wd': 'Windo diffthis command',
    \ '\ww': 'Windo set wrap command',
    \ '\du': 'Diffupdate command',
    \ '\ln': 'Toggle line numbers',
    \ '\hc': 'Toggle list',
    \ '\lr': 'Toggle relative line numbers',
    \ '\fe': 'Open file explorer',
    \ '\sp': 'Toggle spell check',
    \ '\sy': 'Toggle syntax',
    \ '\tw': 'Toggle trailing whitespace',
    \ '\h': 'Show custom mappings help',
    \ '\cs': 'Cycle through color schemes',
    \ }

function! ShowCustomMapHelp()
    echo "Custom mappings:"
    for [key, desc] in items(g:custom_map_help)
        echo key . ": " . desc
    endfor

    " Display the current color scheme
    if exists('g:colors_name')
        echo 'Current color scheme: ' . g:colors_name
    else
        echo 'No color scheme set'
    endif
endfunction

" Set command for custom mappings help
nnoremap <leader>h :call ShowCustomMapHelp()<CR>

" Function to go to the parent bracket
function! GoToParentBracket()
    let openBrackets = ['[', '(', '{']
    let closeBrackets = [']', ')', '}']
    let stack = []
    let lineNum = line('.')
    let colNum = col('.')

    " Iterate backwards through lines and columns
    while lineNum > 0
        let lineContent = getline(lineNum)
        while colNum > 0
            let char = lineContent[colNum - 1]

            " Check if the character is a closing bracket
            if index(closeBrackets, char) != -1
                call add(stack, char)
            " Check if the character is an opening bracket
            elseif index(openBrackets, char) != -1
                if len(stack) > 0
                    let top = stack[-1]
                    " Check if the opening and closing brackets match
                    if (char == '[' && top == ']') || (char == '(' && top == ')') || (char == '{' && top == '}')
                        call remove(stack, -1)
                    else
                        " Found the parent bracket
                        call cursor(lineNum, colNum)
                        return
                    endif
                else
                    " Found the parent bracket
                    call cursor(lineNum, colNum)
                    return
                endif
            endif

            let colNum -= 1
        endwhile

        let lineNum -= 1
        let colNum = len(getline(lineNum))
    endwhile
endfunction

" Map %% to call the GoToParentBracket function
nnoremap %% :call GoToParentBracket()<CR>

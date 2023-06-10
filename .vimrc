vim9script

call plug#begin()
	Plug 'morhetz/gruvbox'
	Plug 'catppuccin/vim', { 'as': 'catppuccin'	} 
	Plug 'yegappan/lsp'
	Plug 'jiangmiao/auto-pairs'
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
	Plug 'hrsh7th/vim-vsnip'
	Plug 'hrsh7th/vim-vsnip-integ'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'vimsence/vimsence'
	Plug 'wakatime/vim-wakatime'
	Plug 'sheerun/vim-polyglot'
	Plug 'vimwiki/vimwiki'
	Plug 'makerj/vim-pdf'
	Plug 'ryanoasis/vim-devicons'
	Plug 'preservim/nerdtree'
	Plug 'Xuyuanp/nerdtree-git-plugin'
	Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
	#Plug '' TODO! magit support
call plug#end()

syntax on
filetype indent plugin on

set nu tgc scs ic si hls
set ts=4 sw=4
set fileencoding=utf-8 fileformat=unix
set background=dark
set signcolumn=yes
set colorcolumn=80
set timeoutlen=300
set wildmenu wildoptions=fuzzy
set hidden
set scrolloff=8
set lazyredraw
set nobackup
set nowritebackup
set noswapfile
set confirm
set nostartofline
set fillchars=eob:\ 

colo catppuccin_mocha
#colo gruvbox

# lsp settings
var servers = [
	{
		name: "clangd",
		filetype: ["c", "cpp"],
		path: "clangd",
		args: ['--background-index']
	},
	{
		name: "elixir LSP",
		filetype: ["elixir"],
		path: "elixir-ls"
	}
]

autocmd VimEnter * call LspAddServer(servers)

var lspOpts = {
	customCompletionKinds: true,
	completionKinds: {
		Text: "[Text] ",
		Method: "[Method] ",
		Function: "[Function] ",
		Constructor: "[Constructor] ",
		Field: "[Field] ",
		Variable: "[Variable] ",
		Class: "[Class] ",
		Interface: "[Interface] ",
		Module: "[Module] ",
		Property: "[Property] ",
		Unit: "[Unit] ",
		Value: "[Value] ",
		Enum: "[Enum] ",
		Keyword: "[Keyword] ",
		Snippet: "[Snippet] ",
		Color: "[Color] ",
		File: "[File] ",
		Reference: "[Reference] ",
		Folder: "[Folder] ",
		EnumMember: "[Enum Member] ",
		Constant: "[Constant] ",
		Struct: "[Struct] ",
		Event: "[Event] ",
		Operator: "[Operator] ",
		TypeParameter: "[Type Parameter] "
	},
	autoHighlight: false,
	autoHighlightDiags: true,
	autoPopulateDiags: true,
	diagSignErrorText: "x ",
	diagSignHintText: "H ",
	diagSignInfoText: "I ",
	diagSignWarningText: "! ",
	highlightDiagInline: true,
	showInlayHints: true,
	snippetSupport: true,
	noNewlineInCompletion: false,
	usePopupInCodeAction: true,
	completionTextEdit: false
}

autocmd VimEnter * call LspOptionsSet(lspOpts)

def LSPSetupServer()
	hi LspDiagLine ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE term=NONE cterm=NONE
	hi link LspDiagError	WarningMsg
	hi link LspDiagWarning	ModeMsg
	hi link LspDiagHint	Identifier
	hi link LspDiagInfo	LspDiagHint

	au CursorHold <buffer> silent! LspDiagCurrent

	iunmap <expr> <buffer> <CR>
	inoremap <expr> <buffer> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

	nmap <buffer> <leader>lgd <cmd>LspGotoDefinition<CR>
	nmap <buffer> <leader>lgR <cmd>LspGotoDeclaration<CR>
	nmap <buffer> <leader>lgi <cmd>LspGotoImpl<CR>
	nmap <buffer> <leader>lgt <cmd>LspGotoTypeDef<CR>
	nmap <buffer> <leader>lgr <cmd>LspRename<CR>

	nmap <buffer> <leader>lK <cmd>LspHover<CR>
enddef

def LSPOnCompletionDone()
	if pumvisible()
		pclose
	endif
enddef

au User LspAttached LSPSetupServer()
au CompleteDone * LSPOnCompletionDone()

## Airline
set noshowmode laststatus=2
g:airline#extensions#tabline#enabled = 0
g:airline_powerline_fonts = 1
#g:airline_theme = "base16_gruvbox_dark_hard"

### gvim
set guifont=FantasqueSansM\ Nerd\ Font:h10
set backspace=eol,start,indent
set t_Co=256
set antialias
set clipboard=unnamed
set guioptions=

# vimwiki
g:vimwiki_list = [{'path': '~/vimwiki/',
                   'syntax': 'markdown', 'ext': '.md'}]

###############################################
################ Keybinds #####################
###############################################

g:mapleader = "\<Space>"

nmap <silent> <leader><leader> 	:Files 						<CR>
nmap <silent> <leader>e 		:NERDTreeToggle				<CR>
nmap <silent> <leader>cc		:below make clean all run 	<CR>

imap <expr> <C-j>	 vsnip#expandable()	? '<Plug>(vsnip-expand)'				 : '<C-j>'
smap <expr> <C-j>	 vsnip#expandable()	? '<Plug>(vsnip-expand)'				 : '<C-j>'

# Expand or jump
imap <expr> <C-l>	 vsnip#available(1)	? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>	 vsnip#available(1)	? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

# Jump forward or backward
imap <expr> <Tab>	 vsnip#jumpable(1)	 ? '<Plug>(vsnip-jump-next)'			: '<Tab>'
smap <expr> <Tab>	 vsnip#jumpable(1)	 ? '<Plug>(vsnip-jump-next)'			: '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)	? '<Plug>(vsnip-jump-prev)'			: '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)	? '<Plug>(vsnip-jump-prev)'			: '<S-Tab>'

# Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
# See https://github.com/hrsh7th/vim-vsnip/pull/50
nmap				s	 <Plug>(vsnip-select-text)
xmap				s	 <Plug>(vsnip-select-text)
nmap				S	 <Plug>(vsnip-cut-text)
xmap				S	 <Plug>(vsnip-cut-text)

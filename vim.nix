{ pkgs, ... }:
let
  vim-hug-neovim-rpc = pkgs.vimUtils.buildVimPlugin {
    name = "vim-hug-neovim-rpc";
    src = pkgs.fetchFromGitHub {
      owner = "roxma";
      repo = "vim-hug-neovim-rpc";
      rev = "93ae38792bc197c3bdffa2716ae493c67a5e7957";
      sha256 = "0v7940h1sy8h6ba20qdadx82zbmi9mm4yij9gsxp3d9n94av8zsx";
    };
  };
in
  {
    environment.variables = { EDITOR = "vim"; };
    environment.systemPackages = with pkgs; [
      ((vim_configurable.override { python = python39 ; }) 
      .customize{
        name = "vim";
        vimrcConfig.plug.plugins = with pkgs.vimPlugins; [
            deoplete-nvim 
            nvim-yarp 
            vim-hug-neovim-rpc 
            neosnippet
            neosnippet-snippets
            vim-go 
            vim-nix 
            nord-vim
            vim-airline
            vim-airline-themes
        ];
        vimrcConfig.customRC = ''
          inoremap <C-c> <ESC>
          nnoremap Y y$
          filetype plugin indent on
          set ruler
          set encoding=utf-8
          set fileencodings=utf-8
          set number
          set expandtab
          set tabstop=4
          set shiftwidth=4
          set incsearch
          set hlsearch
          set ignorecase
          set smartcase
          set backspace=indent,eol,start
          set clipboard&
          set clipboard^=unnamedplus
          set display=lastline
          set pumheight=10
          set showmatch
          set matchtime=1
          set anti enc=utf-8
          set guifont=SourceHanCodeJP\ 15
          
          let g:deoplete#enable_at_startup = 1
          imap <expr><TAB>
          \ pumvisible() ? "\<C-n>" :
          \ neosnippet#expandable_or_jumpable() ?
          \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
          
          imap <C-k> <Plug>(neosnippet_expand_or_jump)
          smap <C-k> <Plug>(neosnippet_expand_or_jump)
          xmap <C-k> <Plug>(neosnippet_expand_target)
          if has('conceal')
            set conceallevel=2 concealcursor=niv
          endif
          
          set termguicolors
          colorscheme nord
          let g:airline_theme='deus'
          let g:airline_powerline_font=1
          
          syntax enable
        '';

      } 
      )];
    }

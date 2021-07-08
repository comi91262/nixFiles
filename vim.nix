{ pkgs, ... }:
let
  # vim-hug-neovim-rpc = pkgs.vimUtils.buildVimPlugin {
  #   name = "vim-hug-neovim-rpc";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "roxma";
  #     repo = "vim-hug-neovim-rpc";
  #     rev = "93ae38792bc197c3bdffa2716ae493c67a5e7957";
  #     sha256 = "0v7940h1sy8h6ba20qdadx82zbmi9mm4yij9gsxp3d9n94av8zsx";
  #   };
  # };
  vim-lsp-settings = pkgs.vimUtils.buildVimPlugin {  # fork mattn/vim-lsp-settings
    name = "vim-lsp-settings";
    src = pkgs.fetchFromGitHub {
      owner = "ykonomi";
      repo = "vim-lsp-settings";
      rev = "be128a66d54f21f955ca19a422e7a92506d81f99";
      sha256 = "sha256:0w1bl64n23n93lwy29bdxh09652j4mq1c47qzav8x24v5qdz7pdm";
    };
  };
  asyncomplete = pkgs.vimUtils.buildVimPlugin {
    name = "asyncomplete";
    src = pkgs.fetchFromGitHub {
      owner = "prabirshrestha";
      repo = "asyncomplete.vim";
      rev = "bb8a9924b703b3663d3be07d326055e44d22179a";
      sha256 = "1l23rfaddajkbra582k38ak5l0qwfdr6ac84abh3l1912ljfp7ih";
    };
  };
  asyncomplete-lsp = pkgs.vimUtils.buildVimPlugin {
    name = "asyncomplete-lsp";
    src = pkgs.fetchFromGitHub {
      owner = "prabirshrestha";
      repo = "asyncomplete-lsp.vim";
      rev = "684c34453db9dcbed5dbf4769aaa6521530a23e0";
      sha256 = "0vqx0d6iks7c0liplh3x8vgvffpljfs1j3g2yap7as6wyvq621rq";
    };
  };
  vim-goimports = pkgs.vimUtils.buildVimPlugin {
    name = "vim-goimports";
    src = pkgs.fetchFromGitHub {
      owner = "mattn";
      repo = "vim-goimports";
      rev = "cc0eab9ffa055718425d39911c300e8290b7c704";
      sha256 = "1xvqdkqywi3f9p8yykh96v1p4658y6183abxf2mr7nj17b399xnc";
    };
  };
 vim-lsp-ultisnips = pkgs.vimUtils.buildVimPlugin {
   name = "vim-lsp-ultisnips";
   src = pkgs.fetchFromGitHub {
     owner = "thomasfaingnaert";
     repo = "vim-lsp-ultisnips";
     rev = "30a476df29e5c6816403cf1c1960924031f0cdbe";
     sha256 = "003f3cbgd9crwkf24h1kzv2gf6ixxdidhgasslkvv95lfvnxikv3";
   };
 };
  vim-lsp-snippets = pkgs.vimUtils.buildVimPlugin {
    name = "vim-lsp-snippets";
    src = pkgs.fetchFromGitHub {
      owner = "thomasfaingnaert";
      repo = "vim-lsp-snippets";
      rev = "7d9bca7f5b37285cfec412caf92e1d6132e1fffb";
      sha256 = "0ikjds0y0r3iq3b8dpw2pl3a3vh7kvn7jrlvz16s1n2ckixgirx4";
    };
  };
#   = pkgs.vimUtils.buildVimPlugin {
#    name = "";
#    src = pkgs.fetchFromGitHub {
#      owner = "";
#      repo = "";
#      rev = "";
#      sha256 = "3xvqdkqywi3f9p8yykh96v1p4658y6183abxf2mr7nj17b399xnc";
#    };
#  };

in

  {
    environment.variables = { EDITOR = "vim"; };
    environment.systemPackages = with pkgs; [
      ((vim_configurable.override { python = python39 ; }) 
      .customize{
        name = "vim";
        vimrcConfig.plug.plugins = with pkgs.vimPlugins; [
            # theme
            nord-vim
            vim-airline
            vim-airline-themes

            # Language Server
            vim-lsp
            vim-lsp-settings

            # complement 
            asyncomplete
            asyncomplete-lsp

            # snippet
            ultisnips
            vim-snippets
            vim-lsp-ultisnips
            vim-lsp-snippets

            # language plugins
            vim-nix 
            vim-goimports

            # etc
            nerdtree
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

          set termguicolors
          colorscheme nord
          let g:airline_theme='deus'
          let g:airline_powerline_font=1

          if empty(globpath(&rtp, 'autoload/lsp.vim'))
            finish
          endif

          function! s:on_lsp_buffer_enabled() abort
            setlocal omnifunc=lsp#complete
            setlocal signcolumn=yes
            nmap <buffer>gd <plug>(lsp-definition)
            nmap <buffer><f2> <plug>(lsp-rename)
            inoremap <expr><CR> pumvisible() ? "\<C-y>" : "\<cr>"
          endfunction

          augroup lsp_install
            au!
            autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
          augroup END
          command! LspDebug let lsp_log_verbose=1 | let lsp_log_file = expand('~/lsp.log')         

          let g:lsp_diagnostics_enabled = 1
          let g:lsp_diagnostics_echo_cursor = 1
          let g:lsp_diagnostics_float_cursor = 1

          let g:asyncomplete_auto_popup = 1
          let g:asyncomplete_auto_completeopt = 0
          let g:asyncomplete_popup_delay = 200

          inoremap <expr><Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
          inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

          set completeopt=menuone,noinsert

          nnoremap <C-e>l :NERDTreeToggle<CR>
          nnoremap <C-e>h :NERDTreeFind<CR>

          let g:UltiSnipsExpandTrigger="<C-j>"
          let g:UltiSnipsJumpForwardTrigger="<C-f>"
          let g:UltiSnipsJumpBackwardTrigger="<C-b>"

          syntax enable
        '';

      } 
      )];
    }

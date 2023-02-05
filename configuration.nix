{ config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix # Include the results of the hardware scan.
      ./vim.nix
      ./networking.nix
     # <home-manager/nixos>
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  virtualisation.docker.enable = true;
  # virtualisation.libvirtd.enable = true;
  # virtualisation.libvirtd.qemuOvmf = true;

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  services.xserver = {
    enable = true;
    
    displayManager.defaultSession = "none+i3";
    windowManager.i3.enable = true;
    xkbOptions = "ctrl:swapcaps";
    libinput.enable = true;
    libinput.touchpad.naturalScrolling = true;
  };

  fonts.fonts = with pkgs; [  
    source-han-code-jp
  ];

  i18n.inputMethod = {
    enabled = "fcitx";
    fcitx.engines = with pkgs.fcitx-engines; [ anthy mozc ];
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  environment.systemPackages = with pkgs; [
    chromium
    git
    (st.overrideAttrs (oldAttrs: rec {
      patches = [
        ./st-patch/st-scrollback-0.8.5.diff
        ./st-patch/st-scrollback-reflow-0.8.5.diff
      ];
      configFile = writeText "config.def.h" (builtins.readFile ./config.def.h);
      postPatch = "${oldAttrs.postPatch}\n cp ${configFile} config.def.h";
    }))
    scrot
    w3m
    file
    wget
    gcc
    go
    protobuf
    gotools
    gopls
    peco
    nodejs
    (python39.withPackages (ps: with ps; [ pynvim pip ]))
  ];

  users.defaultUserShell = pkgs.zsh;
  users.users.ykonomi = {
    useDefaultShell = true;
    isNormalUser = true;
    home = "/home/ykonomi";
    extraGroups = [ "wheel" "docker" ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
    autosuggestions.enable = true;
    histSize = 100000;
    shellInit = ''
      function peco-history-selection() {
        BUFFER=`history -n 1 | tac  | awk '!a[$0]++' | peco`
        CURSOR=$#BUFFER
        zle reset-prompt
      }
      zle -N peco-history-selection
      bindkey '^R' peco-history-selection

      setopt inc_append_history
      setopt share_history
      setopt hist_ignore_dups
    '';
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    shortcut = "j";
     extraConfig = ''
        set -g status-interval 1
        set -g status-justify "centre"
        set -g status-bg "colour238"
        set -g status-fg "colour255"
     '';
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # List services that you want to enable:
  # services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}


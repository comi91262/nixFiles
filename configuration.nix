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
    displayManager.sessionCommands = ''
      ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
         URxvt.font: xft:source han code jp:pixelsize=15
         URxvt.scrollBar: false
         URxvt.foreground: [90]#ecf0fe	
         URxvt.background: [90]#232537
      EOF
    '';
    windowManager.i3.enable = true;
    xkbOptions = "ctrl:swapcaps";
    libinput.enable = true;
    libinput.naturalScrolling = true;
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
    rxvt_unicode
    scrot
    w3m
    file
    wget
    go
    goimports
    gopls
    (python39.withPackages (ps: with ps; [ pynvim ]))
  ];

  users.users.ykonomi = {
    isNormalUser = true;
    home = "/home/ykonomi";
    extraGroups = [ "wheel" "docker" ];
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


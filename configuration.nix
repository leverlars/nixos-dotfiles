# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.networkmanager.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  services.blueman.enable = true;

  services.thermald.enable = true;
  services.tlp.enable = true;

  zramSwap.enable = true;

  time.timeZone = "Europe/Copenhagen";

  i18n.defaultLocale = "en_DK.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "da_DK.UTF-8";
    LC_IDENTIFICATION = "da_DK.UTF-8";
    LC_MEASUREMENT = "da_DK.UTF-8";
    LC_MONETARY = "da_DK.UTF-8";
    LC_NAME = "da_DK.UTF-8";
    LC_NUMERIC = "da_DK.UTF-8";
    LC_PAPER = "da_DK.UTF-8";
    LC_TELEPHONE = "da_DK.UTF-8";
    LC_TIME = "da_DK.UTF-8";
  };

  services.xserver.xkb = {
    layout = "dk";
    variant = "";
    options = "caps:swapescape";
  };

  services.xserver = {
    enable = true;
    autoRepeatDelay = 200;
    autoRepeatInterval = 35;
  };
  services.displayManager.ly.enable = true;

  ##services.greetd.enable = true;

  security.polkit.enable = true;
  hardware.opengl.enable = true;

  services.gnome.gnome-keyring.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

  };

  console.keyMap = "dk-latin1";

  users.users.leverlars = {
    isNormalUser = true;
    description = "leverlars";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      tree
    ];

    # openssh.authorizedKeys.keys = [
    #   "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDue4ioV62xLc44Oe+jJ9fY47xu4P+zrX9Da6WfOB5igEGHnOnSRrWZpBCNKJBhR/AXlWLSRoxJsCgFcEz+90IJx6HqOlfWJS3tp34/GXmfxZ/qfOeFfEJsHQ4agYyhIeNKtlzOTVTuNimlqiKHYXAs1SXfljt6J/4pWuQib090cLA4h8wURRKsjUNFMN6cTADiVXZuVO+oo7+LhAXGe3L0WMS4IiTEePVmGFRgM1L99o6pEK0RWJNdqsN+F/s1ymV0PAkq5UN+GBPyYpDcMT/5gV45BxLwfsU9RFdIKVsmfIF4m3Tccq1E7umqfn8YOhpobfrMJmw2IVk6UGztfJ+88G1Ta52U3mwr59stirCe/JpjAwABFF9gNiHGA7JWzzMnW16BFLVRkxOZCende/VFtGR9bfZDa0gDVtcogcy4qKktLRgoD7o+Jit0wRip4dghxii01laS9leUP8r2FBqeuQPg6Jm4dbbv2TY0hSn0vnD5gZqjiL7rDmoQupzivYk= jimmy"
    # ];
  };

  programs.firefox.enable = true;

  programs.steam.enable = true;

  programs.zsh.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    mako
    wl-clipboard
    grim
    slurp
    shotman
    gh
    sublime

    #themes and waybar
    sassc
    gtk-engine-murrine
    gnome-themes-extra
    tokyonight-gtk-theme
    waybar
    gtk4
    wdisplays
    wofi
    wlroots

    #terminal appearance
    kitty
    powerline
    powerline-fonts

    #util tools
    networkmanagerapplet
    fzf
    ripgrep
    fd
    unzip
    zip
    yt-dlp
    gnupg

    # VPN
    protonvpn-gui

    #dev tools
    rustc
    # rust-analyzer
    nil
    nixpkgs-fmt
    rustup
    cargo
    rustup
    go
    llvmPackages_21.clang-tools
    cmake
    valgrind
    gdb
    julia
    probe-rs-tools
    espflash
    texliveFull
    # openjdk15

    # util-apps
    xfce.tumbler
    xfce.thunar
    vlc
    keepassxc
    neofetch
    fastfetch
    discord
    steam
    btop
    gdu
    ranger
    newsboat
    zathura
    gimp
    gammastep
    brave

    # audio-control
    pavucontrol
    helvum

    #school
    libreoffice
    sage
    surfer
    wineWowPackages.waylandFull
    wineWowPackages.stable
    wine
    wine64

    #games
    cbonsai
    cmatrix
    nsnake
    ninvaders

  ];

  fonts.packages = with pkgs; [
    nerd-fonts._3270
    font-awesome
    roboto
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh = {
  #   enable = true;
  #   ports = [ 5342 ];

  #   settings = {

  #     PasswordAuthentication = false;
  #     KbdInteractiveAuthentication = false;
  #     PermitRootLogin = "no";
  #     AllowUsers = [ "leverlars" ];
  #   };
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  networking.firewall.checkReversePath = "loose";
  
  # VirtualBox
  virtualisation.virtualbox.host.enable = true;   # pulls in the kernel modules
  boot.kernelModules = [ "vboxdrv" "vboxnetflt" "vboxnetadp" ];
  virtualisation.libvirtd.enable = true;
  users.extraUsers.leverlars = {
    isNormalUser = true;
    extraGroups = [ 
                    "vboxusers"
                    "libvirtd"
                  ];   # needed for shared‑folder mounts
  };
  
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05";
}

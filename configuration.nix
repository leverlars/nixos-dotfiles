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

  boot.kernelModules = [ "kvm-intel" ];

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

  hardware.graphics.enable = true;

  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];

  services.udev.extraRules = '' # For Vivado
    ATTRS{idVendor}=="1443", MODE:="0666"
    ACTION=="add", ATTRS{idVendor}=="0403", ATTRS{manufacturer}=="Digilent", MODE:="0666"
  '';

  hardware.nvidia.open = true; #true for Sway and false for gnome. Maybe false for both?

  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:45:0:0";
    #nvidiaBusId = "PCI:1:0:0";
    #amdgpuBusId = "PCI:54:0:0"; # If you have an AMD iGPU
  };

  hardware.nvidia = {
    #open = false; #true for Sway and false for gnome. Maybe false for both?
    modesetting.enable = true;
  };

  ###
  #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  ###

  networking.networkmanager.wifi.backend = "wpa_supplicant";
  networking.useNetworkd = false;

  services.blueman.enable = true;

  services.thermald.enable = true;
  services.tlp.enable = true; #true for Sway and false for gnome
  services.power-profiles-daemon.enable = false; #false for Sway and true for Gnome?

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

    #displayManager.gdm.enable = true; #gnome
    #displayManager.gdm.wayland = true; #gnome
    #desktopManager.gnome.enable = true; #gnome

  };
  services.displayManager.ly.enable = true; #true for Sway and false for X11

  ##services.greetd.enable = true;

  security.polkit.enable = true;
  #hardware.opengl.enable = true; # Outdated?

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
      "docker"
      "libvirtd"
    ];
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;

  programs.steam.enable = true;

  programs.zsh.enable = true;

  # OpenCode configuration
  environment.etc."opencode-user.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";

    model = "infomaniak/moonshotai/Kimi-K2.6";

    provider.infomaniak = {
      npm = "@ai-sdk/openai-compatible";
      name = "Infomaniak";

      options = {
        baseURL =
          "https://api.infomaniak.com/2/ai/YOUR_PRODUCT_ID/openai/v1";
      };

      models."moonshotai/Kimi-K2.6" = {
        name = "Kimi K2.6 (Infomaniak)";

        limit = {
          context = 256000;
        };
      };
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";

    # Tell OpenCode to load our declarative NixOS config.
    OPENCODE_CONFIG = "/etc/opencode-user.json";
  };

  environment.etc."distrobox/distrobox.conf".text = ''
    container_additional_volumes="
      /nix/store:/nix/store:ro
      /etc/profiles/per-user:/etc/profiles/per-user:ro
      /etc/static/profiles/per-user:/etc/static/profiles/per-user:ro
      /run/current-system/sw/bin:/run/current-system/sw/bin:ro
    "
  '';

  #environment.etc."distrobox/distrobox.conf".text = ''
  #  container_additional_volumes="
  #    /nix/store:/nix/store:ro
  #    /etc/profiles/per-user:/etc/profiles/per-user:ro
  #    /etc/static/profiles/per-user:/etc/static/profiles/per-user:ro
  #    /run/current-system/sw/bin:/run/current-system/sw/bin:ro
  #  "
  #'';

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
    vscode
    distrobox

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
    pciutils
    usbutils

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
    gcc
    lldb
    rars
    gnumake
    # openjdk15
    nvidia-container-toolkit
    libnvidia-container
    opencode

    # util-apps
    xfce.tumbler
    xfce.thunar
    vlc
    keepassxc
    neofetch
    fastfetch
    discord-canary
    vesktop
    steam
    #(prismlauncher.override {
    #  jdks = [
    #    jdk25
    #    jdk21
    #    jdk17
    #    jdk8
    #  ];
    #})
    gamescope
    vulkan-tools
    btop
    gdu
    ranger
    newsboat
    zathura
    gimp
    gammastep
    brave
    gnome-calculator
    ghex
    wxhexeditor
    gnome-screenshot
    networkmanagerapplet
    cheese
    imagemagick
    flameshot

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
  #virtualisation.virtualbox.host.enable = true;   # pulls in the kernel modules
  #boot.kernelModules = [ "vboxdrv" "vboxnetflt" "vboxnetadp" "thunderbolt" ];
  #virtualisation.libvirtd.enable = true;
  #users.extraUsers.leverlars = {
  #  isNormalUser = true;
  #  extraGroups = [ 
  #                  "vboxusers"
  #                  "libvirtd"
  #                ];   # needed for shared‑folder mounts
  #};
  
  #virtualisation.podman = {
  #  enable = true;
  #  dockerCompat = true;
  #};

  hardware.nvidia-container-toolkit.enable = true;

  virtualisation.containers = {
    enable = true;

    policy = {
      default = [ { type = "insecureAcceptAnything"; } ]; # Insecure much? xd
    };
  };

  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
  };

  #virtualisation.virtualbox.host.enable = true;
  #  users.extraGroups.vboxusers.members = [ "leverlars" ];
  #  virtualisation.virtualbox.host.enableExtensionPack = true;

  virtualisation.libvirtd = {
    enable = true;

    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;

      vhostUserPackages = with pkgs; [
        virtiofsd
      ];
    };
  };

  programs.virt-manager.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11";
}

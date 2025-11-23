{
  config,
  pkgs,
  lib,
  ...
}:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    sway = "sway";
    waybar = "waybar";
    kitty = "kitty";
    # helix = "helix";
    Thunar = "Thunar";
  };

in
{
  home.username = "leverlars";
  home.homeDirectory = "/home/leverlars";

  programs.git.enable = true;

  programs.swaylock.enable = true;
  home.stateVersion = "25.05";
  #programs.bash = {
  #	enable = true;
  #};

  home.packages = with pkgs; [
    neovim
    gcc
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "kitty";
  };

  gtk = {
    enable = true;
    theme.name = "Tokyonight-Dark";
    theme.package = pkgs.tokyonight-gtk-theme;
    iconTheme.name = "Tokyonight-Dark";
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      btw = "fastfetch && echo I use NixOS, btw";
      update = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos";
    };

    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
    };

  };

  home.keyboard.layout = "dk";

  #programs.waybar = {
  #	enable = true;
  #	systemd.enable = true;
  #};

  programs.helix = {
    enable = true;
    settings = {
      theme = "tokyonight_transparent";
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
    };
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = lib.getExe pkgs.nixfmt-rfc-style;
      }
    ];
    themes = {
      tokyonight_transparent = {
        "inherits" = "tokyonight";
        "ui.background" = { };
      };
    };
  };

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;

  }) configs;

}

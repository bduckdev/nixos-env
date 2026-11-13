{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  dotfiles = "${config.home.homeDirectory}/nixos-env/config";
  assets = "${config.home.homeDirectory}/nixos-env/assets";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    hypr = "hypr";
    noctalia = "noctalia";
    swayimg = "swayimg";
  };
in
{
  imports = [
    ./common.nix
  ];

  home.homeDirectory = "/home/bduck";

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;

  dconf = {
    enable = true;

    settings."org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    enable = true;
    colorScheme = "dark";

    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };

    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  services = {
    easyeffects = {
      enable = true;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "kde";
  };

  home.packages = with pkgs; [
    adw-gtk3
    blanket
    bottles
    gdb
    heroic
    lutris
    mgba
    mpvpaper
    nvd
    protonup-qt
    retroarch
    satty
    seer
    slurp
    sone
    stremio-linux-shell
    tetrio-desktop
  ];
}

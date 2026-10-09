{
  pkgs,
  inputs,
  ...
}:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  documentation.man.enable = true;

  hardware.graphics.enable = true;

  users.users.bduck = {
    isNormalUser = true;
    description = "Brennan Duck";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFt8/My570WXRzBbQi5LNMX7g0Srsw9y+Vjcc1Yj0P0r bduck@continuumcloud.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFXlT1LZafXku9iQAeXMacUwl3A8l1cMBLUIWZ5xtanX"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINZ4rzsuIDoo/u5X89OShjMZ1fSH5o12gMrBwYyKAG+X brennantduck@gmail.com"
    ];
  };

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  networking.extraHosts = ''
    127.0.0.1 reddit.com
  '';

  security.rtkit.enable = true;

  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    dconf.enable = true;
    noctalia.enable = true;
    zsh.enable = true;
  };

  environment = {
    localBinInPath = true;

    systemPackages = [
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      # pkgs.gnomeExtensions.focus-changer
      pkgs.mangohud
      pkgs.wl-clipboard
      pkgs.wl-clip-persist
    ];
  };

  services = {
    keyd = {
      enable = true;

      keyboards.default = {
        ids = [ "*" ];

        settings = {
          main = {
            capslock = "esc";
            delete = "leftmeta";
          };
        };
      };
    };
    # displayManager.gdm.enable = true;
    # desktopManager.gnome.enable = true;

    #displayManager.sddm = {
    #  enable = true;
    #  wayland.enable = true;
    #};

    displayManager.noctalia-greeter = {
      enable = true;
      settings = {
        appearance.scheme = "Synced";
        cursor.size = 24;
        keyboard.layout = "us";
        output.name = "ASUSTek COMPUTER INC XG27JCG";
      };
      cursorTheme = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
      };
    };

    desktopManager.plasma6.enable = true;
    printing.enable = true;

    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    tailscale = {
      enable = true;
      openFirewall = true;
    };
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];
}

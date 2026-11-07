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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP+SLSckUNT/LuVAn8B83lfM5o6KrHvgJxjeKJ6wxMJa brennantduck@gmail.com"
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

  networking.stevenblack = {
    enable = true;
    block = [
      "fakenews"
      "gambling"
      "porn"
      "social"
    ];
  };

  networking.extraHosts = ''
    0.0.0.0 bing.com
    0.0.0.0 youtube.com
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
    desktopManager.plasma6.enable = true;

    displayManager.ly.enable = true;

    keyd = {
      enable = true;

      keyboards.default = {
        ids = [ "*" ];

        settings = {
          main = {
            capslock = "esc";
          };
        };
      };
    };

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

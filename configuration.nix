{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "nixos-desktop";
    networkmanager.enable = true;
    interfaces.enp7s0.ipv4.addresses = [
      {
        address = "192.168.1.69";
        prefixLength = 24;
      }
    ];

    defaultGateway = "192.168.1.1";

    nameservers = [
      "192.168.1.1"
      "1.1.1.1"
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

  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    openssh = {
      enable = true;
      openFirewall = true;

      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    printing.enable = true;

    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  security.rtkit.enable = true;

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
    ];
  };

  programs = {
    mango.enable = true;
    noctalia.enable = true;
    steam.enable = true;
    zsh.enable = true;
  };

  environment = {
    localBinInPath = true;

    systemPackages = [
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    etc."mango/config.conf".source = "${config.programs.mango.package}/etc/mango/config.conf";
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  system.stateVersion = "26.05"; # Keep the version from the first install.
}

{
  ...
}:

{
  imports = [
    ../common.nix
    ./hardware-configuration.nix
    ./sunshine.nix
  ];
  hardware.graphics.enable32Bit = true;

  networking = {
    hostName = "nixos-desktop";
    networkmanager = {
      enable = true;
      settings.main.no-auto-default = "*";
      ensureProfiles.profiles.enp7s0 = {
        connection = {
          id = "enp7s0";
          type = "ethernet";
          interface-name = "enp7s0";
          autoconnect = true;
        };
        ipv4 = {
          method = "manual";
          addresses = "192.168.1.69/24";
          gateway = "192.168.1.1";
        };
        ipv6.method = "link-local";
      };
    };

    nameservers = [
      "192.168.1.1"
      "1.1.1.1"
    ];
  };

  programs = {
    gamemode.enable = true;
    gamescope = {
      enable = true;
      #capSysNice = true;
      enableWsi = true;
    };
    steam = {
      enable = true;
      gamescopeSession = {
        enable = true;
        args = [
          "--hdr-enabled"
          "--adaptive-sync"
        ];
        steamArgs = [
          "-gamepadui"
          #"-tenfoot"
          "-pipewire-dmabuf"
        ];
      };
    };
  };

  services = {
    openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    xserver.videoDrivers = [ "amdgpu" ];
  };

  systemd.sleep.settings.Sleep = {
    AllowHibernation = "no";
    AllowSuspend = "no";
    AllowHybridSleep = "no";
    AllowSuspendThenHibernate = "no";
  };

  system.stateVersion = "26.05"; # Keep the version from the first install.
}

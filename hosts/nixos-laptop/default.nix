{
  ...
}:

{
  imports = [
    ../common.nix
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "nixos-laptop";
    networkmanager.enable = true;
  };

  programs.moonlight-qt = {
    enable = true;
    capSysNice = true;
  };

  system.stateVersion = "26.05";
}

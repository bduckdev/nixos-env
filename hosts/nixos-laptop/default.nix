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

  system.stateVersion = "26.05";
}

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

  home-manager.users.bduck.services.shikane = {
    enable = false;

    settings.profile = [
      {
        name = "laptop";

        output = [
          {
            search = "m=0x0067";
            enable = true;
          }
        ];
      }

      {
        name = "desk";

        output = [
          {
            search = "m=0x0067";
            enable = false;
          }

          {
            search = "m=XG27JCG";
            enable = true;
          }

          {
            search = "m=MQ16FC";
            enable = true;
          }
        ];
      }
    ];
  };

  system.stateVersion = "26.05";
}

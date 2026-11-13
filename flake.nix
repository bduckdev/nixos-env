{
  description = "Brennan's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium = {
      url = "github:schembriaiden/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      ...
    }:

    let
      mkHost =
        hostModule:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = {
            inherit inputs;
          };

          modules = [
            hostModule

            home-manager.nixosModules.home-manager

            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                overwriteBackup = true;

                extraSpecialArgs = { inherit inputs; };

                users.bduck = import ./home/linux.nix;

                sharedModules = [
                  inputs.spicetify-nix.homeManagerModules.spicetify
                ];
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        nixos-desktop = mkHost ./hosts/nixos-desktop;
        nixos-laptop = mkHost ./hosts/nixos-laptop;
      };

      darwinConfigurations.macbook = inputs.nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };

        modules = [
          ./hosts/macbook

          home-manager.darwinModules.home-manager

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";

              extraSpecialArgs = { inherit inputs; };

              users.bduck = import ./home/darwin.nix;
            };
          }
        ];
      };
    };
}

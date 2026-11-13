{ ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.primaryUser = "bduck";
  users.users.bduck.home = "/Users/bduck";

  programs.zsh.enable = true;

  system.stateVersion = 6;
}

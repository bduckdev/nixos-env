{ ... }:

{
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = false;
  };

  # Allow Sunshine to emulate controllers, mouse and keyboard.
  users.users.bduck.extraGroups = [ "uinput" ];

  # Allow Sunshine's streaming ports on the Tailscale interface.
  networking.firewall.interfaces.tailscale0 = {
    allowedTCPPorts = [
      47984
      47989
      48010
    ];

    allowedUDPPorts = [
      47998
      47999
      48000
      48002
      48010
    ];
  };
}

{ config, pkgs, inputs,  ... }:

{
	imports = [
		./hardware-configuration.nix
	];

	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	networking.hostName = "nixos";
	networking.networkmanager.enable = true;

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

	services.xserver = {
		enable = true;
		xkb = {
			layout = "us";
			variant = "";
		};
	};

	services.displayManager.gdm.enable = true;
	services.desktopManager.gnome.enable = true;
	services.printing.enable = true;

	services.pulseaudio.enable = false;
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
	};

	users.users.bduck = {
		isNormalUser = true;
		description = "Brennan Duck";
		extraGroups = [ "networkmanager" "wheel" ];
		shell = pkgs.zsh;
	};

    programs.mango.enable = true;
    programs.noctalia.enable = true;
	programs.steam.enable = true;
	programs.zsh.enable = true;

    environment.systemPackages = [
     inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

	# Nixpkgs installs Mango's fallback config in the package output, but does
	# not link it into /etc. Expose it at the path Mango documents and checks.
	environment.etc."mango/config.conf".source =
		"${config.programs.mango.package}/etc/mango/config.conf";

	nixpkgs.config.allowUnfree = true;
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	fonts.packages = [
		pkgs.nerd-fonts.jetbrains-mono
	];

	system.stateVersion = "26.05"; # Keep the version from the first install.
}

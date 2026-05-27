{ config, pkgs, lib, inputs, ... }:

{
	imports = [
		./boot-systemd.nix
	];

	# Packages needed literaly everywhere ----

	environment.systemPackages = with pkgs; [
		git
		vim
		wget
		curl
		sops
	];

	services.openssh.enable = true;
	programs.bash.enable = true;

	# Nix general configs --------------------

	nix.settings.experimental-features = ["nix-command" "flakes" ];
	nixpkgs.config.allowUnfree = true;
	users.mutableUsers = false;

	# Locales --------------------------------

	time.timeZone = "Europe/Madrid";
	i18n.defaultLocale = "en_US.UTF-8";
	i18n.extraLocaleSettings = {
		LC_ADDRESS = "es_ES.UTF-8";
		LC_IDENTIFICATION = "es_ES.UTF-8";
		LC_MEASUREMENT = "es_ES.UTF-8";
		LC_MONETARY = "es_ES.UTF-8";
		LC_NAME = "es_ES.UTF-8";
		LC_NUMERIC = "es_ES.UTF-8";
		LC_PAPER = "es_ES.UTF-8";
		LC_TELEPHONE = "es_ES.UTF-8";
		LC_TIME = "es_ES.UTF-8";
	};

	# Keyboard type shit ---------------------

	services.xserver.xkb = {
		layout = "us";
		variant = "altgr-intl";
	};

	# Audio ----------------------------------

	security.rtkit.enable = true;
  	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = false;
		pulse.enable = true;
		jack.enable = true;
		wireplumber.enable = true;
	};

	# Bluetooth ------------------------------

	hardware.bluetooth.enable = true;

	# Network --------------------------------

	networking.networkmanager.enable = true;

	# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
	# Configure network proxy if necessary
	# networking.proxy.default = "http://user:password@proxy:port/";
	# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

}

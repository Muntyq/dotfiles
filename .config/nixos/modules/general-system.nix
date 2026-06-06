{ pkgs, hostProfile, userProfile, ... }: {


# ███████╗██╗   ██╗███████╗████████╗███████╗███╗   ███╗
# ██╔════╝╚██╗ ██╔╝██╔════╝╚══██╔══╝██╔════╝████╗ ████║
# ███████╗ ╚████╔╝ ███████╗   ██║   █████╗  ██╔████╔██║
# ╚════██║  ╚██╔╝  ╚════██║   ██║   ██╔══╝  ██║╚██╔╝██║
# ███████║   ██║   ███████║   ██║   ███████╗██║ ╚═╝ ██║
# ╚══════╝   ╚═╝   ╚══════╝   ╚═╝   ╚══════╝╚═╝     ╚═╝

	# Packages needed literally everywhere ---

	environment.systemPackages = with pkgs; [
		git
		neovim
		wget
		curl
		sops
		nmap
		rsync
		age
		btop
		unar   # unzip
	];

	services.openssh.enable = true;
	programs.bash.enable = true;
	services.dbus = {
		enable = true;
		implementation = "broker";
	};

	# Nix general configs --------------------

	nix.settings = {
		experimental-features = ["nix-command" "flakes" ];
		auto-optimise-store = true;
	};

	nix.gc = {
		automatic = true;
		dates = "Mon 06:00";
		options = "--delete-older-than 30d";
	};

	nixpkgs.config.allowUnfree = true;
	users.mutableUsers = false;

	# Bootloader config ----------------------

	boot.loader = {
		efi.canTouchEfiVariables = true;
		systemd-boot = {
			enable = true;
			configurationLimit = 9;
		};
	};

	systemd.targets = {
		sleep.enable = true;
		suspend.enable = true;
		hibernate.enable = true;
		hybrid-sleep.enable = true;
	};

	systemd.services.nixos-flake-auto-update = {
		description = "Auto-update & rebuild";
		serviceConfig = {
			Type = "oneshot";
			User = "root";
		};
		script = ''
			set -e
			cd /home/${userProfile}/.config/nixos
			${pkgs.nix}/bin/nix flake update
			/run/current-system/sw/bin/nixos-rebuild switch --flake .#${hostProfile} 2>&1
			echo -e "\e[1;94mNixOS system flake updated, remember to reboot! >ヮ<\e[0m"
		'';
		after = [ "network-online.target" ];
		requires = [ "network-online.target" ];
	};

	systemd.timers.nixos-flake-auto-update = {
		wantedBy = [ "timers.target" ];
		timerConfig = {
			OnCalendar = "Sat 06:00";
			Persistent = true;
		};
	};
	# Use specific kernel
	# boot.kernelPackages = pkgs.linuxPackages_latest;

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

}

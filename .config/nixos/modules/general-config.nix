{ pkgs, hostProfile, userProfile, ... }: {


# ██╗  ██╗ ██████╗ ███╗   ███╗███████╗
# ██║  ██║██╔═══██╗████╗ ████║██╔════╝
# ███████║██║   ██║██╔████╔██║█████╗
# ██╔══██║██║   ██║██║╚██╔╝██║██╔══╝
# ██║  ██║╚██████╔╝██║ ╚═╝ ██║███████╗
# ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝

	home-manager.users.${userProfile}.home = {
		packages = with pkgs; [
			clapboard
			ghostty
			fastfetch
			btop
			unar
		];

		sessionPath = [
			"$HOME/.local/bin"
		];

		sessionVariables = {
			TERMINAL = "ghostty";
			
			XDG_CONFIG_HOME = "$HOME/.config";
			XDG_CACHE_HOME = "$HOME/.cache";
			XDG_DATA_HOME = "$HOME/.local/share";
			XDG_STATE_HOME = "$HOME/.local/state";
		};
	};


# ███████╗██╗   ██╗███████╗████████╗███████╗███╗   ███╗
# ██╔════╝╚██╗ ██╔╝██╔════╝╚══██╔══╝██╔════╝████╗ ████║
# ███████╗ ╚████╔╝ ███████╗   ██║   █████╗  ██╔████╔██║
# ╚════██║  ╚██╔╝  ╚════██║   ██║   ██╔══╝  ██║╚██╔╝██║
# ███████║   ██║   ███████║   ██║   ███████╗██║ ╚═╝ ██║
# ╚══════╝   ╚═╝   ╚══════╝   ╚═╝   ╚══════╝╚═╝     ╚═╝

	# Packages needed literaly everywhere ----

	environment.systemPackages = with pkgs; [
		git
		vim
		wget
		curl
		sops
		nmap
		rsync  # sync between devices
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
		dates = "Mon 10:00";
		options = "--delete-older-than 30d";
	};

	nixpkgs.config.allowUnfree = true;
	users.mutableUsers = false;

	programs.direnv = {
		enable = true;
		nix-direnv.enable = true;
	};

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
		'';
		after = [ "network-online.target" ];
		requires = [ "network-online.target" ];
	};

	systemd.timers.nixos-flake-auto-update = {
		wantedBy = [ "timers.target" ];
		timerConfig = {
			OnCalendar = "";
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

	# Keyboard type shit ---------------------

	services.xserver.xkb = {
		layout = "us";
		variant = "altgr-intl";
	};

	i18n.inputMethod = {
		enable = true;
		type = "fcitx5";
		fcitx5.waylandFrontend = true;
		fcitx5.addons = with pkgs; [
			fcitx5-mozc
			fcitx5-gtk
		];
	};

	# Audio ----------------------------------

	security.rtkit.enable = true;
  	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true; # legit only for steam
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

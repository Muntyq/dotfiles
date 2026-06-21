{ pkgs, userProfile, inputs, ... }: {


# ██╗  ██╗ ██████╗ ███╗   ███╗███████╗
# ██║  ██║██╔═══██╗████╗ ████║██╔════╝
# ███████║██║   ██║██╔████╔██║█████╗
# ██╔══██║██║   ██║██║╚██╔╝██║██╔══╝
# ██║  ██║╚██████╔╝██║ ╚═╝ ██║███████╗
# ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝

	home-manager = {
		useGlobalPkgs = true;
		useUserPackages = true;
		users.${userProfile} = {
			programs.home-manager.enable = true;
			home = {
				username = "${userProfile}";
				homeDirectory = "/home/${userProfile}";
				stateVersion = "25.11";
				packages = with pkgs; [
					clapboard
					ghostty
					fastfetch
					librewolf            # web browser
					mpv                  # video player
					imv                  # image viewer
					pwvucontrol          # audio mixer
					kdePackages.dolphin  # file explorer

					# other ------------------------------
					wine-wayland # use regular wine if incompatibilities arrise

					# neovim compatability thing ---------
					# lua-language-server
					# rust-analyzer
					bash-language-server
					# clang-tools
					# vscode-langservers-extracted
					nixd
					marksman
					# gopls
					#
					# (vimPlugins.nvim-treesitter.withPlugins (p: [
					# 	p.go
					# 	p.gomod
					# 	p.gosum
					# 	p.lua
					# 	p.html
					# 	p.bash
					# 	p.nix
					# 	p.rust
					# 	p.c
					# 	p.javascript
					# 	p.typescript
					# 	p.css
					# 	p.json
					# 	p.yaml
					# 	p.toml
					# 	p.markdown
					# ]))

					# my own apps -------------------------
					inputs.inadev.packages.${pkgs.stdenv.hostPlatform.system}.default
                                        inputs.notea.packages.${pkgs.stdenv.hostPlatform.system}.default

				];

				sessionPath = [
					"$HOME/.local/bin"
				];

				sessionVariables = {
					EDITOR="nvim";
					VISUAL="nvim";
					BROWSER="librewolf";
					TERMINAL = "ghostty";

					XDG_CONFIG_HOME = "$HOME/.config";
					XDG_CACHE_HOME = "$HOME/.cache";
					XDG_DATA_HOME = "$HOME/.local/share";
					XDG_STATE_HOME = "$HOME/.local/state";
				};
			};
		};
	};

	# Web browser ------------------

        nixpkgs.config.permittedInsecurePackages = [
            "librewolf-151.0.2-1"
            "librewolf-unwrapped-151.0.2-1"
        ];
	# todo

	# Direnv

	programs.direnv = {
		enable = true;
		silent = true;
		nix-direnv.enable = true;
	};

	# aarch64-linux emulator

	boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

	# Torrent ---------------------------------------------

	services.rtorrent = {
		enable = true;
		port = 51412;
		package = pkgs.rtorrent;
		openFirewall = true;
	};
	services.flood = {
		enable = true;
		port = 8112;
		openFirewall = true;
		#  Args = ["--rtsocket=/run/rtorrent/rtorrent-ipc.socket"];
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

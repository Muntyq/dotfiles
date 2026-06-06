{ pkgs, userProfile, inputs, ... }: {

	home-manager.users.${userProfile}.home = {
		packages = with pkgs; [
			librewolf            # web browser
			mpv                  # video player
			imv                  # image viewer
			pwvucontrol          # audio mixer
			kdePackages.dolphin  # file explorer

			# other ------------------------------
			wine-wayland # use regular wine if incompatibilities arrise

			neovim

			# neovim compatability thing ---------
			lua-language-server
			rust-analyzer
			bash-language-server
			clang-tools
			vscode-langservers-extracted
			nixd
			marksman
			gopls

			(vimPlugins.nvim-treesitter.withPlugins (p: [
				p.go
				p.gomod
				p.gosum
				p.lua
				p.html
				p.bash
				p.nix
				p.rust
				p.c
				p.javascript
				p.typescript
				p.css
				p.json
				p.yaml
				p.toml
				p.markdown
			]))

			# my own apps -------------------------
			inputs.inadev.packages.${pkgs.system}.inadev
		];

		sessionVariables = {
			EDITOR="nvim";
			VISUAL="nvim";
			BROWSER="librewolf";
			DIRENV_LOG_FORMAT=""
		};
	};

	# Web browser ------------------

	# todo

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
}

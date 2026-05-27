{ config, pkgs, ... }:

{
	home.packages = with pkgs; [
		wofi
		librewolf
		kdePackages.dolphin
		pwvucontrol
		neovim
		hyprpicker
		hyprshot
		hyprpaper
		wine-wayland #try regular wine if incopatibilities arrise
		#qbit-manage
		qbittorrent
		dunst #check tiramisu for random rice

		# neovim compatability thing
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
	];

	home.sessionVariables = {
		EDITOR = "nvim";
		VISUAL = "nvim";
		BROWSER = "librewolf";
	};
}

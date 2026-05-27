{ config, pkgs, ... }:

{
	home.packages = with pkgs; [
		clapboard
		chezmoi
		ghostty
		fastfetch
		htop
	];

	home.sessionPath = [
		"$HOME/.local/bin"
	];

	home.sessionVariables = {
		TERMINAL = "ghostty";

		XDG_CONFIG_HOME = "$HOME/.config";
		XDG_CACHE_HOME = "$HOME/.cache";
		XDG_DATA_HOME = "$HOME/.local/share";
		XDG_STATE_HOME = "$HOME/.local/state";
	};
}

{ config, pkgs, ... }:

{
	home.packages = with pkgs; [
		protonplus
		prismlauncher
		osu-lazer-bin
		opentabletdriver
	];
}

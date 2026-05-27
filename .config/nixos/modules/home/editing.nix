{ config, pkgs, ... }:

{
	home.packages = with pkgs; [
		inkscape
		krita
		obs-studio
	];
}

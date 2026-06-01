{ pkgs, userProfile, ... }:

{
	home-manager.users.${userProfile}.home.packages = with pkgs; [
		mpv
		imv
	];
}

{ pkgs, userProfile, ... }: {

	programs.steam = {
		enable = true;
		dedicatedServer.openFirewall = true;
	};

	home-manager.users.${userProfile}.home.packages = with pkgs; [
		protonplus
		prismlauncher
		osu-lazer-bin
		opentabletdriver
	];
}

{ config, pkgs, hostProfile, lib, ... }:

let
  	muntyModules = {
		scout = [
			../sops.nix
			../general.nix
			../rice/hyprland.nix
		];
		core = [
			../editing.nix
			../general.nix
			../sops.nix
			../gaming.nix
			../rice/hyprland.nix
		];
		pebble = [
			../sops.nix
		];
	};

  	validProfiles = [ "scout" "core" "pebble" ];
in {
	users.users.munty = {
		isNormalUser = true;
		home = "/home/munty";
		description = "main user";
		hashedPasswordFile = config.sops.secrets."user-password".path;
		extraGroups = [
			"wheel"
			"networkmanager"
		];
		shell = pkgs.bash;
		openssh.authorizedKeys.keys = [
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDKWYk6GjHagRY4hUGhfgnq3OFvdcvCaO/S1Dj35lE6k aleix.muntal78@gmail.com"
		];
	};

	imports = (muntyModules.${hostProfile} or []);

	# Error catching if provided hostProfile is not defined

	assertions = [{
		assertion = builtins.elem hostProfile validProfiles;
		message = "hostProfile is not valid or set";
	}];
}

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
	};

	imports = (muntyModules.${hostProfile} or []);

	# Error catching if provided hostProfile is not defined

	assertions = [{
		assertion = builtins.elem hostProfile validProfiles;
		message = "hostProfile is not valid or set";
	}];
}

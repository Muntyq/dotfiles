{ config, pkgs, hostProfile, lib, ... }:

let
  	muntyModules = {
		xps13 = [
			../sops.nix
			../general-home.nix
			../rice/hyprland.nix
		];
		desktop = [
			../editing.nix
			../general-home.nix
			../sops.nix
			../gaming.nix
			../rice/hyprland.nix
		];
	};

  	validProfiles = [ "xps13" "desktop" ];
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

	home-manager = {
		useGlobalPkgs = true;
		useUserPackages = true;
		users.munty = {
			programs.home-manager.enable = true;
			home.username = "munty";
			home.homeDirectory = "/home/munty";
			home.stateVersion = "25.11";
		};
	};

	imports = (muntyModules.${hostProfile} or []);

	# Error catching if provided hostProfile is not defined

	assertions = [{
		assertion = builtins.elem hostProfile validProfiles;
		message = "hostProfile is not valid or set";
	}];
}

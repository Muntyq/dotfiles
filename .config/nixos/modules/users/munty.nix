{ config, pkgs, hostProfile, ... }:

let
	homeModules = {
		xps13 = [
			../home/gui-environment.nix
		];
		desktop = [
			../home/gui-environment.nix
		];
	};
  
  	systemModules = {
		xps13 = [
			../system/hyprland.nix
			../system/sddm.nix
			../system/wayland.nix
			../sops.nix
			../media.nix
		];
		desktop = [
			../system/hyprland.nix
			../system/sddm.nix
			../system/wayland.nix
			../editing.nix
			../media.nix
			../sops.nix
			../gaming.nix
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
			imports = (homeModules.${hostProfile} or []);
		};
	};

	imports = (systemModules.${hostProfile} or []);

	# Error catching if provided hostProfile is not defined

	assertions = [{
		assertion = builtins.elem hostProfile validProfiles;
		message = "hostProfile is not valid or set";
	}];
}

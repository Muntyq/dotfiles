{ config, pkgs, inputs, lib, hostProfile, ... }:

let
	homeModules = {
		xps13 = [
			../home/common-home.nix
			../home/gui-environment.nix
			../home/media.nix
		];
		desktop = [
			../home/common-home.nix
			../home/gui-environment.nix
			../home/gaming.nix
			../home/media.nix
			../home/editing.nix
		];
	};
  
  	systemModules = {
		xps13 = [
			../system/hyprland.nix
			../system/sddm.nix
			../system/wayland.nix
			../system/sops.nix
		];
		desktop = [
			../system/nvidia.nix
			../system/cpu-intel.nix
			../system/hyprland.nix
			../system/sddm.nix
			../system/steam.nix
			../system/wayland.nix
			../system/sops.nix
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

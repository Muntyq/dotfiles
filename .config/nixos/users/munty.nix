{ config, pkgs, hostProfile, lib, ... }:

let
  	muntyModules = {
		proxy = [
			../modules/general.nix
                        ../secrets/sops.nix
			../modules/rice/hyprland.nix
		];
		core = [
			../modules/editing.nix
                        ../secrets/sops.nix
			../modules/general.nix
			../modules/gaming.nix
			../modules/rice/hyprland.nix
		];
		pebble = [
                        ../secrets/sops.nix
                        ../modules/services/deepseekatempt.nix
                        # ../modules/services/nginx.nix
                        # ../modules/services/ukuma.nix
                        # ../modules/services/pihole.nix
                        # ../modules/services/gitea.nix
                        # ../modules/services/cloudflared.nix
		];
		archive = [
		];
	};

  	validProfiles = [ "proxy" "core" "pebble" "archive" ];
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
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDKWYk6GjHagRY4hUGhfgnq3OFvdcvCaO/S1Dj35lE6k ina@core"
                        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKDpxzJPm4etFbyz1Z3Fxe26CUP3ZcX4czrINouAG1rH ina@proxy"
		];
	};

	imports = (muntyModules.${hostProfile} or []);

	# Error catching if provided hostProfile is not defined

	assertions = [{
		assertion = builtins.elem hostProfile validProfiles;
		message = "hostProfile is not valid or set";
	}];
}

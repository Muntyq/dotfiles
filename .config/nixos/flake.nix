{
	description = "Nix declaration for the INA SYSTEM MATRIX";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";
		nixos-hardware.url = "github:NixOS/nixos-hardware/master";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		sops-nix = {
			url = "github:Mic92/sops-nix";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		inadev = {
			url = "github:Muntyq/inadev";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { nixpkgs, nixpkgs-stable, nixos-hardware, home-manager, sops-nix, inadev, self, ... }@inputs:

	let
		mkSystem = { system, hostProfile, userProfile }: nixpkgs.lib.nixosSystem {
			inherit system;
			specialArgs = {
				inherit inputs hostProfile userProfile;
				stable = import nixpkgs-stable { inherit system; };
			};
			modules = [
				./hosts/${hostProfile}/configuration.nix
				./modules/users/${userProfile}.nix
				sops-nix.nixosModules.sops
			];
		};

	in {
		nixosConfigurations = {
			# Be careful if changing userProfile or hostProfile;
			# host & user folders are referenced implicitly & users have a per-host module selection

			scout = mkSystem {
				system = "x86_64-linux";
				hostProfile = "scout";
				userProfile = "munty";
			};
			core = mkSystem {
				system = "x86_64-linux";
				hostProfile = "core";
				userProfile = "munty";
			};
			pebble = mkSystem {
				system = "aarch64-linux";
				hostProfile = "pebble"; # pebble-specific checks in minimum.nix
				userProfile = "munty";
			};
			monolith = mkSystem { # to be implemented
				system = "x86_64-linux";
				hostProfile = "monolith";
				userProfile = "munty";
			};
		};
	};
}

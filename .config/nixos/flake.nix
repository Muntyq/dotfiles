{
	description = "My ultra omega super cool nixOS attempt n.9001_v.41-very_unstable";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		sops-nix = {
			url = "github:Mic92/sops-nix";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { nixpkgs, nixpkgs-stable, home-manager, sops-nix, self, ... }@inputs:

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
				home-manager.nixosModules.home-manager
				sops-nix.nixosModules.sops
			];
		};

	in {
		nixosConfigurations = {
			# Names to change, i want to larp a bit;possible names: Core Mainframe Node Nibble0x08 proto grid monolith archive 
			xps13 = mkSystem {
				system = "x86_64-linux";
				hostProfile = "xps13";
				userProfile = "munty";
			};
			desktop = mkSystem {
				system = "x86_64-linux";
				hostProfile = "desktop";
				userProfile = "munty";
			};
			#to do
			# ina-pi
			# ina-server
		};
	};
}

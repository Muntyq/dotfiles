{
	description = "My ultra omega super cool nixOS attempt n.9001_v.41-very_unstable";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		sops-nix = {
			url = "github:Mic92/sops-nix";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { nixpkgs, home-manager, sops-nix, self, ... }@inputs: {

		nixosConfigurations = {
			# Names to change, i want to larp a bit;possible names: Core Mainframe Node Nibble0x08 proto grid monolith archive 
			xps13 = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux"; # for raspberry change to aarch64-linux probab
				specialArgs = {
					inherit inputs;
					hostProfile = "xps13";
					userProfile = "munty";
				};
				modules = [
					./hosts/xps13/configuration.nix
					./modules/users/munty.nix
					home-manager.nixosModules.home-manager
					sops-nix.nixosModules.sops
				];
			};

			desktop = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = {
					inherit inputs;
					hostProfile = "desktop";
					userProfile = "munty";
				};
				modules = [
					./hosts/desktop/configuration.nix
					./modules/users/munty.nix
					home-manager.nixosModules.home-manager
					sops-nix.nixosModules.sops
				];
			};
			#to do
			# ina-pi
			# ina-server
		};
	};
}

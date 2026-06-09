{ inputs, ... }: {

	imports = [
		./hardware-configuration.nix
		inputs.home-manager.nixosModules.home-manager
		../../secrets/sops.nix
		../../modules/minimum.nix
		../../modules/drivers/cpu-intel.nix
		../../modules/drivers/gpu-intel.nix
	];

	networking.hostName = "probe";
	system.stateVersion = "25.11";
}

{ input, ... }: {

	imports = [
		./hardware-configuration.nix
		inputs.home-manager.nixosModules.home-manager
		../../modules/minimum.nix
		../../modules/drivers/cpu-intel.nix
		../../modules/drivers/gpu-intel.nix
	];

	networking.hostName = "scout";
	system.stateVersion = "25.11";
}

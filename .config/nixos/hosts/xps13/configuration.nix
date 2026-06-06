{ ... }:

{
	imports = [
		./hardware-configuration.nix
		../../modules/general-system.nix
		../../modules/drivers/cpu-intel.nix
		../../modules/drivers/gpu-intel.nix
	];

	networking.hostName = "ina-scout";

	system.stateVersion = "25.11";
}

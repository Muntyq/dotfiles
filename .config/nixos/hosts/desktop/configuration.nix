{ ... }:

{
	imports = [
		./hardware-configuration.nix
		../../modules/general-system.nix
		../../modules/drivers/cpu-intel.nix
		../../modules/drivers/gpu-nvidia.nix
	];

	networking.hostName = "ina-core";

	system.stateVersion = "25.11";
}

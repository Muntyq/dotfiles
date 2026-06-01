{ ... }:

{
	imports = [
		./hardware-configuration.nix
		../../modules/general-config.nix
		../../drivers/cpu-intel.nix
		../../drivers/gpu-intel.nix
	];

	networking.hostName = "ina-scout";

	system.stateVersion = "25.11";
}

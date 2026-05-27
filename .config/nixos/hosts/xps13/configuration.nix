{ config, pkgs, lib, inputs, ... }:

{
	imports = [
		./hardware-configuration.nix
		../../modules/system/common-system.nix
		../../modules/system/cpu-intel.nix
		../../modules/system/gpu-intel.nix
	];

	networking.hostName = "ina-scout";

	system.stateVersion = "25.11";
}

{ config, pkgs, lib, inputs, ... }:

{
	imports = [
		./hardware-configuration.nix
		../../modules/system/common_system.nix
		../../modules/cpu-intel.nix
		../../modules/gpu-nvidia.nix
		../../modules/hdd-storage.nix
	];

	networking.hostName = "ina-core";

	system.stateVersion = "25.11";
}

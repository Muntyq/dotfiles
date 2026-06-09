{ inputs, ... }: {

	imports = [
		./hardware-configuration.nix
		inputs.home-manager.nixosModules.home-manager
		../../secrets/sops.nix
		../../modules/minimum.nix
		../../modules/drivers/cpu-intel.nix
		../../modules/drivers/gpu-nvidia.nix
	];

	nix.settings.secretKeyFiles = [ "/etc/nix/secret-key.pem" ];

	networking.hostName = "core";
	system.stateVersion = "25.11";
}

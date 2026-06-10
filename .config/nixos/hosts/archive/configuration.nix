{ inputs, ... }: {

	imports = [
		./hardware-configuration.nix
		../../modules/minimum.nix
	];

	networking.hostName = "archive";
	system.stateVersion = "25.11";
}

{ userProfile, ... }: {

	# (imported from hosts)
	sops = {
		defaultSopsFile = ./secrets.yaml;
		defaultSopsFormat = "yaml";

		age = {
			# keyFile = "/home/${userProfile}/.config/sops/age/keys.txt";
			sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
		};

		secrets = {
			"user-password" = {
				neededForUsers = true;
			};
		};
	};

	nix.settings.trusted-public-keys = [
		"cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
		"core:BgEKur97Ab3tzHx1Er7FRyP1Q/I+h7gokUihwbHb4KM="
	];
}

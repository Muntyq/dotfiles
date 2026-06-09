{ userProfile, ... }: {

	sops = {
		defaultSopsFile = ../secrets/secrets.yaml;
		defaultSopsFormat = "yaml";

		age = {
			keyFile = "/home/${userProfile}/sops/age/keys.txt";
			sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
		};

		secrets = {
			"user-password" = {
				neededForUsers = true;
			};
		};
	};
}

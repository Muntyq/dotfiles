{ userProfile, ... }: {

	sops = {
		defaultSopsFile = ../../secrets/munty.yaml;
		defaultSopsFormat = "yaml";

		age = {
			keyFile = "/etc/sops/keys.txt";
			sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
		};

		secrets = {
			"user-password" = {
			neededForUsers = true;
			};
			"ssh-private-key" = {
				owner = "munty";
				path = "/home/munty/.ssh/id_ed25519";
			};
		};
	};
}

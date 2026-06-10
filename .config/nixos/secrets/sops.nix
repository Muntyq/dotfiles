{ userProfile, ... }: {

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
            # "cloudflare-api-token" = { # only imported from pebble, only that has acme usergroup
            #     owner = "acme";
            # };
        };
    };

     nix.settings.trusted-public-keys = [ # keys to get packages from (pem)
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "core:BgEKur97Ab3tzHx1Er7FRyP1Q/I+h7gokUihwbHb4KM="
    ];
}

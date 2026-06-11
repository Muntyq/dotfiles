{ config, lib, ... }: {

    # check blocky.nix for networking.nameservers

    users.users.cloudflared = {
        isSystemUser = true;
        group = "cloudflared";
    };
    users.groups.cloudflared = {};
    sops.secrets."cloudflare-tunnel-token" = {
        owner = "root";
        mode = "0440";
        group = "cloudflared";
    };

    services.cloudflared = {
        enable = true;
        tunnels = {
            "pebble" = { # pebble tunnel from cloudlare
                tokenFile = config.sops.secrets."cloudflare-tunnel-token".path;
                ingress = {
                    "hs.muntyq.com" = "https://localhost:443";
                };
                default = "http_status:404";
            };
        };
    };

    services.headscale = {
        enable = true;
        address = "127.0.0.1";
        port = 8080;
        settings = {
            server_url = "https://hs.muntyq.com";
            dns.base_domain = "mesh.muntyq.com";
            dns.nameservers.global = [ "1.1.1.1" "8.8.8.8" ];
        };
    };

    services.nginx.virtualHosts."hs.muntyq.com" = {
        useACMEHost = "muntyq.com";
        forceSSL = true;
        locations."/" = {
            proxyPass = "http://127.0.0.1:8080";
            proxyWebsockets = true;
        };
    };
}

{ config, pkgs, lib, ... }: {

    services.cloudflared = {
        enable = true;
        tunnels."the-pipe" = {
            credentialsFile = config.sops.secrets."cloudflare-tunnel-creds".path;
            default = "https://127.0.0.1:443";
            originRequest.noTLSVerify = true;
        };
    };

    # hi im cloudflared i need an user and im stupid
    users.users.cloudflared = {
        isSystemUser = true;
        group = "cloudflared";
    };
    users.groups.cloudflared = {};
    sops.secrets."cloudflare-tunnel-creds" = {
        owner = "cloudflared";
        group = "cloudflared";
        mode = "0640";
    };
}

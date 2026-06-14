{ config, pkgs, lib, ... }:

let

    subdomain = "git";
    port = "3000";

    # leave this be
    domain = "muntyq.com";
    localIP = "192.168.1.45";
    tunnel = "piper";

in {
    services.forgejo = {
        enable = true;
        database.type = "sqlite3";

        settings = {
            server = {
                DOMAIN = "${subdomain}.${domain}";
                ROOT_URL = "https://${subdomain}.${domain}/";
                HTTP_PORT = lib.toInt port;
            };
        service.DISABLE_REGISTRATION = false;
        };
    };

    # public; cloudflared + nginx
    services.cloudflared.tunnels."${tunnel}".ingress."${subdomain}.${domain}" = "http://localhost:80";
    services.nginx.virtualHosts."${subdomain}.${domain}" = {
        useACMEHost = "${domain}";
        locations."/".proxyPass = "http://127.0.0.1:${port}";
    };
}

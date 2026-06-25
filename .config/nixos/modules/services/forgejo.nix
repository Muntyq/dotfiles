{ config, pkgs, lib, local_ip, ... }:

let

    subdomain = "git";
    port = "3000";
    sshPort = 2222;

    # leave this be
    domain = "muntyq.com";
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
                SSH_PORT = sshPort;
                SSH_LISTEN_PORT = sshPort;
            };
        service.DISABLE_REGISTRATION = true;
        };
    };

    networking.firewall.allowedTCPPorts = [ sshPort ];

    # public; cloudflared + nginx
    services.cloudflared.tunnels."${tunnel}".ingress."${subdomain}.${domain}" = "http://localhost:80";
    services.nginx.virtualHosts."${subdomain}.${domain}" = {
        useACMEHost = "${domain}";
        locations."/".proxyPass = "http://127.0.0.1:${port}";
    };
}

{ config, pkgs, lib, ... }:

let

    domain = "muntyq.com";
    localIP = "192.168.1.45";
    subdomain = "status";
    port = "3001";

in {

    services.uptime-kuma = {
        enable = true;
        settings = {
            PORT = "${port}";
            HOST = "127.0.0.1";
        };
    };

    # public; cloudflared + nginx
    services.cloudflared.tunnels."${tunnel}".ingress."${subdomain}.${domain}" = "http://localhost:80";
    services.nginx.virtualHosts."${subdomain}.${domain}" = {
        useACMEHost = "${domain}";
        locations."/".proxyPass = "http://127.0.0.1:${port}";
    };
}

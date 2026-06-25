{ config, pkgs, lib, local_ip, ... }:

let

    subdomain = "status";
    port = "3001";

    # leave this be
    domain = "muntyq.com";
    tunnel = "piper";

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

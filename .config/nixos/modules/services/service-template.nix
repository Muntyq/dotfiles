{ config, pkgs, lib, local_ip, ... }:

let

    subdomain = "SUBDOMAIN";
    port = "PORT";

    # leave this be
    domain = "muntyq.com";
    tunnel = "piper";

in {

    # youre app

    # local; blocky + nginx
    services.blocky.settings.customDNS.mapping."${subdomain}${domain}" = "${local_ip}";
    services.nginx.virtualHosts = {
        "status.${domain}" = {
            useACMEHost = "${domain}";
            forceSSL = true;
            locations."/" = {
              proxyPass = "http://127.0.0.1:${port}";
              # proxyWebsockets = true; # if needed
          };
        };
    };

    # public; cloudflared + nginx
    services.cloudflared.tunnels."${tunnel}".ingress."${subdomain}.${domain}" = "http://localhost:80";
    services.nginx.virtualHosts."${subdomain}.${domain}" = {
        useACMEHost = "${domain}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:${port}";
          # proxyWebsockets = true; # if needed
    };
}

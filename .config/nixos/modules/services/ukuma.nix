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

    # local; blocky + nginx
    services.blocky.settings.customDNS.mapping."${subdomain}.${domain}" = "${localIP}";

    services.nginx.virtualHosts = {

        "${subdomain}.${domain}" = {
            useACMEHost = "${domain}";
            forceSSL = true;
            locations."/".proxyPass = "http://127.0.0.1:${port}";
        };
    };
}

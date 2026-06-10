{ config, lib, ... }: {

    services.uptime-kuma = {
        enable = true;
        settings.PORT = "3001"; # default 3001
    };

    services.nginx.virtualHosts."status.muntyq.com" = {
        useACMEHost = "muntyq.com";
        forceSSL = true;
        locations."/" = {
            proxyPass = "http://127.0.0.1:3001";
            proxyWebsockets = true;
        };
    };
}

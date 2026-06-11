{ config, lib, ... }: {

    services.gitea = {
        enable = true;
        stateDir = "/var/lib/gitea";

        settings = {
            server = {
                DOMAIN = "git.muntyq.com";
                ROOT_URL = "https://git.muntyq.com";
                HTTP_ADDR = "127.0.0.1";
                HTTP_PORT = 3000;

                START_SSH_SERVER = true;
                SSH_DOMAIN = "git.muntyq.com";
                SSH_PORT = 2222;
                SSH_LISTEN_PORT = 2222;
            };

            service = {
                DISABLE_REGISTRATION = false;
            };

            log.LEVEL = "Warn";
        };
    };

    services.nginx.virtualHosts."git.muntyq.com" = {
        useACMEHost = "muntyq.com";
        forceSSL = true;
        locations."/" = {
            proxyPass = "http://127.0.0.1:3000";
            proxyWebsockets = true;
        };
    };

    networking.firewall.allowedTCPPorts = [ 2222 ];
}

{ config, lib, ... }: {

    services.pihole-ftl = {
        enable = true;
        openFirewallDNS = true;
        settings = {
            dns.upstreams = [ "1.1.1.1" "8.8.8.8" ];
            webserver.port = lib.mkForce "127.0.0.1:8080";
            webserver.domain = lib.mkForce "dns.muntyq.com";
        };
        lists = [
            {
                url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt";
                type = "block";
                enabled = true;
                description = "hagezi blocklist";
            }
            {
                url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/ultimate.txt";
                type = "block";
                enabled = true;
                description = "ultimate block";
            }
        ];
    };

    services.pihole-web = {
        enable = true;
    };

    services.nginx.virtualHosts."dns.muntyq.com" = {
        useACMEHost = "muntyq.com";
        forceSSL = true;
        locations."/" = {
            proxyPass = "http://127.0.0.1:8080";
            proxyWebsockets = true;
        };
    };

    services.resolved = {
        enable = false;
    };
}

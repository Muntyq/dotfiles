{ config, pkgs, lib, ... }:

let

    domain = "muntyq.com";
    localIP = "192.168.1.45";
    interface = "end0"; # for @core enp3s0
    tunnel = "piper";

in {

    # Network setup + ports ----------------------------
    networking = {
        interfaces."${interface}".ipv4.addresses = [{
            address = "${localIP}";
            prefixLength = 24;
        }];
        defaultGateway = "192.168.1.1";
        nameservers = [ "127.0.0.1" ];

        firewall = {
            enable = true;
            allowedTCPPorts = [ 80 443 ]; # nginx
            interfaces."${interface}" = {
                allowedTCPPorts = [ 22 ]; # ssh
                allowedUDPPorts = [ 53 ]; # default web search
            };
        };
    };

    security.acme = {
        acceptTerms = true;
        defaults.email = "aleix.muntal78@gmail.com";

        certs."${domain}" = {
            domain = "*.${domain}";
            extraDomainNames = [ "${domain}" ];
            dnsProvider = "cloudflare";
            credentialFiles = {
                CF_DNS_API_TOKEN_FILE = config.sops.secrets."cloudflare-api-token".path;
            };
            webroot = null; # DNS only, no web
            dnsPropagationCheck = true;
        };
    };
    # sops searches user at build time but it only gets created at run time, declaring the group fixes it
    users.users.nginx.extraGroups = [ "acme" ];
    sops.secrets."cloudflare-api-token".owner = "acme";


    # Cloudflared setup -------------------------------------

    services.cloudflared = {
        enable = true;
        tunnels."${tunnel}"= {
            credentialsFile = config.sops.secrets."cloudflare-tunnel-creds".path;
            ingress = {
                # per service configuration (check template)
                default = "http_status:404";
            };
            default = "http_status:404";
        };
    };

    systemd.services.cloudflared = {
        # "after", "wants" and "requires" probably inecesary, too scared to touch
        # on reboot it usually fails anyways, restart is there that reason
        after = [ "blocky.service" "network-online.target" ];
        wants = [ "blocky.service" "network-online.target" ];
        requires = [ "blocky.service" ];
        serviceConfig = {
            Restart = "on-failure";
            RestartSec = 30;
            StartLimitBurst = 5;
            StartLimitIntervalSec = 60;
        };
    };

# ditto of cloudflare-api-token
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


    # Blocky ------------------------------------------------

    services.blocky = {
        enable = true;

        settings = {
            ports.dns = 53;

            upstreams.groups.default = [
                "1.1.1.1"
                "1.0.0.1"
            ];

            blocking.denylists.ads = [
                "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/ultimate.txt"
                "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
                "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt"
                "https://perflyst.github.io/PiHoleBlocklist/SmartTV.txt"
            ];

            blocking.clientGroupsBlock.default = [ "ads" ];
            bootstrapDns = {
                upstream = "https://1.1.1.1/dns-query";
                ips = [ "1.1.1.1" "1.0.0.1" ];
            };
        };
    };

    # needs online to fetch block lists
    systemd.services.blocky = {
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
    };

    # port conflict with resolved
    services.resolved.enable = false;

    # Nginx --------------------------------------------

    services.nginx.enable = true;

    # per-service configuration (check template)
}

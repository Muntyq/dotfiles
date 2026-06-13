{ config, pkgs, lib, ... }:

let
  domain = "muntyq.com";
  localIP = "192.168.1.45";
    interface = "end0"; # for @core enp3s0
in
{
  networking = {
    interfaces."${interface}".ipv4.addresses = [{
      address = "${localIP}";
      prefixLength = 24;
    }];
    defaultGateway = "192.168.1.1";
    nameservers = [ "127.0.0.1" ];

    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 ];
      interfaces."${interface}" = {
        allowedTCPPorts = [ 22 ];
        allowedUDPPorts = [ 53 ];
      };
    };
  };

    # services.pihole-ftl = {
    #     enable = true;
    #     openFirewallDNS = true;
    #     settings = {
    #         dns = {
    #             upstreams = [ "1.1.1.1" "8.8.8.8" ];
    #             hosts = [
    #                 "git.${domain} ${localIP}"
    #                 "status.${domain} ${localIP}"
    #                 "dns.${domain} ${localIP}"
    #                 "hs.${domain} ${localIP}"
    #             ];
    #         };
    #     };
    #     lists = [
    #         {
    #             url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt";
    #             type = "block";
    #             enabled = true;
    #             description = "hagezi blocklist";
    #         }
    #         {
    #             url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/ultimate.txt";
    #             type = "block";
    #             enabled = true;
    #             description = "ultimate block";
    #         }
    #     ];
    # };
    #
    # services.pihole-web = {
    #     enable = true;
    #     ports = [ "8000" ];
    # };
  # ============================================
  # BLOCKY — DNS ad blocking (native nixpkgs)
  # ============================================
systemd.services.blocky = {
  after = [ "network-online.target" ];
  wants = [ "network-online.target" ];
};
  services.blocky = {
    enable = true;

    settings = {
      ports.dns = "0.0.0.0:53";

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

      customDNS.mapping = {
        "git.${domain}" = "${localIP}";
        "status.${domain}" = "${localIP}";
        "vault.${domain}" = "${localIP}";
        "notes.${domain}" = "${localIP}";
      };
    };
  };

  # ============================================
  # NGINX — Same domain names for everyone
  # ============================================

  services.nginx = {
    enable = true;

    virtualHosts = {
      # Public: accessible from internet via Cloudflare
      "git.${domain}" = {
        listen = [ { addr = "0.0.0.0"; port = 80; } ];
        locations."/".proxyPass = "http://127.0.0.1:3000";
      };

      "status.${domain}" = {
        listen = [ { addr = "0.0.0.0"; port = 80; } ];
        locations."/".proxyPass = "http://127.0.0.1:3001";
      };

      # Private: accessible locally + via Headscale
      "dns.${domain}" = {
        listen = [ { addr = "0.0.0.0"; port = 80; } ];
        locations."/".proxyPass = "http://127.0.0.1:8000";
      };

      "notes.${domain}" = {
        listen = [ { addr = "0.0.0.0"; port = 80; } ];
        locations."/".proxyPass = "http://127.0.0.1:8001";
      };
    };
  };

  # ============================================
  # CLOUDFLARE TUNNEL — Only public services
  # ============================================

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

  services.cloudflared = {
    enable = true;
    tunnels = {
      "piper" = {
        credentialsFile = config.sops.secrets."cloudflare-tunnel-creds".path;
        ingress = {
          "git.${domain}" = "http://localhost:80";
            "hs.${domain}" = "http://localhost:80";
          "status.${domain}" = "http://localhost:80";
          # vault and notes NOT here — they stay private
          default = "http_status:404";
        };
        default = "http_status:404";
      };
    };
  };

  # ============================================
  # HEADSCALE — Updated config format
  # ============================================

  services.headscale = {
    enable = true;

    settings = {
      server_url = "https://hs.${domain}";
      listen_addr = "0.0.0.0:8080";
      ip_prefixes = [ "100.64.0.0/10" ];

      dns = {
        base_domain = "${domain}";
        nameservers.global = [ "${localIP}" ];
        extra_records = [
          { name = "vault.${domain}"; type = "A"; value = "${localIP}"; }
          { name = "notes.${domain}"; type = "A"; value = "${localIP}"; }
          # { name = "status.${domain}"; type = "A"; value = "${localIP}"; }
        ];
      };
    };
  };

  services.nginx.virtualHosts."hs.${domain}" = {
    listen = [ { addr = "0.0.0.0"; port = 80; } ];
    locations."/".proxyPass = "http://127.0.0.1:8080";
  };

  services.uptime-kuma = {
    enable = true;
    settings = {
      PORT = "3001";
      HOST = "127.0.0.1";
    };
  };
    services.gitea = {
        enable = true;
        settings = {
          server = {
            DOMAIN = "git.${domain}";
            ROOT_URL = "https://git.${domain}";
            HTTP_PORT = 3000;
          };
        };
    };
}

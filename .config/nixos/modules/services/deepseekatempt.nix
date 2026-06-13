{ config, pkgs, ... }:

let
  domain = "muntyq.com";
  localIP = "192.168.1.45";
in
{
  networking = {
    interfaces.end0.ipv4.addresses = [{
      address = "${localIP}";
      prefixLength = 24;
    }];
    defaultGateway = "192.168.1.1";
    nameservers = [ "127.0.0.1" ];

    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 ];
      interfaces.end0 = {
        allowedTCPPorts = [ 22 ];
        allowedUDPPorts = [ 53 ];
      };
    };
  };

  # ============================================
  # BLOCKY — DNS ad blocking (native nixpkgs)
  # ============================================

  services.blocky = {
    enable = true;

    settings = {
      ports.dns = "0.0.0.0:53";

      upstreams.groups.default = [
        "1.1.1.1"
        "1.0.0.1"
      ];

      blocking.blackLists.ads = [
        "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
      ];

      blocking.clientGroupsBlock.default = [ "ads" ];

      customDNS.mapping = {
        "git.${domain}" = "${localIP}";
        "status.${domain}" = "${localIP}";
        "vault.${domain}" = "${localIP}";
        "notes.${domain}" = "${localIP}";
      };
    };
  };

  # ============================================
  # PI-HOLE — Resolve all your domains locally
  # ============================================

  # services.piholeftl = {
  #   enable = true;
  #   interface = "0.0.0.0";
  #   upstreamDNS = [ "1.1.1.1" ];
  #   adlists = [
  #     "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
  #   ];
  #
  #   # All your services resolve to your server locally
  #   customDNS = {
  #     "git.${domain}" = "${localIP}";
  #     "status.${domain}" = "${localIP}";
  #     # "vault.${domain}" = ${localIP};
  #     # "notes.${domain}" = ${localIP};
  #   };
  # };

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
      "vault.${domain}" = {
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
      server_url = "https://headscale.${domain}";
      listen_addr = "127.0.0.1:8080";
      ip_prefixes = [ "100.64.0.0/10" ];

      dns = {
        base_domain = "${domain}";
        nameservers.global = [ "${localIP}" ];
        extra_records = [
          { name = "vault.${domain}"; type = "A"; value = "${localIP}"; }
          { name = "notes.${domain}"; type = "A"; value = "${localIP}"; }
        ];
      };
    };
  };

  services.nginx.virtualHosts."headscale.${domain}" = {
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
}

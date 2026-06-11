{ config, lib, ... }: {

  # acme
    security.acme = {
        acceptTerms = true;
        defaults.email = "munty@muntyq.com";

        certs."muntyq.com" = {
            domain = "*.muntyq.com";
            extraDomainNames = [ "muntyq.com" ];
            dnsProvider = "cloudflare";
            credentialFiles = {
                CF_DNS_API_TOKEN_FILE = config.sops.secrets."cloudflare-api-token".path;
            };
            webroot = null; # DNS only, no web
            dnsPropagationCheck = true;
        };
    };

    #nginx
    services.nginx = {
        enable = true;
        recommendedTlsSettings = true;
        recommendedOptimisation = true;
        recommendedGzipSettings = true;
        recommendedProxySettings = true;

        # Default catch-all
        virtualHosts."_" = {
            default = true;
            rejectSSL = true;
        };

        # Skeleton vhost — uncomment and duplicate per service
        # virtualHosts."service.muntyq.com" = {
        #   useACMEHost = "muntyq.com";
        #   forceSSL    = true;
        #   locations."/" = {
        #     proxyPass = "http://127.0.0.1:<port>";
        #   };
        # };
    };

    users.users.nginx.extraGroups = [ "acme" ];
    sops.secrets."cloudflare-api-token".owner = "acme";
    networking.firewall.allowedTCPPorts = [ 80 443 ];
}

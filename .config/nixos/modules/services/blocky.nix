{ config, lib, ... }: {

    services.blocky = {
        enable = true;
        settings = {
            ports.dns = 53;

            upstreams.groups.default = [
                "1.1.1.1"
                "8.8.8.8"
            ];

            blocking = {
                denylists = {
                    ads = [
                        "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
                        "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/domains/ultimate.txt"
                    ];
                    custom = [
                    ];
                };
                clientGroupsBlock.default = [ "ads" "custom" ];
            };

            bootstrapDns = {
                upstream = "https://1.1.1.1/dns-query";
                ips = [ "1.1.1.1" "1.0.0.1" ];
            };

            queryLog = {
                type = "console";
                target = "stdout";
            };
        };
    };

    networking.firewall = { # 53 = default dns port
        allowedTCPPorts = [ 53 ];
        allowedUDPPorts = [ 53 ];
    };
    networking.nameservers = [ "127.0.0.1" ]; # 1.1.1.1 is from headscale
}

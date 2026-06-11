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
                blackList.ads = [
                    "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
                ];
                clientGroupsBlock.default = [ "ads" ];
            };

            bootstrapDns = {
                upstream = "https://1.1.1.1/dns-querry";
                ips = [ "1.1.1.1"];
            };
        };
    };

    networking.firewall = { # 53 = default dns port
        allowedTCPPorts = [ 53 ];
        allowedUDPPorts = [ 53 ];
    };
}

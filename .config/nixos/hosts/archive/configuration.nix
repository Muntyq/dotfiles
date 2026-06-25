{ inputs, hostname, ... }: {

    imports = [
        ./hardware-configuration.nix
        ../../modules/minimum.nix
    ];

    networking.hostName = "${hostname}";
    system.stateVersion = "25.11";
}

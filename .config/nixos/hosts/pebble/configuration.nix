{ inputs, hostname, ... }: {

    imports = [
        ./hardware-configuration.nix
        inputs.nixos-hardware.nixosModules.raspberry-pi-4
        ../../modules/minimum.nix
    ];

    networking.hostName = "${hostname}";
    system.stateVersion = "25.11";
}

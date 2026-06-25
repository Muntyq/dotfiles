{ inputs, hostname, ... }: {

    imports = [
        ./hardware-configuration.nix
        inputs.home-manager.nixosModules.home-manager
        ../../modules/minimum.nix
        ../../modules/drivers/cpu-intel.nix
        ../../modules/drivers/gpu-nvidia.nix
    ];

    nix.settings.secret-key-files = [ "/etc/nix/secret-key.pem" ];

    networking.hostName = "${hostname}";
    system.stateVersion = "25.11";
}

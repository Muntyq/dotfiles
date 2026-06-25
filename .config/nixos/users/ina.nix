{ config, pkgs, hostname, lib, ... }: {

    users.users.ina = {
        isNormalUser = true;
        home = "/home/ina";
        description = "AI";
        hashedPasswordFile = config.sops.secrets."user-password".path;
        extraGroups = [
            "wheel"
            "networkmanager"
        ];
        shell = pkgs.bash;
        openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBrw5YYLJvCartvAP/eBQGIOgulLgiwAJgJa6rd8uODY ina@core"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKDpxzJPm4etFbyz1Z3Fxe26CUP3ZcX4czrINouAG1rH ina@proxy"
        ];
    };
}

{ pkgs, userProfile, ... }: {

    programs.steam = {
        enable = true;
        dedicatedServer.openFirewall = true;
    };

    hardware.opentabletdriver.enable = true;

    home-manager.users.${userProfile}.home.packages = with pkgs; [
        protonplus
        prismlauncher
        osu-lazer-bin
    ];
}

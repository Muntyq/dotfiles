{ pkgs, username, ... }: {

    programs.steam = {
        enable = true;
        dedicatedServer.openFirewall = true;
    };

    hardware.opentabletdriver.enable = true;

    home-manager.users.${username}.home.packages = with pkgs; [
        protonplus
        protontricks
        prismlauncher
        osu-lazer-bin
    ];
}

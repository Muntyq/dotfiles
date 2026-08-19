{ pkgs, username, ... }: {

    programs.steam = {
        enable = true;
        dedicatedServer.openFirewall = true;
        protontricks.enable = true;
    };

    hardware.opentabletdriver.enable = true;

    home-manager.users.${username}.home.packages = with pkgs; [
        protonplus
        prismlauncher
        osu-lazer-bin
        steam-run
        discord
        vesktop
    ];
}

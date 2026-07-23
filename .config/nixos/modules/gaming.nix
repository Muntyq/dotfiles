{ pkgs, username, ... }: {

    programs.steam = {
        enable = true;
        dedicatedServer.openFirewall = true;
    };

    environment.systemPackages = with pkgs; [
        protontricks
    ];

    hardware.opentabletdriver.enable = true;

    home-manager.users.${username}.home.packages = with pkgs; [
        protonplus
        prismlauncher
        osu-lazer-bin
    ];
}

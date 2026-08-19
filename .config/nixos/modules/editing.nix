{ pkgs, username, ... }:	{

    home-manager.users.${username}.home.packages = with pkgs; [
        krita
        inkscape
        kdePackages.kdenlive
        shotcut
        obs-studio
    ];
}

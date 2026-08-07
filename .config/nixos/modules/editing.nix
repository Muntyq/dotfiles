{ pkgs, username, ... }:	{

    home-manager.users.${username}.home.packages = with pkgs; [
        krita
        inkscape
        kdePackages.kdenlive
        shotcut
    ];

    programs.obs-studio.enable = true;
}

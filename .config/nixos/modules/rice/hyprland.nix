{ pkgs, username, ... }: {

    # Rice dependant packages --------------------------
    home-manager.users.${username} = {
        home.packages = with pkgs; [
            wofi       # app launcher
            hyprpicker # color picker
            hyprshot   # screenshots
            hyprpaper  # wallpapers
            dunst      # notifications

            # testing
            foot
            river
        ];

        programs.vesktop.enable = true;

    # Font ---------------------------------------------
        fonts.fontconfig = {
            enable = true;
            defaultFonts = {
                monospace = [ "Hack Nerd Font Mono" "Zen Kaku Gothic New" ];
                sansSerif = [ "Exo 2" "Zen Kaku Gothic New" ];
                serif = [ "Exo 2" "Zen Kaku Gothic New" ];
            };
        };
    };
    # Compositor & window manager (Hyprland) -----------

    programs.hyprland = {
        enable = true;
        withUWSM = true;
    };
    programs.uwsm.enable = true;

    # Login (Sddm) -------------------------------------

    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;

    # Cursor -------------------------------------------

    environment.sessionVariables = {
        XCURSOR_THEME = "Nordzy-cursors";
        XCURSOR_SIZE = "24";
    };

    # Wayland general things ---------------------------
    # commented = already declared in wm / compositor

    xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
            xdg-desktop-portal-gtk
            #xdg-desktop-portal-wlr
            #xdg-desktop-portal-hyprland
        ];
    };

    environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        # MOZ_ENABLE_WAYLAND = "1";
        # QT_QPA_PLATFORM = "wayland;xcb";
        # GDK_BACKEND = "wayland,x11";
        # SDL_VIDEODRIVER = "wayland";
        # CLUTTER_BACKEND = "wayland";
    };
}

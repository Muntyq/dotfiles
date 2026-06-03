
{ pkgs, userProfile, ... }: {
	
	home-manager.users.${userProfile}.home.packages = with pkgs; [
		wofi       # app launcher
		dunst      # notifications
	];
	
	environment.systemPackages = with pkgs; [
		river
	];

	# Compositor & window manager (Hyprland)

	programs.uwsm = {
		enable = true;
		waylandCompositors.river = {
			prettyName = "River";
			comment = "River + uwsm";
			binPath = "/run/current-system/sw/bin/river";
		};
	};
	
	# Login (Sddm)

	services.displayManager.sddm.enable = true;
	services.displayManager.sddm.wayland.enable = true;

	# Wayland general things

	xdg.portal = {
		enable = true;
		extraPortals = with pkgs; [
			xdg-desktop-portal-gtk
			xdg-desktop-portal-wlr
		];
	};
	
	environment.sessionVariables = {
		NIXOS_OZONE_WL = "1";
		MOZ_ENABLE_WAYLAND = "1";
		QT_QPA_PLATFORM = "wayland;xcb";
		GDK_BACKEND = "wayland,x11";
		SDL_VIDEODRIVER = "wayland";
		CLUTTER_BACKEND = "wayland";
	};
}

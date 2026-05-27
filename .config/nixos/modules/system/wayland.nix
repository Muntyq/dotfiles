{ config, pkgs, ... }:

{
	i18n.inputMethod = {
		enable = true;
		type = "fcitx5";
		fcitx5.waylandFrontend = true;
		fcitx5.addons = with pkgs; [
			fcitx5-mozc
			fcitx5-gtk
		];
	};

	services.dbus.enable = true;

	xdg.portal = {
		enable = true;
		extraPortals = with pkgs; [
			xdg-desktop-portal-gtk
			#xdg-desktop-portal-wlr
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

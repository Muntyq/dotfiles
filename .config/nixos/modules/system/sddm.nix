{ config, pkgs, ... }:

{
	# Display manager ( SDDM ) and window manager ( hyprland for now, will switch to river once i fure out how it works )
	services.displayManager.sddm.enable = true;
	services.displayManager.sddm.wayland.enable = true;
}

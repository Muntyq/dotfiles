{ config, pkgs, ... }:

{
	hardware.nvidia = {
		modesetting.enable = true;
		powerManagement.enable = false;
		open = true;
		nvidiaSettings = true;
		package = config.boot.kernelPackages.nvidiaPackages.stable;
	};

	hardware.graphics = {
		enable = true;
		enable32Bit = true;
	};

	services.xserver.videoDrivers = ["nvidia"];

	environment.sessionVariables = {
		NIXOS_OZONE_WL = "1";
		GBM_BACKEND = "nvidia-drm";
		__GLX_VENDOR_LIBRARY_NAME = "nvidia";
		WLR_NO_HARDWARE_CURSORS = "1";
	}
}

{ config, pkgs, ... }:

{
	# Bootloader config
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
	boot.loader.systemd-boot.configurationLimit = 9;

	systemd.targets = {
		sleep.enable = true;
		suspend.enable = true;
		hibernate.enable = true;
		hybrid-sleep.enable = true;
	};

	# Use specific kernel
	# boot.kernelPackages = pkgs.linuxPackages_latest;
}

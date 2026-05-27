# NIXOS

Remember to run nixos-generate-config during installation on desktop and everywhere
Remember to add /etc/sops/keys.txt with chmod 600 permissions
Fix duplicate bug in storage.nix

## Re-check all the shit made by Claude
-commands, propierties, text, and the UUID thing
-ask for swap

## to do (not necessary in order dont need to adress them if not asked about)
[x] - Add home manager and configure it (basic setup)
[x] - Configure home manager further
[ ] - Add instructions for mounting the desktop (has 2 SSDs and a HDD so it has a specific mounting and symlink configuration)
[x] - Add keys and such, with sops, for git, ssh etc
[ ] - Add overlays (if i need to, have to look them up)
[ ] - Add raspberry pi host and configure it
[ ] - Add generic host and configure it
[ ] - Automate pc instalation 
[ ] - LARP config, remove AI shit, polish setup
[ ] - Polish boot if startup slow ass shit, check it, add boot image thingy?
[ ] - Add server config
[ ] - Check dev spaces creation
[ ] - make a dotfiles tool with rust
[ ] - fix modularity issues; sops only for munty rn
[ ] - add config file (if its even possible)

## Current Setup

nixos/ {
	.git;
	README.md;
	flake.nix { https://github.com/Muntyq/dotfiles/blob/main/dot_config/nixos/flake.nix };
	flake.lock;
	modules/ {
		home/ {
			home-common.nix { https://github.com/Muntyq/dotfiles/blob/main/dot_config/nixos/modules/home/home-common.nix };
			gui-environment.nix { https://github.com/Muntyq/dotfiles/blob/main/dot_config/nixos/modules/home/gui-environment.nix };
			... // a bunch of modules for home apps
		};
		system/ {
			common-system.nix { https://github.com/Muntyq/nixos-config/blob/main/modules/system/common_system.nix };
			... // a bunch of modules for system apps
		};
		users/ {
			munty.nix { https://github.com/Muntyq/dotfiles/blob/main/dot_config/nixos/modules/users/munty.nix };
		};
	hosts/ {
		xps13/ {
			configuration.nix { https://github.com/Muntyq/dotfiles/blob/main/dot_config/nixos/hosts/xps13/configuration.nix };
			hardware-configuration.nix;
		};
		desktop/ { // pending to do };
	};
};

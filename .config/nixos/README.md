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

nixos-rebuild switch \
  --flake .config/nixos#pebble \
  --target-host munty@192.168.1.45 \
  --build-host munty@core \
  --elevate=sudo \
  --ask-elevate-password
## Current Setup

nixos/ {
	.git;
	README.md;
	flake.nix { https://github.com/Muntyq/dotfiles/blob/main/.config/nixos/flake.nix };
	flake.lock;
	secrets/ { munty.yaml; };
	sops.yaml { https://github.com/Muntyq/dotfiles/blob/main/.config/nixos/.sops.yaml };
	modules/ {
		gaming.nix { https://github.com/Muntyq/dotfiles/blob/main/.config/nixos/modules/gaming.nix };
		editing.nix { https://github.com/Muntyq/dotfiles/blob/main/.config/nixos/modules/editing.nix };
		general-apps.nix { https://github.com/Muntyq/dotfiles/blob/main/.config/nixos/modules/general-apps.nix };
		general-config.nix { https://github.com/Muntyq/dotfiles/blob/main/.config/nixos/modules/general-config.nix };
		sops.nix { https://github.com/Muntyq/dotfiles/blob/main/.config/nixos/modules/sops.nix };
		drivers / {
			cpu-intel.nix { https://github.com/Muntyq/dotfiles/blob/main/.config/nixos/modules/drivers/cpu-intel.nix };
			gpu-intel.nix { https://github.com/Muntyq/dotfiles/blob/main/.config/nixos/modules/drivers/gpu-intel.nix };
			gpu-nvidia.nix { https://github.com/Muntyq/dotfiles/blob/main/.config/nixos/modules/drivers/gpu-nvidia.nix };
		};
		rice / {
			hyprland.nix { https://github.com/Muntyq/dotfiles/blob/main/.config/nixos/modules/rice/hyprland.nix };
			river.nix { //to do };
		};
		users/ {
			munty.nix { https://github.com/Muntyq/dotfiles/blob/main/.config/nixos/modules/users/munty.nix };
		};
	hosts/ {
		xps13/ {
			configuration.nix { https://github.com/Muntyq/dotfiles/blob/main/.config/nixos/hosts/xps13/configuration.nix };
			hardware-configuration.nix;
		};
		desktop/ {
			configuration.nix { https://github.com/Muntyq/dotfiles/blob/main/.config/nixos/hosts/desktop/configuratioon.nix; };
			hardware-configuration.nix;
		};
	};
};

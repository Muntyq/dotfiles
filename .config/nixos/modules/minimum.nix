{ pkgs, lib, hostname, username, ... }: {


# ███████╗██╗   ██╗███████╗████████╗███████╗███╗   ███╗
# ██╔════╝╚██╗ ██╔╝██╔════╝╚══██╔══╝██╔════╝████╗ ████║
# ███████╗ ╚████╔╝ ███████╗   ██║   █████╗  ██╔████╔██║
# ╚════██║  ╚██╔╝  ╚════██║   ██║   ██╔══╝  ██║╚██╔╝██║
# ███████║   ██║   ███████║   ██║   ███████╗██║ ╚═╝ ██║
# ╚══════╝   ╚═╝   ╚══════╝   ╚═╝   ╚══════╝╚═╝     ╚═╝
# (imported from hosts)


    # Packages needed literally everywhere ---

    environment.systemPackages = with pkgs; [
            git
            neovim
            tmux
            wget
            iw
            curl
            sops
            nmap
            rsync
            age
            btop
            unar   # unzip
            dig
            fzf
    ];

    services.openssh.enable = true;
    programs.bash.enable = true;
    services.dbus = {
            enable = true;
            implementation = if hostname == "pebble" then "dbus" else "broker";
    };

    # Nix general configs --------------------

    nix.settings = {
            experimental-features = ["nix-command" "flakes" ];
            auto-optimise-store = true;
    };

    nix.gc = {
            automatic = true;
            dates = "Mon 06:00";
            options = "--delete-older-than 30d";
    };

    nixpkgs.config.allowUnfree = true;
    users.mutableUsers = false;

    security.sudo.extraRules = [{
        users = [ "${username}" ];
        commands = [{
            command = "/run/current-system/sw/bin/nixos-rebuild";
            options = [ "NOPASSWD" ];
        } {
        #     command = "/run/current-system/sw/bin/systemctl";
        #     options = [ "NOPASSWD" ];
        # } {
            command = "/run/current-system/sw/bin/reboot";
            options = [ "NOPASSWD" ];
        }];
    }];

    system.autoUpgrade = lib.mkIf ( hostname != "pebble" ) {
        enable = true;
        flake = "/home/${username}/.config/nixos";
        dates = "Sat *-*-* 06:00:00";
        persistent = true;
        allowReboot = true;
        operation = "switch"; # set to boot to not restart
    };

    # Bootloader config ----------------------

    boot = lib.mkIf ( hostname != "pebble" ) {
        resumeDevice = "/dev/disk/by-label/swap";
        loader = {
            efi.canTouchEfiVariables = true;
            timeout = 1;
            systemd-boot = {
                enable = true;
                configurationLimit = 9;
            };
        };
    };

    systemd.targets = lib.mkIf ( hostname != "pebble" ) {
        sleep.enable = true;
        suspend.enable = true;
        hibernate.enable = true;
        hybrid-sleep.enable = true;
    };
    # Use specific kernel
    # boot.kernelPackages = pkgs.linuxPackages_latest;

    # Locales --------------------------------

    time.timeZone = "Europe/Madrid";
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
        LC_ADDRESS = "es_ES.UTF-8";
        LC_IDENTIFICATION = "es_ES.UTF-8";
        LC_MEASUREMENT = "es_ES.UTF-8";
        LC_MONETARY = "es_ES.UTF-8";
        LC_NAME = "es_ES.UTF-8";
        LC_NUMERIC = "es_ES.UTF-8";
        LC_PAPER = "es_ES.UTF-8";
        LC_TELEPHONE = "es_ES.UTF-8";
        LC_TIME = "es_ES.UTF-8";
    };

}

# Config.nix
{
  proxy = {
    system = "x86_64-linux";
    username = "munty";
    local_ip = null;
    modules = [
      ./secrets/sops.nix
      ./modules/general.nix
      ./modules/rice/hyprland.nix
    ];
  };
  core = {
    system = "x86_64-linux";
    username = "munty";
    local_ip = null;
    modules = [
      ./secrets/sops.nix
      ./modules/editing.nix
      ./modules/general.nix
      ./modules/gaming.nix
      ./modules/rice/hyprland.nix
    ];
  };
  pebble = {
    system = "aarch64-linux";
    username = "ina";
    local_ip = "192.168.1.45";
    modules = [
      ./secrets/sops.nix
      ./modules/services/domain.nix
      ./modules/services/ukuma.nix
      ./modules/services/forgejo.nix
    ];
  };
  archive = {
    system = "x86_64-linux";
    username = "ina";
    local_ip = null;
    modules = [
      ./secrets/sops.nix
    ];
  };
}

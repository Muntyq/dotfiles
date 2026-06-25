{
    description = "Nix declaration for the INA SYSTEM MATRIX";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";
        nixos-hardware.url = "github:NixOS/nixos-hardware/master";

        home-manager = {
                url = "github:nix-community/home-manager";
                inputs.nixpkgs.follows = "nixpkgs";
        };

        sops-nix = {
                url = "github:Mic92/sops-nix";
                inputs.nixpkgs.follows = "nixpkgs";
        };

        inadev = {
            url = "https://git.muntyq.com/munty/inadev/archive/main.tar.gz";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        inote = {
            url = "https://git.muntyq.com/munty/inote/archive/main.tar.gz";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { nixpkgs, nixpkgs-stable, nixos-hardware, home-manager, sops-nix, inadev, inote, self, ... }@inputs:
    let
      profiles = import ./profiles.nix;

      mkSystem = hostname: { system, username, local_ip, modules }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs hostname username local_ip;
            stable = import nixpkgs-stable { inherit system; };
          };
          modules = [
            ./hosts/${hostname}/configuration.nix
            ./users/${username}.nix
            sops-nix.nixosModules.sops
          ] ++ modules;
        };
    in {
      nixosConfigurations = nixpkgs.lib.mapAttrs mkSystem profiles;
    };
}

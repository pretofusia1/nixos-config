{
  description = "NixOS configuration for preto";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations = {
        preto = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            {
              boot.loader.systemd-boot.enable = true;
              boot.loader.efi.canTouchEfiVariables = true;
            }
            ./hosts/preto/hardware-configuration.nix
            ./hosts/preto/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.preto = import ./home.nix;

              # Quickfix: ersetze fehlendes pkgs.replaceVars durch substituteAll
              nixpkgs.overlays = [
                (final: prev: {
                  replaceVars = file: vars: prev.substituteAll (vars // { src = file; });
                })
              ];
            }
          ];
        };
      };
    }
}

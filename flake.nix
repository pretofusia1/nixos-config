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
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        preto = lib.nixosSystem {
          inherit system;
          modules = [
            # UEFI-Boot
            ({ ... }: {
              boot.loader.systemd-boot.enable = true;
              boot.loader.efi.canTouchEfiVariables = true;
            })

            # Host-Module
            ./hosts/preto/hardware-configuration.nix
            ./hosts/preto/configuration.nix

            # Home Manager einbinden + mako-Override
            home-manager.nixosModules.home-manager
            ({ pkgs, ... }: {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.preto = { ... }: {
                # Upstream-HM-Modul für mako deaktivieren,
                # stattdessen lokales Modul benutzen
                disabledModules = [ "services/mako.nix" ];
                imports = [
                  ./home.nix
                  ./hm-overrides/services/mako.nix
                ];
              };
            })

            # Overlay: pkgs.replaceVars als Alias für substituteAll bereitstellen
            ({ ... }: {
              nixpkgs.overlays = [
                (final: prev: {
                  replaceVars = file: vars: prev.substituteAll (vars // { src = file; });
                })
              ];
            })
          ];
        };
      };
    };
}

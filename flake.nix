{
  description = "NixOS configuration for preto";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
    in {
      nixosConfigurations.preto = lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/preto/hardware-configuration.nix
          ./hosts/preto/configuration.nix

          home-manager.nixosModules.home-manager
          ({ pkgs, ... }: {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # Kein disabledModules/Override mehr nötig:
            home-manager.users.preto = import ./home.nix;
          })

          # Overlay (falls du es brauchst) lassen wir drin:
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
}

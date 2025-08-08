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
      pkgs = import nixpkgs { inherit system; };
    in {
      nixosConfigurations = {
        preto = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            { boot.loader.systemd-boot.enable = true; boot.loader.efi.canTouchEfiVariables = true; boot.loader.grub.enable = false; }
            ./hosts/preto/hardware-configuration.nix
            ./hosts/preto/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.preto = import ./home.nix;
            }
          ];
        };
      };
    };
}

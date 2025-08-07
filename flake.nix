{
  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      nixosConfigurations = {
        preto = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
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

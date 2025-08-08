{
  description = "NixOS config (preto) with HM 24.05 and mako override";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    # HM passend zu 24.05
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
  in {
    nixosConfigurations.preto = lib.nixosSystem {
      inherit system;

      specialArgs = { inherit inputs; };

      modules = [
        # Dein bisheriger Host-Stack (Datei/Ordner muss es bei dir geben)
        ./nixos

        # Bootloader klar auf UEFI + systemd-boot festnageln (GRUB hart aus)
        ({ lib, ... }: {
          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;
          boot.loader.grub.enable = lib.mkForce false;

          # nix / flakes QoL
          nix.settings.experimental-features = [ "nix-command" "flakes" ];

          # passt zur verwendeten Release
          system.stateVersion = "24.05";
        })

        # Home Manager einhängen + mako-Override aktivieren
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.preto = {
            # HM-Standardmodul für mako deaktivieren und unser Override laden
            disabledModules = [ "services/mako.nix" ];
            imports = [ ./hm-overrides/services/mako.nix ];

            home.username = "preto";
            home.homeDirectory = "/home/preto";
            programs.home-manager.enable = true;

            # Beispiel: mako einschalten; Settings kommen im INI-Format
            services.mako = {
              enable = true;
              settings = {
                # Trag hier deine Werte ein – z.B.:
                # [global]
                # sort = "newest-first";
                # icon_path = "/usr/share/icons";
              };
            };

            home.stateVersion = "24.05";
          };
        }
      ];
    };
  };
}

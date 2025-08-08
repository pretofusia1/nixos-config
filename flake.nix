{
  description = "preto - NixOS flake (nixos-24.05 + HM 24.05, systemd-boot, optional mako override)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    # Home Manager passend zu 24.05 pinnen
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";

      # Overlay: pkgs.lib.replaceVars {key="val";} "hey ${key}"
      replaceVarsOverlay = (final: prev: {
        lib = prev.lib.extend (finalLib: prevLib: {
          replaceVars = vars: s:
            let
              keys = builtins.attrNames vars;
              vals = builtins.attrValues vars;
              pats = map (k: "\${${k}}") keys;
            in prevLib.strings.replaceStrings pats vals s;
        });
      });

      # Host-Modul automatisch finden (pass bei Bedarf an)
      hostModule =
        if builtins.pathExists ./hosts/preto/configuration.nix then ./hosts/preto/configuration.nix
        else if builtins.pathExists ./configuration.nix then ./configuration.nix
        else throw "flake.nix: Konnte keine configuration.nix finden. Lege sie unter ./hosts/preto/configuration.nix oder ./configuration.nix ab, oder editiere hostModule.";

      # Optionaler HM-Override für mako
      hmMakoModule =
        if builtins.pathExists ./hm-overrides/services/mako.nix then ./hm-overrides/services/mako.nix
        else null;

    in {
      nixosConfigurations.preto = nixpkgs.lib.nixosSystem {
        inherit system;
        # Falls Module 'inputs' brauchen
        specialArgs = { inherit inputs; };

        modules = [
          hostModule

          # Basismodul mit Bootloader, Overlays & Home Manager
          {
            # UEFI: systemd-boot statt grub
            boot.loader.systemd-boot.enable = true;
            boot.loader.efi.canTouchEfiVariables = true;

            # Overlay global aktivieren (nur falls benötigt)
            nixpkgs.overlays = [ replaceVarsOverlay ];

            # Home Manager als NixOS-Modul
            imports = [
              home-manager.nixosModules.home-manager
            ];

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;

              # unseren mako-Override nur einbinden, wenn vorhanden
              sharedModules =
                [] ++ (if hmMakoModule != null then [ hmMakoModule ] else []);
            };
          }
        ];
      };
    };
}

{ config, pkgs, ... }:

{
  # WICHTIG: Hardware-Config importieren, damit u.a. fileSystems."/” vorhanden ist
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "preto";
  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "de_DE.UTF-8";
  console.keyMap = "de";

  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  users.users.preto = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  system.stateVersion = "24.05";
}

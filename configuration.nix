{ config, pkgs, ... }:

{
  # Hier alle deine bisherigen Einstellungen,
  # nur ohne `imports = [ ./hardware-configuration.nix ];`
  # Beispiel aus deiner hochgeladenen Datei:
  
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

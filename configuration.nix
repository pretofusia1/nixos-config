{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "nixos";
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";

  services.xserver.enable = true;
  services.xserver.displayManager.greetd.enable = true;
  services.xserver.windowManager.hyprland.enable = true;

  users.users.preto = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "changeme"; # beim ersten Login ändern!
  };

  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    git
    vim
    curl
    wget
  ];

  system.stateVersion = "24.05";
}

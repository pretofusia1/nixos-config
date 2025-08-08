{ config, pkgs, ... }:

{
  home.username = "preto";
  home.homeDirectory = "/home/preto";

  # Disable upstream Home Manager mako module and import our fixed override
  disabledModules = [ "services/mako.nix" ];
  imports = [ ./hm-overrides/services/mako.nix ];

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    kitty
    waybar
    wofi
    dunst
    grim
    slurp
    hyprpaper
    fastfetch
    wl-clipboard
    pamixer
  ];

  xdg.configFile."hypr/hyprland.conf".source = ./config/hyprland.conf;
  xdg.configFile."hypr/hyprpaper.conf".source = ./config/hyprpaper.conf;
  xdg.configFile."waybar/config.jsonc".source = ./config/waybar/config.jsonc;
  xdg.configFile."waybar/style.css".source = ./config/waybar/style.css;

  xdg.configFile."hypr/scripts/wallpaper-wal.sh".source = ./scripts/wallpaper-wal.sh;
  xdg.configFile."hypr/scripts/fastfetch-colored.sh".source = ./scripts/fastfetch-colored.sh;
  xdg.configFile."hypr/scripts/screenshot-full.sh".source = ./scripts/screenshot-full.sh;
  xdg.configFile."hypr/scripts/screenshot-area.sh".source = ./scripts/screenshot-area.sh;

  home.file."Pictures/wallpapers".source = ./wallpapers;

  home.stateVersion = "24.05";
}

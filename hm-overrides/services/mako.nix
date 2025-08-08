{ config, lib, pkgs, ... }:

let
  cfg = config.services.mako;
  iniFormat = pkgs.formats.ini { };
in {
  options.services.mako = {
    enable = lib.mkEnableOption "mako notification daemon";
    settings = lib.mkOption {
      type = iniFormat.type;
      default = {};
      description = "INI-style settings written to ~/.config/mako/config";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.mako ];
    xdg.configFile."mako/config".source =
      iniFormat.generate "mako.conf" cfg.settings;
  };
}

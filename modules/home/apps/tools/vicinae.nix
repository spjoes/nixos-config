{ config, pkgs, lib, ... }:

let
  cfg = config.tools.vicinae;
in
{
  options.tools.vicinae = {
    enable = lib.mkEnableOption "Enable Vicinae for desktop";
  };

  config = lib.mkIf cfg.enable {
      services.vicinae = {
        enable = true;
        autoStart = true;
        settings = {
          theme.name = "catppuccin-mocha";
        };
    };
  };
}

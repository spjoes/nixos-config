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
        settings = {
          theme.name = "catppuccin-mocha";
        };
        systemd = {
          enable = true;
          autoStart = true;
          environment = {
            USE_LAYER_SHELL = 1;
          };
        };
    };
  };
}

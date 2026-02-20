{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.tools.rofi;
in {
  options.tools.rofi = {
    enable = lib.mkEnableOption "Enable Rofi for desktop";
  };

  config = lib.mkIf cfg.enable {
    # Themes are handled by catppuccin-nix module
    programs.rofi = let
      rasi = config.lib.formats.rasi;
      L = rasi.mkLiteral;
    in {
      enable = true;
      extraConfig = {
        modi = "drun";
        show-icons = true;
        display-drun = "Search Apps";
        drun-display-format = "{name}";
      };
      theme = {
        listview = {
          columns = 6; # number of columns
          lines = 5; # number of rows
          flow = L "horizontal"; # row-first ordering
          spacing = L "12px"; # gap between tiles
          fixed-columns = true; # keep grid shape
          fixed-height = true;
        };
        element = {
          orientation = L "vertical";
        };
        "element-text" = {horizontal-align = L "0.5";};
        "element-icon".size = L "2.4em";
      };
    };
  };
}

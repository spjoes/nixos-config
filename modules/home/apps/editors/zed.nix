{ config, pkgs, lib, ... }:

let
  cfg = config.editors.zed;
in
{
  options.editors.zed = {
    enable = lib.mkEnableOption "Enable the Zed editor";
  };

  config = lib.mkIf cfg.enable {
    # Themes are handled by catppuccin-nix module
    programs.zed-editor = {
      enable = true;
      extensions = [
        # Icons
        "catppuccin-icons"
      ];
    };
  };
}

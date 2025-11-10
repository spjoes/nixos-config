{ config, pkgs, lib, ... }:

let
  cfg = config.media.obs;
in
{
  options.media.obs = {
    enable = lib.mkEnableOption "Enable OBS Studio for streaming and recording";
  };

  config = lib.mkIf cfg.enable {
    # Themes are handled by catppuccin-nix module
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-tuna
        obs-multi-rtmp
      ];
    };
  };
}

{ config, pkgs, lib, ... }:

{
  programs.zed-editor = {
    enable = true;
    extensions = [
      # Themes
      "catppuccin"

      # Icons
      "catppuccin-icons"
    ]
  };
}

{ config, pkgs, lib, ... }:

{
  # Themes are handled by catppuccin-nix module
  programs.vscode = {
    enable = true;
    package = pkgs.code-cursor;
  };
}

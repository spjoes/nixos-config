{ config, pkgs, lib, ... }:

{
  # Themes are handled by catppuccin-nix module
  programs.vscode = {
    enable = true;
    package = pkgs.code-cursor;
    extensions = with pkgs.vscode-extensions; [
      eamodio.gitlens # GitLens
      jnoortheen.nix-ide # Nix IDE
      wakatime.vscode-wakatime # Wakatime
      # coderabbit.coderabbit-vscode # need to make a pr for this
    ];
  };
}

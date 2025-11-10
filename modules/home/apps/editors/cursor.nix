{ config, pkgs, lib, ... }:

let
  cfg = config.editors.cursor;
in
{
  options.editors.cursor = {
    enable = lib.mkEnableOption "Enable the Cursor editor";
  };

  config = lib.mkIf cfg.enable {
    # Themes are handled by catppuccin-nix module
    programs.vscode = {
      enable = true;
      package = pkgs.code-cursor;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          eamodio.gitlens # GitLens
          jnoortheen.nix-ide # Nix IDE
          wakatime.vscode-wakatime # Wakatime
          # coderabbit.coderabbit-vscode # need to make a pr for this
        ];
        userSettings = {
          # Sidebar
          "workbench.activityBar.orientation" = "vertical";

          # Extensions
          "redhat.telemetry.enabled" = false;
        };
      };
    };
  };
}

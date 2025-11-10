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
        ] ++ (with pkgs.vscode-marketplace; [
          redhat.java
          vscjava.vscode-java-debug
          vscjava.vscode-java-test
          vscjava.vscode-maven
          vscjava.vscode-gradle
          vscjava.vscode-java-dependency
          vscjava.vscode-java-pack # Apparently I need this so I don't get prompted. Was told it does nothing.
        ]);
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

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
    programs.java.enable = true;
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
          # Font
          "editor.fontFamily" = "Google Sans Code";

          # Sidebar
          "workbench.activityBar.orientation" = "vertical";

          # Extensions
          "redhat.telemetry.enabled" = false;

          # Setup nix language server
          "nix.serverPath" = "nixd";
          "nix.enableLanguageServer" = true;
          "nix.formatterPath" = "alejandra";
          "nix.serverSettings" = {
            "nixd" = {
              "formatting" = {
                "command" = ["alejandra"];
              };
            };
          };

          # Disable updates - updates are handled by NixOS
          "update.enableWindowsBackgroundUpdates" = false;
          "update.mode" = "none";

          # Java configuration
          "java.jdt.ls.java.home" = "${pkgs.jdk}/lib/openjdk";
          "java.configuration.runtimes" = [
            {
              "name" = "JavaSE-21";
              "path" = "${pkgs.jdk}/lib/openjdk";
              "default" = true;
            }
          ];
          "java.configuration.updateBuildConfiguration" = "automatic";
          "[java]"."editor.defaultFormatter" = "redhat.java";
          "java.debug.logLevel" = "trace";
        };
        keybindings = [
          {
            key = "ctrl+d";
            command = "editor.action.copyLinesDownAction";
            when = "editorTextFocus && !editorReadonly";
          }
          {
            key = "ctrl+shift+'";
            command = "editor.cpp.toggle";
          }
        ];
      };
    };
  };
}

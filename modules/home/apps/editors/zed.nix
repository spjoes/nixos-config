{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.editors.zed;
in {
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
        "nix"
      ];

      userKeymaps = [
        {
          context = "Editor";
          bindings = {
            "ctrl-d" = "editor::DuplicateLineDown";
            "ctrl-alt-'" = "editor::ToggleEditPrediction";
          };
        }
      ];

      userSettings = {
        restore_on_startup = "last_session";
        minimap.show = "always";
        agent_servers = {
          codex = {
            command = "${pkgs.codex-acp}/bin/codex-acp";
          };
        };
        features = {
          edit_prediction_provider = "copilot";
        };

        lsp = {
          nixd = {
            binary = {
              path = lib.getExe pkgs.nixd;
              path_lookup = true;
            };
          };
          gopls = {
            binary = {
              path = lib.getExe pkgs.gopls;
              path_lookup = true;
            };
          };
        };

        languages = {
          "Nix" = {
            tab_size = 2;
            language_servers = ["nixd"];
            format_on_save = "on";
            formatter = {
              external = {
                command = lib.getExe pkgs.alejandra;
              };
            };
          };
          "Go" = {
            tab_size = 4;
            language_servers = ["gopls"];
            formatter = "language_server";
          };
        };
      };
    };

    home.packages = [
      pkgs.codex-acp
      pkgs.codex
    ];
  };
}

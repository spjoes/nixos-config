{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.art.aseprite;
in {
  options.art.aseprite = {
    enable = lib.mkEnableOption "Enable Aseprite with Catppuccin Mocha theme";
  };

  config = lib.mkIf cfg.enable {
    # Install Aseprite package
    home.packages = [pkgs.aseprite];

    # Install Catppuccin Mocha theme extension
    home.activation.asepriteTheme = lib.hm.dag.entryAfter ["writeBoundary"] ''
      THEME_DIR="${config.home.homeDirectory}/.config/aseprite/extensions/catppuccin-theme-mocha"
      THEME_SRC="${pkgs.runCommand "aseprite-catppuccin-mocha" {} ''
        mkdir -p $out
        cp -r ${pkgs.fetchzip {
          url = "https://github.com/catppuccin/aseprite/releases/download/v1.2.1/catppuccin-theme-mocha.aseprite-extension";
          sha256 = "sha256-I3bjuO5eDrlvwSMpHrGBud0w4vqXYvJPV+OOOAqaptw=";
          extension = "zip";
        }}/* $out/
        echo '{"installedFiles": ["package.json", "sheet.aseprite-data", "sheet.png", "theme.xml"]}' > $out/__info.json
      ''}"

      if [ ! -d "$THEME_DIR" ] || [ -L "$THEME_DIR" ]; then
        $DRY_RUN_CMD rm -rf "$THEME_DIR"
        $DRY_RUN_CMD mkdir -p "$(dirname "$THEME_DIR")"
        $DRY_RUN_CMD cp -r "$THEME_SRC" "$THEME_DIR"
        $DRY_RUN_CMD chmod -R u+w "$THEME_DIR"
      fi
    '';

    # Set Aseprite theme preference
    home.activation.asepriteThemeConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      INI_FILE="${config.home.homeDirectory}/.config/aseprite/aseprite.ini"

      if [ -f "$INI_FILE" ]; then
        if grep -q "^\[theme\]" "$INI_FILE"; then
          $DRY_RUN_CMD ${pkgs.gnused}/bin/sed -i '/^\[theme\]/,/^\[/ s/^selected = .*/selected = Catppuccin Theme Mocha/' "$INI_FILE"
        else
          $DRY_RUN_CMD echo -e "\n[theme]\nselected = Catppuccin Theme Mocha" >> "$INI_FILE"
        fi
      fi
    '';
  };
}

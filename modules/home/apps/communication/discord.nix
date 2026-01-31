{ config, pkgs, lib, ... }:

let
  cfg = config.communication.discord;
in
{
  options.communication.discord = {
    enable = lib.mkEnableOption "Enable the Vesktop Discord client";
  };

  config = lib.mkIf cfg.enable {
    home.file.".config/vesktop/userAssets/splash".source = ./splash;

    programs.vesktop = {
      enable = true;

      settings = {
        appBadge = false;
        arRPC = true;
        enableSplashScreen = true;
        tray = true;
        hardwareAcceleration = true;
        hardwareVideoAcceleration = true;
        discordBranch = "stable";
      };
      vencord = {
        useSystem = true;
        settings = {
          autoUpdate = true;
          autoUpdateNotification = false;
          notifyAboutUpdates = false;
          winNativeTitleBar = false;

          plugins = {
            QuickMention.enabled = true;
            SpotifyControls.enabled = true;
            WebScreenShareFixes.enabled = true;
          };
        };
      };
    };

    catppuccin.vesktop = {
      enable = true;
      flavor = "mocha";
      accent = "blue";
    };
  };
}

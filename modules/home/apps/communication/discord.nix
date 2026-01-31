{ config, pkgs, lib, ... }:

let
  cfg = config.communication.discord;
in
{
  options.communication.discord = {
    enable = lib.mkEnableOption "Enable the Vesktop Discord client";
  };

  config = lib.mkIf cfg.enable {
    programs.vesktop = {
      enable = true;

      settings = {
        appBadge = false;
        arRPC = true;
        enableSplashScreen = false;
        tray = true;
        hardwareAcceleration = true;
        discordBranch = "stable";
      };
      vencord = {
        useSystem = true;
        settings = {
          autoUpdate = true;
          autoUpdateNotification = false;
          notifyAboutUpdates = false;
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

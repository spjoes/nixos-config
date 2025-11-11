{ config, pkgs, lib, ... }:

let
  cfg = config.media.spotify;
in
{
  options.media.spotify = {
    enable = lib.mkEnableOption "Enable Spotify + Spicetify for desktop";
  };

  config = lib.mkIf cfg.enable {
    programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        fullAlbumDate
        volumePercentage
        coverAmbience
        # quickaddtoplaylist
        # quickQueue
        # tracktags
        # playlistlabels
        # spicylyrics
        shuffle # shuffle+ (special characters are sanitized out of extension names)
      ];
      enabledSnippets = with spicePkgs.snippets; [
        hideNowPlayingViewButton
        modernScrollbar
        ''
        .main-actionBar-exploreButton { display: none !important; }
        ''
      ];
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
    };
  };
}

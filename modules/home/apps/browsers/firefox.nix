{ config, pkgs, lib, ... }:

let
  cfg = config.browsers.firefox;
in
{
  options.browsers.firefox = {
    enable = lib.mkEnableOption "Enable the Firefox browser";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;

      # Your existing profiles/settings moved here
      # If you only use one profile, name it "default"
      profiles.default = {
        id = 0;
        isDefault = true;

        search = {
          default = "google";
          force = true;
          engines = {
            ebay.metaData.hidden = true; # Hide ebay from search shortcuts
            amazondotcom-us.metaData.hidden = true; # Hide amazon from search shortcuts
            bing.metaData.hidden = true; # Hide bing from search shortcuts
            ddg.metaData.hidden = true; # Hide duckduckgo from search shortcuts
            perplexity.metaData.hidden = true; # Hide perplexity from search shortcuts
            wikipedia.metaData.hidden = true; # Hide wikipedia from search shortcuts
          };
        };

        settings = {
          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
          "sidebar.verticalTabs" = true;
          "sidebar.revamp" = true;
          "sidebar.visibility" = "always-show";
          "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;
          "sidebar.main.tools" = "history";
          "browser.uiCustomization.navBarWhenVerticalTabs" = builtins.toJSON [
            "sidebar-button"
            "back-button"
            "forward-button"
            "stop-reload-button"
            "home-button"
            "customizableui-special-spring1"
            "vertical-spacer"
            "urlbar-container"
            "customizableui-special-spring5"
            "downloads-button"
            "unified-extensions-button"
            "ublock0_raymondhill_net-browser-action"
          ];
          "browser.uiCustomization.state" = builtins.toJSON {
            placements = {
              nav-bar = [
                "sidebar-button" # Collapse sidebar button (TODO: Figure out why this appears after the home button for some reason)
                "back-button" # Back to previous website button
                "forward-button" # Forward website button
                "stop-reload-button" # Stop/Reload website button
                "home-button" # Home button
                "customizableui-special-spring1" # Spacer
                "vertical-spacer" # Spacer
                "urlbar-container" # URL bar
                "customizableui-special-spring5" # Spacer
                "downloads-button" # Downloads button (only shows when downloads are present)
                "unified-extensions-button" # Extensions button
                "ublock0_raymondhill_net-browser-action" # uBlock Origin
                "firefox_tampermonkey_net-browser-action" # Tampermonkey
                "_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action" # Stylus
              ];
            };
          };
          "browser.urlbar.scotchBonnet.enableOverride" = false;
          "browser.urlbar.suggest.quicksuggest.sponsored" = false;
          "browser.urlbar.suggest.engines" = false;
          "browser.urlbar.suggest.topsites" = false;
          "browser.urlbar.suggest.trending" = false;
          "browser.startup.homepage" = "chrome://browser/content/blanktab.html";
          "browser.startup.blankWindow" = true;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.showSponsoredCheckboxes" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.showWeather" = false;
          "browser.newtabpage.enabled" = false;
          "browser.download.useDownloadDir" = false;
          "privacy.globalprivacycontrol.enabled" = true;
          "media.eme.enabled" = true; # Allow playing DRM protected content
          "browser.dataFeatureRecommendations.enabled" = false;
          "layout.css.prefers-color-scheme.content-override" = 0; # Force dark mode (0 = dark, 1 = light, 2 = system)
        };

        extensions = with pkgs.nur.repos.rycee.firefox-addons; {
          force = true;
          packages = [
            firefox-color
            ublock-origin
            stylus
            tampermonkey
          ];
        };

          # Figure out how to declare the settings for uBlock Origin, Tampermonkey, and Stylus
          # Also figure out how to make these extensions auto-enable without having to manually enable them from Firefox.
      };
    };
  };
}

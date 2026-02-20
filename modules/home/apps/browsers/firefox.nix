{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.browsers.firefox;
in {
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
          "font.name.serif.x-western" = "Times New Roman";
          "font.name.sans-serif.x-western" = "Arial";
          "font.name.monospace.x-western" = "Google Sans Code";
          "font.size.monospace.x-western" = 13;
          "gfx.font_rendering.cleartype_params.rendering_mode" = 5;
          "gfx.font_rendering.cleartype_params.cleartype_level" = 100;
          "gfx.font_rendering.directwrite.use_gdi_table_loading" = false;
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
                "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action" # Bitwarden
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
          "browser.toolbars.bookmarks.visibility" = "always";
          "browser.tabs.groups.enabled" = false;
          "browser.tabs.groups.smart.enabled" = false;
          "privacy.globalprivacycontrol.enabled" = true;
          "media.eme.enabled" = true; # Allow playing DRM protected content
          "browser.dataFeatureRecommendations.enabled" = false;
          "layout.css.prefers-color-scheme.content-override" = 0; # Force dark mode (0 = dark, 1 = light, 2 = system)

          "signon.rememberSignons" = false; # Dont ask to remember passwords. This is handled by Bitwarden.
          "services.sync.prefs.sync.signon.rememberSignons" = true;
          "services.sync.prefs.sync-seen.signon.rememberSignons" = true;

          "signon.management.page.breach-alerts.enabled" = false; # Dont show breach alerts. This is handled by Bitwarden.
          "services.sync.prefs.sync.signon.management.page.breach-alerts.enabled" = true;
          "services.sync.prefs.sync-seen.signon.management.page.breach-alerts.enabled" = true;
        };

        extensions = with pkgs.nur.repos.rycee.firefox-addons; {
          force = true;
          packages = [
            firefox-color
            ublock-origin
            stylus
            tampermonkey
            bitwarden
          ];
        };
        # Figure out how to declare the settings for uBlock Origin, Tampermonkey, and Stylus
        # Also figure out how to make these extensions auto-enable without having to manually enable them from Firefox.

        bookmarks = {
          force = true;
          settings = [
            {
              name = "Bookmarks Bar";
              toolbar = true;
              bookmarks = [
                {
                  name = "Get unix";
                  url = "javascript:(function(){function parseIsoDatetime(dtstr) {     return new Date(dtstr); };  startElement = document.getElementById('availability-time'); endElement = document.getElementById('availability-time2');  start = parseIsoDatetime(startElement.getAttribute('datetime')); end = parseIsoDatetime(endElement.getAttribute('datetime'));  para = document.createElement('p'); para.innerText = Math.floor(start.getTime() / 1000) + '-' + Math.ceil(end.getTime() / 1000);  endElement.parentElement.appendChild(para);})();";
                }
                {
                  name = "03070";
                  url = "https://www.eneba.com/us/checkout/payment";
                }
                {
                  name = "ChatGPT";
                  url = "https://chatgpt.com/";
                }
                {
                  name = "Anna's Archive";
                  url = "https://annas-archive.org/";
                }
                {
                  name = "Canvas";
                  url = "https://sjsu.instructure.com/";
                }
                {
                  name = "Nixpkgs-tracker";
                  url = "https://nixpkgs-tracker.ocfox.me/";
                }
                {
                  name = "NixOS Search";
                  url = "https://search.nixos.org/packages?channel=unstable";
                }
                {
                  name = "ProtonDB";
                  url = "https://www.protondb.com/";
                }
              ];
            }
          ];
        };
      };
    };
  };
}

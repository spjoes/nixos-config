{ config, pkgs, ... }:

{

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "joey";
  home.homeDirectory = "/home/joey";

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Joey";
        email = "joeykerp@gmail.com";
      };
    };
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.
  
  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "blue";
  };

  programs.ghostty.enable = true;
  catppuccin.ghostty.enable = true;

  programs.obs-studio.enable = true;
  catppuccin.obs.enable = true;

  catppuccin.firefox.enable = true;
  programs.firefox = {
    enable = true;
    profiles.default = {
      id = 0;
      isDefault = true;
      search = {
        default = "google";
        force = true;
        engines = {
          ebay.metaData.hidden = true;
          amazondotcom-us.metaData.hidden = true;
          bing.metaData.hidden = true;
          ddg.metaData.hidden = true;
          perplexity.metaData.hidden = true;
          wikipedia.metaData.hidden = true;
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
          "newtaboverride_agenedia_com-browser-action"
        ];
        "browser.uiCustomization.state" = builtins.toJSON {
          placements = {
            nav-bar = [
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
              "firefox_tampermonkey_net-browser-action"
              "_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action"
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
        "media.eme.enabled" = true;
        "browser.dataFeatureRecommendations.enabled" = false;
        "layout.css.prefers-color-scheme.content-override" = 0; # Force dark mode
      };
      extensions = with pkgs.nur.repos.rycee.firefox-addons;{
        force = true;
        packages = [
          firefox-color
          ublock-origin
          stylus
          tampermonkey
        ];

       #  settings = {
         #  "${ublock-origin.addonId}" = {
           #  force = true;
           #  settings = {
             # userSettings = rec {
             #   advancedUserEnabled = true;
             #   uiAccentCustom = true;
             #   uiAccentCustom0 = "#FFFFFF";
             # };
           # };
         # };
        # };
      };
    };
  };

  programs.fastfetch.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    pkgs.prismlauncher

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/joey/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

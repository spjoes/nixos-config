{ config, pkgs, inputs, ... }:

{

  imports = [
    ../../modules/home/common.nix # Home Manager common modules

    # Application modules
    ../../modules/home/apps/browsers # Module to import browsers
    ../../modules/home/apps/editors # Module to import editors
    ../../modules/home/apps/media # Module to import media
  ];


  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "joey";
  home.homeDirectory = "/home/joey";

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
  programs.fastfetch.enable = true;
  # programs.rofi = {
  #   enable = true;
  #   plugins = [ pkgs.rofi-file-browser ];
  #   extraConfig = {
  #     modi = "combi";
  #     combi-modi = "drun,file-browser-extended,window";
  #     show-icons = true;
  #     display-combi = "Search";
  #     drun-display-format = "{name}";
  #   };
  # };

  programs.rofi = let
    rofiFiles = pkgs.writeShellScriptBin "rofi-files" ''
      #!/usr/bin/env bash
      set -euo pipefail
      case "${ROFI_RETV:-0}" in
        0)  printf '\0prompt\x1ffiles: type query, then Enter\n'; echo "Type a query and press Enter…" ;;
        2)  q="$1"; printf '\0prompt\x1ffiles: %s\n' "$q"
            if command -v plocate >/dev/null; then plocate -i --limit 200 -- "$q" | grep -v '^/nix/store/';
            else locate -i -l 200 -- "$q" | grep -v '^/nix/store/'; fi ;;
        1)  xdg-open "$1" >/dev/null 2>&1 & ;;
      esac
    '';
  in {
    enable = true;
    extraConfig = {
      modi = "combi,files:${rofiFiles}/bin/rofi-files"; # {name}:{executable}
      combi-modi = "drun,files,window";
      combi-display-format = "{text}";
      display-combi = "Search";
      drun-display-format = "{name}";
      show-icons = true;
    };
  };


  editors.cursor.enable = true; # cfg from editors module

  browsers.firefox.enable = true; # cfg from browsers module

  media.obs.enable = true; # cfg from media module

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

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # hello
    prismlauncher
    discord
    slack
    maestral-gui

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (writeShellScriptBin "my-hello" ''
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
}

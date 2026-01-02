{ config, pkgs, inputs, ... }:

let
  # We10XOS cursor theme from GitHub
  # Repository: https://github.com/yeyushengfan258/We10XOS-cursors
  # This is the cursor-only repository (not the full KDE theme suite)
  we10xos-cursors = pkgs.stdenv.mkDerivation rec {
    pname = "we10xos-cursors";
    version = "git-2024";
    src = pkgs.fetchFromGitHub {
      owner = "yeyushengfan258";
      repo = "We10XOS-cursors";
      rev = "b971891cc016ba780af791ac9872a15406695ad8";
      hash = "sha256-dy6gA2jZa0pxwXDnc3ckxWd01k2UG0EWG8hoeU5T28Y=";
    };
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/icons/We10XOS
      # The dist/ directory contains the theme files (index.theme and cursors/)
      # Copy the entire dist/ directory as the We10XOS theme directory
      cp -r $src/dist/* $out/share/icons/We10XOS/
    '';
  };
in
{

  imports = [
    ../../modules/home/common.nix # Home Manager common modules
    inputs.plasma-manager.homeModules.plasma-manager

    # Application modules
    ../../modules/home/apps/browsers # Module to import browsers
    ../../modules/home/apps/editors # Module to import editors
    ../../modules/home/apps/media # Module to import media
    ../../modules/home/apps/tools # Module to import tools
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

  programs.plasma = {
    enable = true;
    workspace = {
      colorScheme =  "Catppuccin Mocha Blue";
      splashScreen = {
        theme = "Catppuccin-Mocha-Blue";
      };
      iconTheme = "Breeze Dark";
      cursor.theme = "We10XOS";
      windowDecorations = {
        library = "org.kde.breeze";
        theme = "Breeze";
      };
    };
    # input.touchpads = [
    #   {
    #     naturalScroll = true;
    #     vendorId = " [IDK HOW TO GET THIS] ";
    #   }
    # ];
    kwin = {
      titlebarButtons = {
        left = ["application-menu" "keep-above-windows"];
        right = ["minimize" "maximize" "close"];
      };
    };
    hotkeys.commands = {
      toggle-vicinae = {
        name = "Toggle Vicinae";
        key = "Meta+Space";
        command = "vicinae toggle";
      };
      snipping-tool = {
        name = "Snipping Tool";
        key = "Meta+Shift+S";
        command = "sh -c \"spectacle -b -r -n -o /proc/self/fd/1 | wl-copy --type image/png\"";
      };
    };
  };

  programs.ghostty.enable = true;
  programs.fastfetch.enable = true;
  services.trayscale.enable = true;

  # services.linux-wallpaperengine = {
  #   enable = true;
  #   wallpapers = [
  #     {
  #       monitor = "eDP-1";
  #       wallpaperId = "2882606912"; # "Severance - Lumon - Macrodata Refinement"
  #     }
  #   ];
  # };

  # Configs from editors module
  editors.cursor.enable = true;

  # Configs from browsers module
  browsers.firefox.enable = true;

  # Configs from media module
  media.obs.enable = true;
  media.spotify.enable = true;

  # Configs from tools module
  # tools.rofi.enable = true;
  tools.vicinae.enable = true;

  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # hello
    we10xos-cursors
    prismlauncher
    discord
    slack
    maestral-gui
    vlc
    github-desktop
    # aseprite

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

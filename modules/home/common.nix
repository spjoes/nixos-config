{ config, pkgs, ... }:
{
  home.sessionVariables = { };
  
  programs.git = {
    enable = true;
    settings.user = { name = "Joey"; email = "joeykerp@gmail.com"; };
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  environment.shellAliases = {
    gst = "git status";
    ga = "git add *";
    gcm = "git commit -m";
    gp = "git push origin main";
  };

  programs.home-manager.enable = true;
}

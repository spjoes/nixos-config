{
  config,
  pkgs,
  ...
}: {
  home.sessionVariables = {};

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Joey";
        email = "joeykerp@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };

  programs.home-manager.enable = true;
}

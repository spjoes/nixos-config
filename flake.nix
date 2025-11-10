{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = { self, nixpkgs, nix-vscode-extensions, ... }@inputs: {
    # use "nixos", or your hostname as the name of the configuration
    # it's a better practice than "default" shown in the video
    overlays = [
      inputs.nix-vscode-extensions.overlays.default
    ];
    nixosConfigurations = {

      vm = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/vm/configuration.nix
          inputs.catppuccin.nixosModules.catppuccin
          inputs.spicetify-nix.nixosModules.default
          inputs.home-manager.nixosModules.default
        ];
      };

      alaska = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/alaska/configuration.nix
          inputs.catppuccin.nixosModules.catppuccin
          inputs.spicetify-nix.nixosModules.default
          inputs.home-manager.nixosModules.default
        ];
      };

      # TODO: Add desktop configuration

    };
  };
}

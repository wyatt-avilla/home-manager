{
  description = "My Home Manager configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = { self, nixpkgs, home-manager, hyprland, hyprland-plugins, split-monitor-workspaces, ... }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      homeConfigurations = {
        desktop = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
	  extraSpecialArgs = {
	    inherit hyprland hyprland-plugins split-monitor-workspaces;
	  };
          modules = [
	    ./hosts/desktop.nix
	  ];
        };
      };
    };
}

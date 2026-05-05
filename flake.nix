{
  # trigger build
  description = "My Home Manager configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:wyatt-avilla/nixvim/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    elephant.url = "github:abenz1267/elephant";

    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };

    nix-secrets = {
      url = "git+ssh://git@github.com/wyatt-avilla/nix-secrets";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-ci = {
      url = "git+ssh://git@github.com/wyatt-avilla/nix-ci";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      stylix,
      spicetify-nix,
      nix-secrets,
      nix-ci,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      ci = nix-ci.lib.mkProject {
        inherit pkgs;
        src = self;
      };
    in
    {
      homeConfigurations = {
        desktop = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./hosts/desktop/default.nix
            stylix.homeModules.stylix
            spicetify-nix.homeManagerModules.spicetify
            nix-secrets.homeManagerModules.desktop
          ];
        };

        laptop = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./hosts/laptop/default.nix
            stylix.homeModules.stylix
            spicetify-nix.homeManagerModules.spicetify
            nix-secrets.homeManagerModules.laptop
          ];
        };
      };

      formatter.${system} = ci.formatter;

      devShells.${system}.default = ci.devShell;

      checks.${system} = ci.checks;
    };
}

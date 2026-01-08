{
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

    hyprland.url = "github:hyprwm/Hyprland";

    stylix.url = "github:danth/stylix";

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-secrets = {
      url = "git+ssh://git@github.com/wyatt-avilla/nix-secrets";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-checks = {
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
      nix-checks,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
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

      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          pre-commit
          nixfmt-rfc-style
          statix
        ];
        shellHook = ''
          pre-commit install
        '';
      };

      checks.${system} = {
        formatting = nix-checks.lib.mkFormattingCheck {
          inherit pkgs;
          src = self;
        };

        linting = nix-checks.lib.mkLintingCheck {
          inherit pkgs;
          src = self;
        };

        dead-code = nix-checks.lib.mkDeadCodeCheck {
          inherit pkgs;
          src = self;
        };
      };
    };
}

{ lib, inputs, ... }:
{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./keyboard.nix
    ../../modules/common.nix
  ];

  config = {
    home.stateVersion = "25.05";

    sops.defaultSopsFile = "${inputs.nix-secrets}/secrets/laptop.yaml";

    variables.weztermConfig.font_size = 10;
  };

  options.variables = {
    laptop.monitors = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        mainMonitor = "LVDS-1";
      };
    };
  };
}

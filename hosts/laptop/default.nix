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

    programs.ghostty.settings.font-size = 11;
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

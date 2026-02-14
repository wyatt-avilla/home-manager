{
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./suspend.nix
    ../../modules/common.nix
  ];

  config = {
    home = {
      packages = with pkgs; [ nvtopPackages.amd ];

      stateVersion = "24.11";
    };

    sops.defaultSopsFile = "${inputs.nix-secrets}/secrets/desktop.yaml";
  };

  options.variables = {
    desktop.monitors = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        mainMonitor = "DP-1";
        verticalMonitor = "HDMI-A-1";
      };
    };
  };
}

{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:

{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./suspend.nix
    ../../modules/common.nix
  ];

  home = {
    username = "wyatt";
    homeDirectory = "/home/wyatt";

    packages = with pkgs; [ amdgpu_top ];

    stateVersion = "24.11";
  };

  sops.defaultSopsFile = "${inputs.nix-secrets}/secrets/desktop.yaml";
}

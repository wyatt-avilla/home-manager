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
    ../../modules/common.nix
  ];

  home = {
    username = "wyatt";
    homeDirectory = "/home/wyatt";

    packages = with pkgs; [ amdgpu_top ];

    stateVersion = "25.05";
  };

  sops.defaultSopsFile = "${inputs.nix-secrets}/secrets/laptop.yaml";
}

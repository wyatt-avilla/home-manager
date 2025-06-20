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
    ./keyboard.nix
    ../../modules/common.nix
  ];

  home = {
    username = "wyatt";
    homeDirectory = "/home/wyatt";

    packages = with pkgs; [ ];

    stateVersion = "25.05";
  };

  sops.defaultSopsFile = "${inputs.nix-secrets}/secrets/laptop.yaml";

  programs.ghostty.settings.font-size = 11;
}

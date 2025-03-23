{
  lib,
  pkgs,
  config,
  ...
}:

{
  imports = [
    ./hyprland.nix
    ../../modules/common.nix
  ];

  home = {
    username = "wyatt";
    homeDirectory = "/home/wyatt";

    stateVersion = "24.11";
  };
}

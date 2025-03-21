{ lib, pkgs, ... }:
{
  imports = [
    ../modules/common.nix
  ];

  home = {
    username = "wyatt";
    homeDirectory = "/home/wyatt";

    stateVersion = "24.11";
  };
}

{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      hello
    ];

    username = "wyatt";
    homeDirectory = "/home/wyatt";

    stateVersion = "24.11";
  };
}

{ lib, pkgs, ... }:

{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        anchor = "top";
        y-margin = 100;
      };
    };
  };
}

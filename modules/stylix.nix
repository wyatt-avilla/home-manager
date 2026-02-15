{
  lib,
  pkgs,
  config,
  ...
}:
let
  oneDarkWarmer = {
    # https://github.com/tinted-theming/base24/blob/main/styling.md#specific-colours-and-their-usages
    background = "#232326";
    black = "#2C2D31";
    bright_black = "#35363b";
    grey = "#5a5b5e";
    light_grey = "#818387";
    foreground = "#e2ecfb";
    white = "#fafafa";
    bright_white = "#ffffff";
    red = "#de5d68";
    orange = "#c49060";
    yellow = "#dbb671";
    green = "#8fb573";
    cyan = "#51a8b3";
    blue = "#57a5e5";
    purple = "#bb70d2";
    dark_red_or_brown = "#76502D";
    darker_black = "#101012";
    darkest_black = "#1b1c1e";
    bright_red = "#833b3b";
    bright_yellow = "#7c5c20";
    bright_green = "#4D6B38";
    bright_cyan = "#2b5d63";
    bright_blue = "#2c485f";
    bright_purple = "#79428a";
  };
in
{
  options.variables.colors = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    default = oneDarkWarmer;
    description = "Default color set";
  };

  config.stylix = {
    enable = true;
    polarity = "dark";

    base16Scheme = {
      base00 = config.variables.colors.background;
      base01 = config.variables.colors.black;
      base02 = config.variables.colors.bright_black;
      base03 = config.variables.colors.grey;
      base04 = config.variables.colors.light_grey;
      base05 = config.variables.colors.foreground;
      base06 = config.variables.colors.white;
      base07 = config.variables.colors.bright_white;
      base08 = config.variables.colors.red;
      base09 = config.variables.colors.orange;
      base0A = config.variables.colors.yellow;
      base0B = config.variables.colors.green;
      base0C = config.variables.colors.cyan;
      base0D = config.variables.colors.blue;
      base0E = config.variables.colors.purple;
      base0F = config.variables.colors.dark_red_or_brown;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "Fira Code";
      };
    };

    icons = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    targets.swaync.colors.override.withHashtag.base0D = config.variables.colors.white;
  };
}

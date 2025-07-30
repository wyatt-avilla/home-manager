{ lib, config, ... }:
{
  options.variables = {
    terminal = lib.mkOption {
      type = lib.types.str;
      default = "ghostty";
      description = "Default teriminal";
    };
  };

  config.programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      confirm-close-surface = false;
      window-decoration = false;
      theme = "nix-colors";
    };

    themes = {
      nix-colors = {
        inherit (config.variables.colors) background;
        inherit (config.variables.colors) foreground;
        cursor-color = config.variables.colors.bright_white;
        palette = [
          "0=${config.variables.colors.darkest_black}"
          "1=${config.variables.colors.red}"
          "2=${config.variables.colors.green}"
          "3=${config.variables.colors.yellow}"
          "4=${config.variables.colors.blue}"
          "5=${config.variables.colors.purple}"
          "6=${config.variables.colors.cyan}"
          "7=${config.variables.colors.light_grey}"
          "8=${config.variables.colors.grey}"
          "9=${config.variables.colors.bright_red}"
          "10=${config.variables.colors.bright_green}"
          "11=${config.variables.colors.bright_yellow}"
          "12=${config.variables.colors.bright_blue}"
          "13=${config.variables.colors.bright_purple}"
          "14=${config.variables.colors.white}"
        ];
        selection-background = config.variables.colors.bright_black;
        selection-foreground = config.variables.colors.white;
      };
    };
  };
}

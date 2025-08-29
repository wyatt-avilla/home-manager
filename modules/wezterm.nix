{ lib, config, ... }:
{
  options.variables = {
    terminal = lib.mkOption {
      type = lib.types.str;
      default = "wezterm";
      description = "Default teriminal";
    };
  };

  config.programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
      return {
        enable_tab_bar = false;

        font_rules = {
      	  {
      	    intensity = "Bold",
      	    italic = false,
      	    font = wezterm.font("${config.stylix.fonts.monospace.name}", { weight = "Bold", stretch = "Normal", style = "Normal" }),
      	  },
      	  {
      	    intensity = "Bold",
      	    italic = true,
      	    font = wezterm.font("${config.stylix.fonts.monospace.name}", { weight = "Bold", stretch = "Normal", style = "Italic" }),
      	  },
        }
      }
    '';
  };
}

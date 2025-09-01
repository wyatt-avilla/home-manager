{ lib, config, ... }:
{
  options.variables = {
    terminal = lib.mkOption {
      type = lib.types.str;
      default = "wezterm";
      description = "Default teriminal";
    };

    weztermConfig = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Wezterm configuration as attrset";
    };
  };

  config = {
    variables.weztermConfig = {
      enable_tab_bar = false;
      window_close_confirmation = "NeverPrompt";
    };

    programs.wezterm = {
      enable = true;
      enableZshIntegration = true;
      extraConfig = ''
        local config = ${lib.generators.toLua { } config.variables.weztermConfig}

        config.font_rules = {
          {
            intensity = "Bold",
            italic = false,
            font = wezterm.font("${config.stylix.fonts.monospace.name}", { weight = "Bold", stretch = "Normal", style = "Normal" }),
          },
          {
            intensity = "Bold",
            italic = false,
            font = wezterm.font("${config.stylix.fonts.monospace.name}", { weight = "Bold", stretch = "Normal", style = "Italic" }),
          },
        }

        return config
      '';
    };
  };
}

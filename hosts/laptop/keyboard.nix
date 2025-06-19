let
  xkbFileName = "colemak-dh-swaps";
  xkbFilePath = "xkb/symbols/us/${xkbFileName}";
in
{
  # relevant keyboard FRU: 45N2242 45N2102 45N2172

  xdg.configFile.xkbFilePath = {
    text = ''
      xkb_symbols "${xkbFileName}" {
        include "us(colemak_dh_ortho)"

        key <MUHE> { [ BackSpace, BackSpace ] };
        key <HENK> { [ space,     space ] };
      };
    '';
  };

  wayland.windowManager.hyprland.settings.input = {
    kb_file = ".config/${xkbFilePath}";
  };
}

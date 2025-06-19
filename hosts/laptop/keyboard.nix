let
  xkbVariantName = "colemak-dh-swaps";
in
{
  # relevant keyboard FRU: 45N2242 45N2102 45N2172

  xdg.configFile."xkb/symbols/us" = {
    text = ''
      xkb_symbols "${xkbVariantName}" {
        include "us(colemak_dh_ortho)"

        key <MUHE> { [ BackSpace, BackSpace ] };
        key <HENK> { [ space,     space ] };
      };
    '';
  };

  wayland.windowManager.hyprland.settings.input = {
    kb_layout = "us";
    kb_variant = xkbVariantName;
  };
}

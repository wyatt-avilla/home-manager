let
  xkbFileName = "colemak-dh-swaps";
in
{
  # relevant keyboard FRU: 45N2242 45N2102 45N2172

  xdg.configFile."xkb/symbols/us/${xkbFileName}" = {
    text = ''
      xkb_symbols "${xkbFileName}" {
        include "us(colemak_dh_ortho)"

        key <MUHE> { [ BackSpace, BackSpace ] };
        key <HENK> { [ space,     space ] };
      };
    '';
  };
}

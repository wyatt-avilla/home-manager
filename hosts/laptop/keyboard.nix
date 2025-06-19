{
  # relevant keyboard FRU: 45N2242 45N2102 45N2172

  services.xserver.xkb.extraLayouts.colemak-dh-swaps = {
    description = "Colemak-DH Utilizing Japanese Keys";
    languages = [ "eng" ];
    symbolsFile = builtins.writeFile {
      name = "colemak-dh-swaps";
      text = ''
        xkb_symbols "colemak-dh-swaps" {
            include "us(colemak_dh_ortho)"

            key <MUHE> { [ BackSpace, BackSpace ] };
            key <HENK> { [ space,     space ] };
        };
      '';
    };
  };
}

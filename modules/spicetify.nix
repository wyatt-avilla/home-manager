{ pkgs, spicetify-nix, ... }:
let
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.system};
in
{
  programs.spicetify = {
    enable = true;

    enabledExtensions = with spicePkgs.extensions; [
      keyboardShortcut
      shuffle
    ];
  };
}

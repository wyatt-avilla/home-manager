{ pkgs, inputs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  programs.spicetify = {
    enable = true;

    enabledExtensions = with spicePkgs.extensions; [
      keyboardShortcut
      shuffle
    ];
  };

  nixpkgs.overlays = [
    (final: prev: {
      spotify = prev.spotify.overrideAttrs (oldAttrs: {
        postInstall =
          (oldAttrs.postInstall or "")
          + ''
            substituteInPlace $out/share/applications/spotify.desktop \
              --replace "spotify %U" "spotify %U --enable-features=UseOzonePlatform --ozone-platform=wayland"
          '';
      });
    })
  ];
}

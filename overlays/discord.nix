self: super: {
  discord = self.runCommand "discord" { nativeBuildInputs = [ self.makeWrapper ]; } ''
    mkdir -p $out/bin $out/share/applications $out/share/pixmaps

    makeWrapper ${super.discord}/bin/discord $out/bin/discord \
      --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland"

    substitute ${super.discord}/share/applications/discord.desktop \
      $out/share/applications/discord.desktop \
      --replace "Exec=Discord" "Exec=$out/bin/discord" \
      --replace "Icon=discord" "Icon=discord"

    cp ${super.discord}/share/pixmaps/discord.png $out/share/pixmaps/discord.png
  '';
}

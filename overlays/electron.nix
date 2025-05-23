let
  hardwareAccelerationFlags =
    "--enable-features="
    + builtins.concatStringsSep "," [
      "VaapiVideoDecoder"
      "VaapiIgnoreDriverChecks"
      "Vulkan"
      "DefaultANGLEVulkan"
      "VulkanFromANGLE"
    ];

  waylandFlags = "--ozone-platform=wayland";

  extraFlags = builtins.concatStringsSep " " [
    hardwareAccelerationFlags
    waylandFlags
  ];
in
self: super: {
  discord = self.runCommand "discord" { nativeBuildInputs = [ self.makeWrapper ]; } ''
    mkdir -p $out/bin $out/share/applications $out/share/pixmaps

    makeWrapper ${super.discord}/bin/discord $out/bin/discord \
      --add-flags "${extraFlags}"

    substitute ${super.discord}/share/applications/discord.desktop \
      $out/share/applications/discord.desktop \
      --replace-fail "Exec=Discord" "Exec=$out/bin/discord" \
      --replace-warn "Icon=discord" "Icon=$out/share/pixmaps/discord.png"

    cp -r ${super.discord}/share/icons $out/share/icons
    cp ${super.discord}/share/pixmaps/discord.png $out/share/pixmaps/discord.png
  '';

  webcord = self.runCommand "webcord" { nativeBuildInputs = [ self.makeWrapper ]; } ''
    mkdir -p $out/bin $out/share/applications $out/share/pixmaps

    makeWrapper ${super.webcord}/bin/webcord $out/bin/webcord \
      --add-flags "${extraFlags}"

    substitute ${super.webcord}/share/applications/webcord.desktop \
      $out/share/applications/webcord.desktop \
      --replace-fail "Exec=webcord" "Exec=$out/bin/webcord" \

    cp -r ${super.webcord}/share/icons $out/share/icons
  '';

  google-chrome = self.runCommand "google-chrome" { nativeBuildInputs = [ self.makeWrapper ]; } ''
    mkdir -p $out/bin $out/share/applications

    makeWrapper ${super.google-chrome}/bin/google-chrome-stable $out/bin/google-chrome \
      --add-flags "${extraFlags}"

    substitute ${super.google-chrome}/share/applications/google-chrome.desktop \
      $out/share/applications/google-chrome.desktop \
      --replace-fail "Exec=${super.google-chrome}/bin/google-chrome-stable" "Exec=$out/bin/google-chrome"

    cp -r ${super.google-chrome}/share/icons $out/share/icons
  '';

}

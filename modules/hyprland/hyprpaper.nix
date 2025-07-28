{ lib, pkgs, ... }:
let
  wallpapers = [
    (pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/wiki/wyatt-avilla/home-manager/dark_monstera.png";
      sha256 = "sha256-qoxl1gaLyHQXdkcpuVOumsfGneCEZc45WHv2JGEgoBc=";
    })
    (pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/wiki/wyatt-avilla/home-manager/grainy_ferns.png";
      sha256 = "sha256-UEFiiEfOEcDfzZ2aK4n9zOfmjJpIwyVFcYNoWB2D4UQ=";
    })
    (pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/wiki/wyatt-avilla/home-manager/mononoke-mountains.png";
      sha256 = "sha256-CLv/2yxiEvb3/Edx7GJT59izs0/MaoWYF/PHXoqific=";
    })
    (pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/wiki/wyatt-avilla/home-manager/mononoke-rocks.png";
      sha256 = "sha256-c7OZi5XI6iQqOpdxqfkKlcGi+eIxtDrdSqel/fstwkY=";
    })
    (pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/wiki/wyatt-avilla/home-manager/small_purple_flower.png";
      sha256 = "sha256-ree5/DRZRB9ixiwPyZeebc544x8kXdh7qGMRLZI5oFA=";
    })
    (pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/wiki/wyatt-avilla/home-manager/variety_leaves.png";
      sha256 = "sha256-gNsEG4U0tO+OkKOy5n+qWZtmlzPRn6DUUsivDeMur1Q=";
    })
  ];

  randomWallpaperScript = pkgs.writeShellScriptBin "random-wallpaper" ''
    wallpapers=(
    ${lib.concatStringsSep "\n" (builtins.map (w: "\"${w}\"") wallpapers)}
    )

    random_wallpaper="''${wallpapers[$RANDOM % ''${#wallpapers[@]}]}"

    hyprctl ${lib.getExe pkgs.hyprpaper} reload , "$random_wallpaper"
  '';
in
{
  wayland.windowManager.hyprland.settings.exec = [ "${randomWallpaperScript}/bin/random-wallpaper" ];

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ ];
      wallpapers = [ ];
    };
  };
}

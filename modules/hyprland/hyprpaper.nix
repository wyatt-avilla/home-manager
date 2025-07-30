{
  lib,
  pkgs,
  config,
  ...
}:
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

  randomWallpaperScript = pkgs.writeShellScript "set-random-wallpaper" ''
    #!/usr/bin/env bash

    wallpapers=(${lib.concatStringsSep " " (map (w: "\"${w}\"") wallpapers)})

    random_wallpaper="''${wallpapers[$RANDOM % ''${#wallpapers[@]}]}"

    mkdir -p "${config.home.homeDirectory}/.config/hypr"

    cat > "${config.home.homeDirectory}/.config/hypr/hyprpaper.conf" << EOF
    # Available wallpapers:
    ${lib.concatStringsSep "\n" (builtins.map (p: "#${p}") wallpapers)}
    preload = $random_wallpaper
    wallpaper = , $random_wallpaper
    EOF
  '';
in
{
  services.hyprpaper = {
    enable = true;
  };

  systemd.user.services.random-wallpaper = {
    Unit = {
      Description = "Set random wallpaper for hyprpaper";
      Before = [ "graphical-session.target" ];
      Wants = [ "graphical-session-pre.target" ];
      After = [ "graphical-session-pre.target" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${randomWallpaperScript}";
      RemainAfterExit = true;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}

{
  lib,
  pkgs,
  config,
  ...
}:
let
  wallpapers = [
    (pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/wiki/wyatt-avilla/home-manager/wallpapers/dark_monstera.png";
      sha256 = "sha256-qoxl1gaLyHQXdkcpuVOumsfGneCEZc45WHv2JGEgoBc=";
    })
    (pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/wiki/wyatt-avilla/home-manager/wallpapers/grainy_ferns.png";
      sha256 = "sha256-UEFiiEfOEcDfzZ2aK4n9zOfmjJpIwyVFcYNoWB2D4UQ=";
    })
    (pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/wiki/wyatt-avilla/home-manager/wallpapers/mononoke_mountains.png";
      sha256 = "sha256-CLv/2yxiEvb3/Edx7GJT59izs0/MaoWYF/PHXoqific=";
    })
    (pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/wiki/wyatt-avilla/home-manager/wallpapers/mononoke_rocks.png";
      sha256 = "sha256-c7OZi5XI6iQqOpdxqfkKlcGi+eIxtDrdSqel/fstwkY=";
    })
    (pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/wiki/wyatt-avilla/home-manager/wallpapers/small_purple_flower.png";
      sha256 = "sha256-ree5/DRZRB9ixiwPyZeebc544x8kXdh7qGMRLZI5oFA=";
    })
    (pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/wiki/wyatt-avilla/home-manager/wallpapers/variety_leaves.png";
      sha256 = "sha256-gNsEG4U0tO+OkKOy5n+qWZtmlzPRn6DUUsivDeMur1Q=";
    })
    (pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/wiki/wyatt-avilla/home-manager/wallpapers/mononoke_cliff.png";
      sha256 = "sha256-evdyx6ks0qbiwH9o0uG7LYUlvwV3M+iVHEz2v+Ggao8=";
    })
    (pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/wiki/wyatt-avilla/home-manager/wallpapers/spirited_away_forest.png";
      sha256 = "sha256-Pxh6cwuGpgxLvy3ZBTl6gO694q7wcUCRXaMs4QOJyO8=";
    })
    (pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/wiki/wyatt-avilla/home-manager/wallpapers/spirited_away_tunnel.png";
      sha256 = "sha256-psbTKbpIzCvNmUAQMiJKuc4lYu+Ip1Ogyw8QpUUJ0Ts=";
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

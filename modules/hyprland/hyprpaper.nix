{
  lib,
  pkgs,
  config,
  ...
}:
let
  wallpapers = builtins.filter (path: pkgs.lib.filesystem.pathIsRegularFile path) (
    pkgs.lib.filesystem.listFilesRecursive ../../assets/wallpapers
  );

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

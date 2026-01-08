{
  lib,
  pkgs,
  config,
  ...
}:
let
  wallpapers = builtins.filter (p: pkgs.lib.filesystem.pathIsRegularFile p) (
    pkgs.lib.filesystem.listFilesRecursive ../../assets/wallpapers
  );

  randomWallpaperScript = pkgs.writeShellScript "set-random-wallpaper" ''
    #!/usr/bin/env bash

    wallpapers=(${lib.concatStringsSep " " (map (w: "\"${w}\"") wallpapers)})

    random_wallpaper="''${wallpapers[$RANDOM % ''${#wallpapers[@]}]}"

    mkdir -p "${config.home.homeDirectory}/.config/hypr"

    cat > "${config.home.homeDirectory}/.config/hypr/hyprpaper.conf" << EOF
    # Available wallpapers:
    ${lib.concatStringsSep "\n" (map (p: "# ${p}") wallpapers)}

    splash = false

    wallpaper {
        monitor =
        path = $random_wallpaper
    }
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

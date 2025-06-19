{
  lib,
  pkgs,
  config,
  ...
}:

let
  mainMonitor = "DP-1";
in
{
  imports = [ ../../modules/hyprland.nix ];

  wayland.windowManager.hyprland = {
    settings = {
      monitor = [ "${mainMonitor},2560x1440@165,0x0,1" ];

      bind = [
        "$mainmod, 1, workspace, 1"
        "$mainmod, 1, movetoworkspace, 1"
        "$mainmod, 2, workspace, 2"
        "$mainmod, 2, movetoworkspace, 2"
        "$mainmod, 3, workspace, 3"
        "$mainmod, 3, movetoworkspace, 3"
        "$mainmod, 4, workspace, 4"
        "$mainmod, 4, movetoworkspace, 4"
        "$mainmod, 5, workspace, 5"
        "$mainmod, 5, movetoworkspace, 5"
        "$mainmod, 6, workspace, 6"
        "$mainmod, 6, movetoworkspace, 6"
        "$mainmod, 7, workspace, 7"
        "$mainmod, 7, movetoworkspace, 7"
        "$mainmod, 8, workspace, 8"
        "$mainmod, 8, workspace, 8"
        "$mainmod, 9, movetoworkspace, 9"
        "$mainmod, 9, movetoworkspace, 9"
        "$mainmod, 0, movetoworkspace, 10"
        "$mainmod, 0, movetoworkspace, 10"
      ];
    };
  };
}

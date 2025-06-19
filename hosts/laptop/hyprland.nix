{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (config.variables) terminal;
in
{
  imports = [ ../../modules/hyprland.nix ];

  wayland.windowManager.hyprland = {
    settings = {
      general = {
        "$modifier" = "ALT";
      };

      monitor = [ ", preferred, auto, 1" ];

      bind = [
        "$modifier, Return, exec, ${terminal}"

        "$modifier, 1, workspace, 1"
        "$modifier, 1, movetoworkspace, 1"
        "$modifier, 2, workspace, 2"
        "$modifier, 2, movetoworkspace, 2"
        "$modifier, 3, workspace, 3"
        "$modifier, 3, movetoworkspace, 3"
        "$modifier, 4, workspace, 4"
        "$modifier, 4, movetoworkspace, 4"
        "$modifier, 5, workspace, 5"
        "$modifier, 5, movetoworkspace, 5"
        "$modifier, 6, workspace, 6"
        "$modifier, 6, movetoworkspace, 6"
        "$modifier, 7, workspace, 7"
        "$modifier, 7, movetoworkspace, 7"
        "$modifier, 8, workspace, 8"
        "$modifier, 8, workspace, 8"
        "$modifier, 9, movetoworkspace, 9"
        "$modifier, 9, movetoworkspace, 9"
        "$modifier, 0, movetoworkspace, 10"
        "$modifier, 0, movetoworkspace, 10"
      ];
    };
  };
}

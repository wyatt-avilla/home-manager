{ config, ... }:
let
  monitorName = "LVDS-1";
  moduleSpacing = 8;
in
{
  programs.waybar = {
    settings.${config.variables.waybarName} = {
      css-name = config.variables.waybarName;
      height = 17;
      spacing = moduleSpacing;
      output = monitorName;
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [
        "clock#date"
        "custom/center-icon"
        "clock#time"
      ];
      modules-right = [
        "tray"
        "systemd-failed-units"
        "backlight"
        "battery"
        "wireplumber"
        "network"
        "custom/notification"
      ];

      "tray" = {
        spacing = moduleSpacing / 3;
      };

      battery = {
        format = "{capacity}% {icon}";
        tooltip-format = "{time}";
        format-charging = "{capacity}% <span foreground='${config.variables.colors.green}'>󰂄</span>";
        states = {
          warning = 30;
          critical = 15;
        };
        format-icons = [
          "󰁺"
          "󰁻"
          "󰁼"
          "󰁽"
          "󰁾"
          "󰁿"
          "󰂁"
          "󰂂"
          "󰂀"
          "󰁹"
        ];
      };

      backlight = {
        format = "{percent}% {icon}";
        format-icons = [
          "󱩎"
          "󱩏"
          "󱩐"
          "󱩑"
          "󱩒"
          "󱩓"
          "󱩔"
          "󱩕"
          "󱩖"
          "󰛨"
        ];
      };

      "custom/center-icon" = {
        format = " 󰥔 ";
      };
    };

    style = ''
      * {
        font-size: 12px;
      }

      #workspaces button {
        min-height: 0px;
        padding: 0px;
        margin: 0px;
        border-radius: 0px;
      }

      #battery.critical:not(.charging) {
        background-color: ${config.variables.colors.red};
        color: ${config.variables.colors.white};
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }
    '';
  };
}

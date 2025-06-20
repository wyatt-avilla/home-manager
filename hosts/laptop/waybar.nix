{
  lib,
  pkgs,
  config,
  ...
}:

let
  barName = "mainMonitorBar";
  monitorName = "LVDS-1";
  swayncClient = lib.getExe' pkgs.swaynotificationcenter "swaync-client";
  moduleSpacing = 8;
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      "$barName" = {
        css-name = barName;
        layer = "top";
        position = "top";
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

        "clock#date" = {
          format = "{:%a %b %d}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
        };

        "clock#time" = {
          format = "{:%H:%M:%OS}";
          interval = 1;
        };

        wireplumber = {
          format = "{volume}% {icon}";
          format-muted = "<span foreground='${config.variables.colors.red}'></span>";
          format-icons = [
            ""
            ""
            ""
          ];
        };

        network = {
          format-ethernet = "󰱓";
          format-wifi = "{essid} {icon}";
          format-disconnected = "<span foreground='${config.variables.colors.red}'>󰅛</span>";
          tooltip-format-ethernet = "{ifname}";
          tooltip-format-wifi = "{frequency}GHz {signalStrength}%";
          format-icons = [
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
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

        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='${config.variables.colors.red}'><sup></sup></span>";
            none = "";
            dnd-notification = "󰂛<span foreground='${config.variables.colors.red}'><sup></sup></span>";
            dnd-none = "󰂛";
            inhibited-notification = "<span foreground='${config.variables.colors.red}'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "󰂛<span foreground='${config.variables.colors.red}'><sup></sup></span>";
            dnd-inhibited-none = "󰂛";
          };
          return-type = "json";
          exec = "${swayncClient} -swb";
          on-click = "${swayncClient} -t -sw";
          on-click-right = "${swayncClient} -d -sw";
          escape = true;
        };
      };
    };

    style = ''
      * {
        font-weight: 500;
        font-size: 12px;
      }

      window#waybar {
        border-bottom: 1px solid ${config.variables.colors.grey};
      }

      .modules-left, .modules-right {
        margin-right: 10px;
        margin-left: 10px;
      }

      #systemd-failed-units {
        color: ${config.variables.colors.red};
      }

      pipewire {
        padding-right: 0px;
        margin-right: 0px;
      }

      #custom-notification {
        padding-right: 2px;
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

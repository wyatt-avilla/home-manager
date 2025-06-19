{
  lib,
  pkgs,
  config,
  ...
}:

let
  barName = "mainMonitorBar";
  monitorName = "DP-1";
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
        height = 22;
        spacing = moduleSpacing;
        output = monitorName;
        modules-left = [ ];
        modules-center = [
          "clock#date"
          "clock#time"
        ];
        modules-right = [
          "tray"
          "systemd-failed-units"
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
          format-muted = "";
          format-icons = [
            ""
            ""
            ""
          ];
        };

        network = {
          format-ethernet = "󰱓";
          format-disconnected = "<span foreground='${config.variables.colors.red}'>󰅛</span>";
          tooltip-format-ethernet = "{ifname}";
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
    '';
  };
}

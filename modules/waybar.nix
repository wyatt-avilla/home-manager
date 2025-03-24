{
  lib,
  pkgs,
  config,
  ...
}:

let
  font = config.variables.fontFamily;
  barName = "mainMonitorBar";
  monitorName = "DP-1";

  barBackground = "rgba(43, 48, 59, 0.5)";
  barBorderColor = "solid rgba(100, 114, 125, 0.5)";

  borderWidth = "2";
  moduleBorderColor = "white";
  swayncClient = lib.getExe' pkgs.swaynotificationcenter "swaync-client";
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
        spacing = 12;
        output = monitorName;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "tray"
          "clock#date"
          "clock#time"
          "custom/notification"
        ];

        "clock#date" = {
          format = "{:%a %b %d}";
        };
        "clock#time" = {
          format = "{:%H:%M:%OS}";
          interval = 1;
        };

        "custom/notification" = {
          "tooltip" = false;
          "format" = "{icon}";
          "format-icons" = {
            "notification" = "<span foreground='red'><sup></sup></span>";
            "none" = "";
            "dnd-notification" = "󰂛<span foreground='red'><sup></sup></span>";
            "dnd-none" = "󰂛";
            "inhibited-notification" = "<span foreground='red'><sup></sup></span>";
            "inhibited-none" = "";
            "dnd-inhibited-notification" = "󰂛<span foreground='red'><sup></sup></span>";
            "dnd-inhibited-none" = "󰂛";
          };
          "return-type" = "json";
          "exec-if" = "which ${swayncClient}";
          "exec" = "${swayncClient} -swb";
          "on-click" = "${swayncClient} -t -sw";
          "on-click-right" = "${swayncClient} -d -sw";
          "escape" = true;
        };
      };
    };
    style = ''
      * {
          font-family: ${font};
          font-weight: 500;
          padding: 0px;
          margin: 0px;
          min-height: 0;
      }

      window#waybar {
      background: ${barBackground};
          border-bottom: ${borderWidth}px ${barBorderColor};
          color: white;
          font-size: 14px;
      }

      .${barName} {
          font-family: ${font};
      }

      #workspaces {
          padding-left: 15px;
      }

      #custom-notification {
          padding-right: 15px;
      }

      #workspaces button {
        color: #838384;
      }

      #workspaces button.active {
        color: ${moduleBorderColor};
      }
    '';
  };
}

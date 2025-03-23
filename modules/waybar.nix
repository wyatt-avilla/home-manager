{ lib, pkgs, ... }:

let
  barName = "mainMonitorBar";
  monitorName = "DP-1";

  barBackground = "rgba(43, 48, 59, 0.5)";
  barBorderColor = "solid rgba(100, 114, 125, 0.5)";

  borderWidth = "2";
  moduleBorderColor = "white";
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
          "clock#date"
          "clock#time"
        ];

        "clock#date" = {
          format = "{:%a %b %d}";
        };
        "clock#time" = {
          format = "{:%H:%M:%OS}";
          interval = 1;
        };
      };
    };
    style = ''
      * {
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
          font-family: Fira Code;
      }

      #workspaces {
          padding-left: 15px;
      }

      #clock.time {
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

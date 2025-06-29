{
  lib,
  config,
  pkgs,
  ...
}:
let
  swayncClient = lib.getExe' pkgs.swaynotificationcenter "swaync-client";
in
{
  options.variables = {
    enable = true;
    systemd.enable = true;
    waybarName = lib.mkOption {
      type = lib.types.str;
      default = "mainMonitorBar";
      description = "Main waybar name";
    };
  };

  config.programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings."${config.variables.waybarName}" = {
      css-name = config.variables.waybarName;
      layer = "top";
      position = "top";

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
        format-wifi = "{essid} {icon}";
        format-disconnected = "<span foreground='${config.variables.colors.red}'>󰅛</span>";
        tooltip-format-ethernet = "{ipaddr}";
        tooltip-format-wifi = "{frequency}GHz {signalStrength}%";
        format-icons = [
          "󰤟"
          "󰤢"
          "󰤥"
          "󰤨"
        ];
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

      pipewire {
        padding-right: 0px;
        margin-right: 0px;
      }

      #custom-notification {
        padding-right: 2px;
      }

      #systemd-failed-units {
        color: ${config.variables.colors.red};
      }
    '';
  };
}

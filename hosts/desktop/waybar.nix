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
  playerctl = lib.getExe pkgs.playerctl;
  socat = lib.getExe pkgs.socat;
  jq = lib.getExe pkgs.jq;
  cpuThreads = 32;
  moduleSpacing = 8;

  cpuTempFile = "/tmp/cpu_temp";

  workspaceColumns = 4;
  workspaceRows = 2;

  workspaceQuery = pkgs.writeShellScript "workspaceQuery" ''
    #!/bin/sh

    QUERY_ID=$1

    determine_occupancy() {
    	is_active=$(hyprctl workspaces -j | ${jq} '.[] | select(.id == '"$QUERY_ID"')')
    	focused_id=$(hyprctl activeworkspace -j | ${jq} '.id')

    	if [ -z "$is_active" ] || [ "$is_active" = "null" ]; then
    		echo " "
    	elif [ "$QUERY_ID" = "$focused_id" ]; then
    		echo ""
    	else
    		echo ""
    	fi
    }

    handle() {
    	case $1 in
    	workspacev2*) determine_occupancy ;;
    	focusedmonv2*) determine_occupancy ;;
    	esac
    }

    determine_occupancy
    ${socat} -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
  '';
in
{
  systemd.user.services.cpu-temp-link = {
    Unit = {
      Description = "Generates a persistent temperature file for the CPU";
    };

    Service = {
      ExecStart = "${pkgs.writeShellScript "cpu-temp-link" ''
        dir="$(${pkgs.coreutils}/bin/dirname $(${pkgs.gnugrep}/bin/grep -l k10temp /sys/class/hwmon/hwmon*/name))"
        if [ -z "$dir" ]; then
          echo "Error: CPU temperature directory not found." >&2
          exit 1
        fi
        ${pkgs.coreutils}/bin/ln -sf "$dir/temp1_input" ${cpuTempFile}
      ''}";
      Type = "oneshot";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      "$barName" =
        {
          css-name = barName;
          layer = "top";
          position = "top";
          height = 22;
          spacing = moduleSpacing;
          output = monitorName;
          modules-left = [
            "memory"
            "temperature"
            "cpu"
            "custom/media-playing"
          ];
          modules-center = [
            "clock#date"
            "group/workspace-dots"
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

          temperature = {
            hwmon-path = cpuTempFile;
            format = "";
            critical-threshold = 75;
            format-critical = "<span foreground='${config.variables.colors.orange}'>{temperatureC}°C </span>";
            interval = 10;
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

          memory = {
            format = "";
            interval = 10;
            states = {
              low = 0;
              medium = 50;
              high = 75;
            };
          };

          cpu = {
            format = builtins.concatStringsSep "" (
              map (icon: "{${icon}}") (builtins.genList (i: "icon${toString i}") cpuThreads)
            );
            interval = 1;
            format-icons = [
              "<span color='${config.variables.colors.green}'>▁</span>"
              "<span color='${config.variables.colors.blue}'>▂</span>"
              "<span color='${config.variables.colors.white}'>▃</span>"
              "<span color='${config.variables.colors.white}'>▄</span>"
              "<span color='${config.variables.colors.yellow}'>▅</span>"
              "<span color='${config.variables.colors.yellow}'>▆</span>"
              "<span color='${config.variables.colors.orange}'>▇</span>"
              "<span color='${config.variables.colors.red}'>█</span>"
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

          "custom/media-playing" = {
            tooltip = false;
            format = "{icon} {}";
            max-length = 120;
            format-icons = {
              spotify = "";
              chromium = "";
            };
            return-type = "json";
            exec-if = "which ${playerctl}";
            exec = pkgs.writeShellScript "queryMedia" ''
              #!/bin/sh
              metadata_format="{\"playerName\": \"{{ playerName }}\", \"status\": \"{{ status }}\", \"title\": \"{{ title }}\", \"artist\": \"{{ artist }}\"}"
              player_priority="spotify,chromium"

              ${playerctl} --follow -a --player "$player_priority" metadata --format "$metadata_format" |
                while read -r _; do
              	active_stream=$(${playerctl} -a --player "$player_priority" metadata --format "$metadata_format" | ${jq} -s 'first([.[] | select(.status == "Playing")][] // empty)')
              	echo ""
              	echo "$active_stream" | ${jq} --unbuffered --compact-output \
              	  '.class = .playerName | .alt = .playerName | .text = "\(.title) - \(.artist)"'
                done
            '';
          };
        }
        // builtins.listToAttrs (
          builtins.genList (i: {
            name = "custom/workspace-dot#${toString (i + 1)}";
            value.exec = "${workspaceQuery} ${toString (i + 1)}";
          }) (workspaceRows * workspaceColumns)
        )
        // builtins.listToAttrs (
          builtins.genList (i: {
            name = "group/workspace-dot-vertical-group-of${toString workspaceRows}#${toString (i + 1)}";
            value.orientation = "orthogonal";
            value.modules = builtins.genList (
              j: "custom/workspace-dot#${toString (i + 1 + (j * workspaceColumns))}"
            ) workspaceRows;
          }) workspaceColumns
        )
        // {
          "group/workspace-dots" = {
            orientation = "inherit";
            modules = builtins.genList (
              i: "group/workspace-dot-vertical-group-of${toString workspaceRows}#${toString (i + 1)}"
            ) workspaceColumns;
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

      #memory {
        padding-left: 0px;
        padding-right: 8px;
      }

      #memory.medium {
        color: ${config.variables.colors.orange};
      }

      #memory.high {
        color: ${config.variables.colors.red};
      }

      #temperature {
        padding-left: 0px;
        padding-right: 0px;
      }

      #systemd-failed-units {
        color: ${config.variables.colors.red};
      }

      #cpu {
        padding-left: 0px;
        padding-right: 0px;
      }

      #workspace-dots {
        padding-top: 2px;
        border: 1px solid ${config.variables.colors.grey};
        border-radius: 6px;
      }

      #custom-workspace-dot {
        font-size: 6px;
        padding-left: 5px;
        padding-right: 5px;
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

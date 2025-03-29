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
  playerctl = lib.getExe pkgs.playerctl;
  socat = lib.getExe pkgs.socat;
  jq = lib.getExe pkgs.jq;

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
        modules-left = [
          "group/workspace-dots"
          "custom/media-playing"
        ];
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
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "󰂛<span foreground='red'><sup></sup></span>";
            dnd-none = "󰂛";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "󰂛<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "󰂛";
          };
          return-type = "json";
          exec-if = "which ${swayncClient}";
          exec = "${swayncClient} -swb";
          on-click = "${swayncClient} -t -sw";
          on-click-right = "${swayncClient} -d -sw";
          escape = true;
        };

        "group/workspace-dots" = {
          orientation = "inherit";
          modules = [
            "group/workspace-dot-vertical-pair#1"
            "group/workspace-dot-vertical-pair#2"
            "group/workspace-dot-vertical-pair#3"
            "group/workspace-dot-vertical-pair#4"
          ];
        };

        "group/workspace-dot-vertical-pair#1" = {
          orientation = "orthogonal";
          modules = [
            "custom/workspace-dot#1"
            "custom/workspace-dot#5"
          ];
        };

        "group/workspace-dot-vertical-pair#2" = {
          orientation = "orthogonal";
          modules = [
            "custom/workspace-dot#2"
            "custom/workspace-dot#6"
          ];
        };

        "group/workspace-dot-vertical-pair#3" = {
          orientation = "orthogonal";
          modules = [
            "custom/workspace-dot#3"
            "custom/workspace-dot#7"
          ];
        };

        "group/workspace-dot-vertical-pair#4" = {
          orientation = "orthogonal";
          modules = [
            "custom/workspace-dot#4"
            "custom/workspace-dot#8"
          ];
        };

        "custom/workspace-dot#1" = {
          exec = "${workspaceQuery} 1";
        };

        "custom/workspace-dot#2" = {
          exec = "${workspaceQuery} 2";
        };

        "custom/workspace-dot#3" = {
          exec = "${workspaceQuery} 3";
        };

        "custom/workspace-dot#4" = {
          exec = "${workspaceQuery} 4";
        };

        "custom/workspace-dot#5" = {
          exec = "${workspaceQuery} 5";
        };

        "custom/workspace-dot#6" = {
          exec = "${workspaceQuery} 6";
        };

        "custom/workspace-dot#7" = {
          exec = "${workspaceQuery} 7";
        };

        "custom/workspace-dot#8" = {
          exec = "${workspaceQuery} 8";
        };

        "custom/media-playing" = {
          tooltip = false;
          format = "{icon} {}";
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
      };
    };

    style = ''
      * {
        font-weight: 500;
      }

      window#waybar {
        border-bottom: 1px solid ${config.variables.colors.grey};
      }

      #custom-notification {
        padding-right: 15px;
      }

      #workspace-dots {
        padding-left: 15px;
        padding-top: 2px;
      }

      #custom-workspace-dot {
        font-size: 6px;
        padding-left: 5px;
        padding-right: 5px;
      }
    '';
  };
}

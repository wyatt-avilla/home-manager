{
  lib,
  pkgs,
  config,
  hyprland,
  ...
}:

let
  mainMonitor = "DP-1";
  verticalMonitor = "HDMI-A-1";
  workspaceLogicScriptName = "workspaceLogic.sh";
  absoluteWorkspaceLogicScriptPath = "${config.home.homeDirectory}/.config/hypr/${workspaceLogicScriptName}";
  workspaceKeys = [
    "a"
    "r"
    "s"
    "t"
    "g"
    "z"
    "x"
    "c"
    "d"
  ];

  mkWorkspaceBind =
    key:
    {
      shouldShift ? false,
    }:
    "$modifier ${
      if shouldShift then "SHIFT" else ""
    }, ${key}, exec, ${absoluteWorkspaceLogicScriptPath} ${key} ${if shouldShift then "move" else ""}";

  mkMonitorAssociations =
    { workspacesPer, monitors }:
    builtins.concatLists (
      builtins.genList (
        monitorIndex:
        builtins.genList (
          wsIndex:
          let
            workspaceNum = (monitorIndex * workspacesPer) + wsIndex + 1;
            monitorName = builtins.elemAt monitors monitorIndex;
          in
          "${toString workspaceNum},monitor:${monitorName}"
        ) workspacesPer
      ) (builtins.length monitors)
    );

  jq = lib.getExe pkgs.jq;
in
{
  imports = [
    ../../modules/hyprland.nix
  ];

  wayland.windowManager.hyprland = {
    settings = {
      monitor = [
        "${mainMonitor},2560x1440@165,0x0,1"
        "${verticalMonitor},1920x1080,2560x-200,1,transform,1"
      ];

      bind =
        builtins.map (key: mkWorkspaceBind key { }) workspaceKeys
        ++ builtins.map (key: mkWorkspaceBind key { shouldShift = true; }) workspaceKeys;

      workspace =
        mkMonitorAssociations {
          workspacesPer = builtins.length workspaceKeys;
          monitors = [
            mainMonitor
            verticalMonitor
          ];
        }
        ++ [ "m[${verticalMonitor}], layoutopt:orientation:top, mfact:0.5" ];
    };
  };

  xdg.configFile."hypr/${workspaceLogicScriptName}" = {
    text = ''
          #!/bin/sh
          send_hyprland_notification() {
            hyprctl notify -1 10000 "rgb(CC5500)" $1
          }

          handle_monitor_toggle() {
      	  if [ "$2" = "move" ]; then
              alt_monitor=""
              if [ "$focused_monitor" = "$main_monitor" ]; then
      		  alt_monitor=$vertical_monitor
      		elif [ "$focused_monitor" = "$vertical_monitor" ]; then
      		  alt_monitor=$main_monitor
      		else
      		  send_hyprland_notification "unable to toggle from unknown monitor"
              fi

      	    altMonitorWorkspaceId=$(hyprctl monitors -j | ${jq} -r ".[] | select (.name == \"$alt_monitor\") | .activeWorkspace.id")
      		hyprctl dispatch movetoworkspace $altMonitorWorkspaceId
      	  else
              if [ "$focused_monitor" = "$main_monitor" ]; then
                hyprctl dispatch focusmonitor "$vertical_monitor"
              elif [ "$focused_monitor" = "$vertical_monitor" ]; then
                hyprctl dispatch focusmonitor "$main_monitor"
              else
                send_hyprland_notification "unable to toggle from unknown monitor"
              fi
      	  fi
          }

          handle_workspace_switching() {
            workspacesPerMonitor=8
            workspaceShift=0
            if [ "$focused_monitor" = "$vertical_monitor" ]; then
              workspaceShift=${toString (builtins.length workspaceKeys)}
            fi

            subCommand="workspace"
            if [ "$2" = "move" ];then
              subCommand="movetoworkspace"
            fi

            if [ "$1" = "a" ]; then
              hyprctl dispatch "$subCommand" $((1 + workspaceShift))
            elif [ "$1" = "r" ]; then
              hyprctl dispatch "$subCommand" $((2 + workspaceShift))
            elif [ "$1" = "s" ]; then
              hyprctl dispatch "$subCommand" $((3 + workspaceShift))
            elif [ "$1" = "t" ]; then
              hyprctl dispatch "$subCommand" $((4 + workspaceShift))
            elif [ "$1" = "z" ]; then
              hyprctl dispatch "$subCommand" $((5 + workspaceShift))
            elif [ "$1" = "x" ]; then
              hyprctl dispatch "$subCommand" $((6 + workspaceShift))
            elif [ "$1" = "c" ]; then
              hyprctl dispatch "$subCommand" $((7 + workspaceShift))
            elif [ "$1" = "d" ]; then
              hyprctl dispatch "$subCommand" $((8 + workspaceShift))
            else
              send_hyprland_notification "unknown bind encountered while trying to switch workspace ($1)"
            fi
          }

          main_monitor="${mainMonitor}"
          vertical_monitor="${verticalMonitor}"

          focused_monitor=$(hyprctl monitors -j | ${jq} -r ".[] | select (.focused == true) | .name")

          toggle_monitor_key="g"

          if [ "$1" = "$toggle_monitor_key" ]; then
            handle_monitor_toggle $1 $2
          else
            handle_workspace_switching $1 $2
          fi
    '';
    executable = true;
  };
}

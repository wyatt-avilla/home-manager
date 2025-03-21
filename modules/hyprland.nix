{ lib, pkgs, hyprland, hyprland-plugins, ... }:

let
  mainMonitor = "DP-1";
  verticalMonitor = "HDMI-A-1";
  workspaceLogicScriptName = "workspaceLogic.sh";
  absoluteWorkspaceLogicScriptPath = "/home/wyatt/.config/hypr/${workspaceLogicScriptName}";
in
{ 
  home.packages = with pkgs; [
    jq
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    settings = {
      animations.enabled = false;
      general = {
        "$modifier" = "SUPER";
        layout = "master";
      };
      monitor = [
        "${mainMonitor},2560x1440@165,0x0,1"
        "${verticalMonitor},1920x1080,2560x-200,1,transform,1"
      ];
      master = {
        new_on_top = true;
      };
      input = {
        repeat_rate = 60;
        repeat_delay = 400;
      };
      bind = [
        "$modifier,code:47,exec,ghostty"
        "$modifier,w,exec,google-chrome-stable"
        "$modifier,q,killactive"

        "$modifier,e,layoutmsg,cyclenext"
        "$modifier,i,layoutmsg,cycleprev"
        "$modifier,SPACE,layoutmsg,swapwithmaster"

        "$modifier,g,exec,${absoluteWorkspaceLogicScriptPath} 'g'"

        "$modifier,a,exec,${absoluteWorkspaceLogicScriptPath} 'a'"
        "$modifier,r,exec,${absoluteWorkspaceLogicScriptPath} 'r'"
        "$modifier,s,exec,${absoluteWorkspaceLogicScriptPath} 's'"
        "$modifier,t,exec,${absoluteWorkspaceLogicScriptPath} 't'"
        "$modifier,z,exec,${absoluteWorkspaceLogicScriptPath} 'z'"
        "$modifier,x,exec,${absoluteWorkspaceLogicScriptPath} 'x'"
        "$modifier,c,exec,${absoluteWorkspaceLogicScriptPath} 'c'"
        "$modifier,d,exec,${absoluteWorkspaceLogicScriptPath} 'd'"


        "$modifier SHIFT,a,exec,${absoluteWorkspaceLogicScriptPath} 'a move'"
        "$modifier SHIFT,r,exec,${absoluteWorkspaceLogicScriptPath} 'r move'"
        "$modifier SHIFT,s,exec,${absoluteWorkspaceLogicScriptPath} 's move'"
        "$modifier SHIFT,t,exec,${absoluteWorkspaceLogicScriptPath} 't move'"
        "$modifier SHIFT,z,exec,${absoluteWorkspaceLogicScriptPath} 'z move'"
        "$modifier SHIFT,x,exec,${absoluteWorkspaceLogicScriptPath} 'x move'"
        "$modifier SHIFT,c,exec,${absoluteWorkspaceLogicScriptPath} 'c move'"
        "$modifier SHIFT,d,exec,${absoluteWorkspaceLogicScriptPath} 'd move'"
      ];
      binde = [
        "$modifier,o,resizeactive,10 0"
        "$modifier,n,resizeactive,-10 0"
      ];
      bindm = [
        "$modifier,mouse:272,movewindow"
        "$modifier,mouse:273,resizewindow"
      ];
      workspace = [
        "1,monitor:${mainMonitor}"
        "2,monitor:${mainMonitor}"
        "3,monitor:${mainMonitor}"
        "4,monitor:${mainMonitor}"
        "5,monitor:${mainMonitor}"
        "6,monitor:${mainMonitor}"
        "7,monitor:${mainMonitor}"
        "8,monitor:${mainMonitor}"
        "9,monitor:${verticalMonitor}"
        "10,monitor:${verticalMonitor}"
        "11,monitor:${verticalMonitor}"
        "12,monitor:${verticalMonitor}"
        "13,monitor:${verticalMonitor}"
        "14,monitor:${verticalMonitor}"
        "15,monitor:${verticalMonitor}"
        "16,monitor:${verticalMonitor}"
      ];
      plugins = [
        #split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
      ];
    };
  };
  xdg.configFile."hypr/${workspaceLogicScriptName}" = {
    text = ''
    #!/bin/sh
    send_hyprland_notification() {
      hyprctl notify -1 10000 "rgb(CC5500)" $1
    }

    handle_monitor_toggle() {
      if [ "$focused_monitor" = "$main_monitor" ]; then
        hyprctl dispatch focusmonitor "$vertical_monitor"
      elif [ "$focused_monitor" = "$vertical_monitor" ]; then
        hyprctl dispatch focusmonitor "$main_monitor"
      else
        send_hyprland_notification "unable to toggle from unknown monitor"
      fi
    }

    handle_workspace_switching() {
      workspacesPerMonitor=8
      workspaceShift=0
      if [ "$focused_monitor" = "$vertical_monitor" ]; then
        workspaceShift=workspacesPerMonitor
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
        send_hyprland_notification "unknown bind encountered while trying to switch workspace"
      fi
    }

    main_monitor="${mainMonitor}"
    vertical_monitor="${verticalMonitor}"

    focused_monitor=$(hyprctl monitors -j | jq -r ".[] | select (.focused == true) | .name")

    toggle_monitor_key="g"

    if [ "$1" = "$toggle_monitor_key" ]; then
      handle_monitor_toggle
    else
      handle_workspace_switching $1 $2
    fi
    '';
    executable = true;
  };
}


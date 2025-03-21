{ lib, pkgs, hyprland, hyprland-plugins, ... }:

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
        "DP-1,2560x1440@165,0x0,1"
        "HDMI-A-1,1920x1080,2560x-200,1,transform,1"
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

        "$modifier,a,workspace,1"
        "$modifier,r,workspace,2"
        "$modifier,s,workspace,3"
        "$modifier,t,workspace,4"

        "$modifier SHIFT,a,movetoworkspace,1"
        "$modifier SHIFT,r,movetoworkspace,2"
        "$modifier SHIFT,s,movetoworkspace,3"
        "$modifier SHIFT,t,movetoworkspace,4"
      ];
      binde = [
        "$modifier,o,resizeactive,10 0"
        "$modifier,n,resizeactive,-10 0"
      ];
      bindm = [
        "$modifier,mouse:272,movewindow"
        "$modifier,mouse:273,resizewindow"
      ];
      plugins = [
        #split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
      ];
    };
  };
}


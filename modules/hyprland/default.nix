{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  inherit (config.variables) terminal;
in
{
  imports = [
    ./hyprpaper.nix
    ./screenshot.nix
    ./move-all-windows.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    settings = {
      animations.enabled = false;

      general = {
        layout = "master";
        "col.active_border" = lib.mkForce "rgb(${lib.removePrefix "#" config.variables.colors.white})";
      };

      misc = {
        disable_hyprland_logo = true;
        enable_swallow = true;
        swallow_regex = ".*(${terminal}).*";
      };

      master = {
        new_on_top = true;
        special_scale_factor = ".75";
      };

      input = {
        repeat_rate = 60;
        repeat_delay = 400;
      };

      cursor = {
        inactive_timeout = 5;
      };

      ecosystem = {
        no_update_news = true;
        no_donation_nag = true;
      };

      bind = [
        "$modifier,w,exec,${lib.getExe' pkgs.google-chrome "google-chrome"}"
        "$modifier,q,killactive"

        "$modifier,e,layoutmsg,cyclenext"
        "$modifier,i,layoutmsg,cycleprev"
        "$modifier SHIFT,e,layoutmsg,swapnext"
        "$modifier SHIFT,i,layoutmsg,swapprev"

        "$modifier,f,exec,${lib.getExe config.programs.walker.package}"
        "$modifier,p,togglespecialworkspace,popupterm"
        "$modifier,b,fullscreen,1"
        "$modifier SHIFT,b,fullscreen,2"
        "$modifier,u,exec,${lib.getExe config.programs.walker.package} --provider clipboard"

        "$modifier SHIFT,V,togglefloating"
        "$modifier,m,layoutmsg,swapwithmaster"
      ];

      binde = [
        "$modifier,o,resizeactive,10 0"
        "$modifier,n,resizeactive,-10 0"
        ",XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ];

      bindm = [
        "$modifier,mouse:272,movewindow"
        "$modifier,mouse:273,resizewindow"
      ];

      workspace = [ "special:popupterm,on-created-empty:${terminal}" ];

      windowrule = [
        "match:class [Oo]bsidian, opacity 0.8 0.7"
        "match:class [Ss]potify, opacity 0.8 0.65"
        "match:fullscreen_state_client 1, border_color rgb(${lib.removePrefix "#" config.variables.colors.red})"
      ];
    };
  };
}

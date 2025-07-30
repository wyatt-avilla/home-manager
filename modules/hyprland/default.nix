{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  inherit (config.variables) terminal;

  clipHist = lib.getExe pkgs.cliphist;
in
{
  imports = [
    ./hyprpaper.nix
    ./screenshot.nix
    ./move_all_windows.nix
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

        "$modifier,f,exec,${lib.getExe pkgs.fuzzel}"
        "$modifier,p,togglespecialworkspace,popupterm"
        "$modifier,b,fullscreen,1"
        "$modifier,u,exec, ${clipHist} list | ${lib.getExe pkgs.fuzzel} --dmenu | ${clipHist} decode | ${pkgs.wl-clipboard}/bin/wl-copy"

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
        "opacity 0.9 override 0.75 override, class:.*(${terminal}).*"
        "opacity 0.8 override 0.65 override, class:[Ss]potify"
        "opacity 0.8 override 0.65 override, class:[Ww]eb[Cc]ord"
        "bordercolor rgb(${lib.removePrefix "#" config.variables.colors.red}), fullscreen:1"
      ];
    };
  };
}

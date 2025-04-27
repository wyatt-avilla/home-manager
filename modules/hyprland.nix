{
  lib,
  pkgs,
  config,
  hyprland,
  ...
}:
let
  inherit (config.variables) terminal;
  inherit (config.variables) wallPaper;

  clipHist = lib.getExe pkgs.cliphist;
in
{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ wallPaper ];
      wallpaper = [ " , ${wallPaper}" ];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    settings = {
      animations.enabled = false;

      general = {
        "$modifier" = "SUPER";
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
        "$modifier,code:47,exec,${terminal}"
        "$modifier,w,exec,${lib.getExe pkgs.google-chrome}"
        "$modifier,q,killactive"

        "$modifier,e,layoutmsg,cyclenext"
        "$modifier,i,layoutmsg,cycleprev"
        "$modifier,SPACE,layoutmsg,swapwithmaster"

        "$modifier,f,exec,${lib.getExe pkgs.fuzzel}"
        "$modifier SHIFT,f,exec,${lib.getExe pkgs.grim} -g \"$(${lib.getExe pkgs.slurp} -d)\" - | ${pkgs.wl-clipboard}/bin/wl-copy"
        "$modifier,p,togglespecialworkspace,popupterm"
        "$modifier,b,fullscreen,1"
        "$modifier,u,exec, ${clipHist} list | ${lib.getExe pkgs.fuzzel} --dmenu | ${clipHist} decode | ${pkgs.wl-clipboard}/bin/wl-copy"
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
        "opacity 0.8 override 0.65 override, class:Spotify"
        "bordercolor rgb(${lib.removePrefix "#" config.variables.colors.red}), fullscreen:1"
      ];
    };
  };
}

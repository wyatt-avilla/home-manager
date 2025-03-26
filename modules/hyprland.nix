{
  lib,
  pkgs,
  config,
  hyprland,
  ...
}:
let
  inherit (config.variables) terminal;
  wallpaperPath = builtins.fetchurl {
    url = "https://images.pexels.com/photos/3178786/pexels-photo-3178786.jpeg";
    sha256 = "sha256-E3YU/j5oLmUu9VS1aCXl4otLA86bxks3mw19Vi89gBw=";
  };
in
{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ wallpaperPath ];
      wallpaper = [ " , ${wallpaperPath}" ];
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

      bind = [
        "$modifier,code:47,exec,${terminal}"
        "$modifier,w,exec,google-chrome-stable"
        "$modifier,q,killactive"

        "$modifier,e,layoutmsg,cyclenext"
        "$modifier,i,layoutmsg,cycleprev"
        "$modifier,SPACE,layoutmsg,swapwithmaster"

        "$modifier,f,exec,fuzzel"
        "$modifier SHIFT,f,exec,grim -g \"$(slurp -d)\" - | wl-copy"
        "$modifier,p,togglespecialworkspace,popupterm"
        "$modifier,b,fullscreen,1"
        "$modifier,u,exec, cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"
      ];

      binde = [
        "$modifier,o,resizeactive,10 0"
        "$modifier,n,resizeactive,-10 0"
      ];

      bindm = [
        "$modifier,mouse:272,movewindow"
        "$modifier,mouse:273,resizewindow"
      ];

      workspace = [ "special:popupterm,on-created-empty:${terminal}" ];
    };
  };
}

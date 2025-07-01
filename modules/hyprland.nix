{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  inherit (config.variables) terminal;
  inherit (config.variables) wallPaper;

  clipHist = lib.getExe pkgs.cliphist;

  fuzzel = lib.getExe pkgs.fuzzel;
  grim = lib.getExe pkgs.grim;
  slurp = lib.getExe pkgs.slurp;
  swappy = lib.getExe pkgs.swappy;
  jq = lib.getExe pkgs.jq;

  screenshotScript = pkgs.writeShellScriptBin "screenshot" ''
    selection_choices=$(
    	cat <<EOF
    Monitor
    Window
    Region
    EOF
    )

    selected_mode=$(echo "''${selection_choices}" | ${fuzzel} --dmenu --lines 3)

    case "''${selected_mode}" in
    Monitor)
    	${grim} -g "$(${slurp} -o || true)" - | ${swappy} -f -
    	;;
    Window)
    	monitors="$(hyprctl -j monitors)"
    	clients=$(hyprctl -j clients | ${jq} -r '[.[] | select(.workspace.id | contains('"$(echo "''${monitors}" | ${jq} -r 'map(.activeWorkspace.id) | join(",")' || true)"'))]')
    	boxes="$(echo "''${clients}" | ${jq} -r '.[] | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1]) \(.title)"' | cut -f1,2 -d' ')"
    	${grim} -g "$(printf '%s\n' "''${boxes}" | ${slurp} -r || true)" - | ${swappy} -f -
    	;;
    Region)
    	${grim} -g "$(${slurp} -d || true)" - | ${swappy} -f -
    	;;
    *)
    	echo "No match"
    	;;
    esac
  '';
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
        "$modifier SHIFT,f,exec,${lib.getExe screenshotScript}"
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
        "opacity 0.8 override 0.65 override, class:[Ss]potify"
        "opacity 0.8 override 0.65 override, class:[Ww]eb[Cc]ord"
        "bordercolor rgb(${lib.removePrefix "#" config.variables.colors.red}), fullscreen:1"
      ];
    };
  };
}

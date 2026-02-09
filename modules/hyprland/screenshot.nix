{ lib, pkgs, ... }:
let
  fuzzel = lib.getExe pkgs.fuzzel;
  grim = lib.getExe pkgs.grim;
  slurp = lib.getExe pkgs.slurp;
  swappy = lib.getExe pkgs.swappy;
  jq = lib.getExe pkgs.jq;

  screenshotScript = pkgs.writeShellScript "screenshot" ''
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
  wayland.windowManager.hyprland.settings.bind = [
    "$modifier SHIFT,f,exec,${screenshotScript}"
  ];
}

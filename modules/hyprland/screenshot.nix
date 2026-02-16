{
  config,
  lib,
  pkgs,
  ...
}:
let
  menuName = "screenshot";

  grim = lib.getExe pkgs.grim;
  slurp = lib.getExe pkgs.slurp;
  swappy = lib.getExe pkgs.swappy;

  captureMonitor = pkgs.writeShellScript "capture-monitor" ''
    ${grim} -g "$(${slurp} -o 2>/dev/null || true)" - | ${swappy} -f -
  '';

  captureWindow = pkgs.writeShellScript "capture-window" ''
    monitors=$(hyprctl -j monitors)
    workspace_ids=$(echo "$monitors" | ${pkgs.jq}/bin/jq -r 'map(.activeWorkspace.id) | join(",")')
    clients=$(hyprctl -j clients | ${pkgs.jq}/bin/jq -r "[.[] | select(.workspace.id | contains($workspace_ids))] | .[] | \"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1]) \(.title)\"")
    boxes=$(echo "$clients" | cut -f1,2 -d' ')
    ${grim} -g "$(echo "$boxes" | ${slurp} -r 2>/dev/null || true)" - | ${swappy} -f -
  '';

  captureRegion = pkgs.writeShellScript "capture-region" ''
    ${grim} -g "$(${slurp} -d 2>/dev/null || true)" - | ${swappy} -f -
  '';
in
{
  wayland.windowManager.hyprland.settings.bind = [
    "$modifier SHIFT,f,exec,${lib.getExe config.programs.walker.package} --provider menus:${menuName} --maxheight 200 --placeholder \"Screenshot\""
  ];

  xdg.configFile."elephant/menus/${menuName}.toml".text = ''
    name = "${menuName}"
    name_pretty = "${lib.strings.toSentenceCase menuName}"
    icon = "camera-photo"

    [[entries]]
    text = "Monitor"
    keywords = ["screen", "display", "full"]
    icon = "video-display"
    actions = { "capture_monitor" = "${captureMonitor}" }

    [[entries]]
    text = "Window"
    keywords = ["window", "active", "focus"]
    icon = "window"
    actions = { "capture_window" = "${captureWindow}" }

    [[entries]]
    text = "Region"
    keywords = ["area", "selection", "crop", "select"]
    icon = "selection-rectangular"
    actions = { "capture_region" = "${captureRegion}" }
  '';
}

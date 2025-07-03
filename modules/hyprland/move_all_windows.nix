{ pkgs, lib, ... }:
let
  fuzzel = lib.getExe pkgs.fuzzel;
  jq = lib.getExe pkgs.jq;
  notifySend = lib.getExe pkgs.libnotify;

  moveAllWindows = pkgs.writeShellScriptBin "move_all_windows.sh" ''
    current_workspace=$(hyprctl activeworkspace -j | ${jq} -r '.id')
    target_workspace=$(${fuzzel} --dmenu --lines 0 --prompt "Switch all windows to workspace: ")

    if [ -z "''${target_workspace}" ]; then
      exit
    fi

    master_window=$(hyprctl clients -j | ${jq} -r "
        [.[] | select(.workspace.id == ''${current_workspace})] |
        max_by(.size[0] * .size[1]) |
        .address
    ")

    other_windows=$(hyprctl clients -j | ${jq} -r "
        [.[] | select(.workspace.id == ''${current_workspace}) | select(.address != \"''${master_window}\")] |
        sort_by(.at[1]) | reverse |
        .[].address
    ")

    if [ -n "''${master_window}" ] && [ "''${master_window}" != "null" ]; then
    	hyprctl dispatch movetoworkspacesilent "''${target_workspace}",address:"''${master_window}"
    fi

    for window in ''${other_windows}; do
    	if [ -n "''${window}" ] && [ "''${window}" != "null" ]; then
    		hyprctl dispatch movetoworkspacesilent "''${target_workspace}",address:"''${window}"
    	fi
    done

    ${notifySend} -e -t 1500 "All windows sent to workspace ''${target_workspace}"
  '';

  moveAllWindowsDesktop = pkgs.makeDesktopItem {
    name = "move-all-windows";
    desktopName = "move_all_windows.sh";
    comment = "Move all windows from current workspace to another";
    exec = "${moveAllWindows}/bin/move_all_windows.sh";
    categories = [ "Utility" ];
    icon = "${pkgs.adwaita-icon-theme}/share/icons/Adwaita/16x16/mimetypes/text-x-script.png";
    terminal = false;
  };
in
{
  home.packages = [ moveAllWindowsDesktop ];
}

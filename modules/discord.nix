{ pkgs, ... }:

let
  customExec = "${pkgs.discord}/bin/discord --enable-features=UseOzonePlatform --ozone-platform=wayland";
in
{
  home.packages = [ pkgs.discord ];

  xdg.desktopEntries.discord = {
    name = "Discord";
    genericName = "Internet Messenger";
    comment = "Chat on Discord";
    exec = customExec;
    icon = "discord";
    type = "Application";
    categories = [
      "Network"
      "InstantMessaging"
    ];
    terminal = false;
  };
}

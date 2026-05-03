{ lib, pkgs, ... }:
{
  services.hypridle = {
    enable = true;
    settings = {
      listener = {
        timeout = 60 * 30;
        on-timeout = "${lib.getExe' pkgs.systemd "systemctl"} suspend";
      };
    };
  };
}

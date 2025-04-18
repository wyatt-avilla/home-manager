{
  lib,
  pkgs,
  config,
  ...
}:

{
  imports = [
    ./hyprland.nix
    ../../modules/common.nix
  ];

  home = {
    username = "wyatt";
    homeDirectory = "/home/wyatt";

    packages = with pkgs; [ amdgpu_top ];

    stateVersion = "24.11";
  };

  services.hypridle = {
    enable = true;
    settings = {
      listener = {
        timeout = 60 * 20;
        on-timeout = "${pkgs.systemd}/bin/systemctl suspend";
      };
    };
  };
}

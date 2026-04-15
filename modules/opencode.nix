{ lib, ... }:
{
  programs.opencode = {
    enable = true;
    tui.theme = lib.mkForce "system";
    settings = {
      plugin = [ "@mohak34/opencode-notifier@0.1.19" ];
    };
  };
}

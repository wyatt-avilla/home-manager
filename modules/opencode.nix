{ lib, ... }:
{
  programs.opencode = {
    enable = true;
    settings = {
      plugin = [ "@mohak34/opencode-notifier@0.1.19" ];
      theme = lib.mkForce "system";
    };
  };
}

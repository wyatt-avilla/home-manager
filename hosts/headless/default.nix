{
  imports = [ ../../modules/headless.nix ];

  home.stateVersion = "26.05";

  targets.genericLinux.enable = true;
}

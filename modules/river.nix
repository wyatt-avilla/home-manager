{
  lib,
  pkgs,
  hyprland,
  hyprland-plugins,
  ...
}:

{
  home.packages = with pkgs; [
    alacritty
    river
  ];

  xdg.configFile."river/init" = {
    text = ''
      #!/bin/sh
      riverctl set-repeat 50 300
      riverctl set-cursor-warp on-focus-change
      riverctl map normal Super semicolon spawn alacritty
      riverctl map normal Super W spawn google-chrome-stable
      riverctl map normal Super Q close
      riverctl map normal Super M exit

      riverctl map normal Super N send-layout-cmd rivertile "main-ratio -0.05"
      riverctl map normal Super O send-layout-cmd rivertile "main-ratio +0.05"
      riverctl map normal Super E focus-view next
      riverctl map normal Super I focus-view previous
      riverctl map normal Super space zoom

      riverctl border-color-focused 0x93a1a1
      riverctl border-color-unfocused 0x586e75

      riverctl spawn rivertile
      riverctl output-layout rivertile

      riverctl map normal Super A set-focused-tag 1
      riverctl map normal Super R set-focused-tag 2
      riverctl map normal Super S set-focused-tag 4
      riverctl map normal Super T set-focused-tag 8
      riverctl map normal Super+Shift A set-view-tags 1
      riverctl map normal Super+Shift R set-view-tags 2
      riverctl map normal Super+Shift S set-view-tags 4
      riverctl map normal Super+Shift T set-view-tags 8
    '';
    executable = true;
  };
}

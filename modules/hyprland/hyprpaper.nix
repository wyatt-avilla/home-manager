{ config, ... }:
let
  inherit (config.variables) wallPaper;
in
{
  services.hyprpaper = {
    enable = true;
    settings = {
      # "/home/wyatt/media/Pictures/laptop-wallpapers/kodama.png"
      preload = [ wallPaper ];
      wallpaper = [ " , ${wallPaper}" ];
    };
  };
}

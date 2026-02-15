{ inputs, ... }:
{
  imports = [
    inputs.walker.homeManagerModules.default
    ./style.nix
  ];

  programs.walker = {
    enable = true;
    runAsService = true;

    config = {
      theme = "custom";
      force_keyboard_focus = true;
      hide_quick_activation = true;

      placeholders."default" = {
        input = "Search";
        list = "No Results";
      };

      keybinds = {
        next = [ "ctrl n" ];
        previous = [ "ctrl p" ];
        page_up = [ "ctrl u" ];
        page_down = [ "ctrl d" ];
      };

      providers = {
        default = [
          "desktopapplications"
          "calc"
          "providerlist"
        ];

        actions = {
          desktopapplications = [
            {
              action = "pin";
              bind = "alt p";
              after = "AsyncReload";
            }
            {
              action = "unpin";
              bind = "alt p";
              after = "AsyncReload";
            }
            {
              action = "pinup";
              bind = "alt n";
              after = "AsyncReload";
            }
            {
              action = "pindown";
              bind = "alt m";
              after = "AsyncReload";
            }
          ];
          clipboard = [
            {
              action = "pin";
              bind = "alt p";
              after = "AsyncClearReload";
            }
            {
              action = "unpin";
              bind = "alt p";
              after = "AsyncClearReload";
            }
          ];
        };
      };
    };
  };
}

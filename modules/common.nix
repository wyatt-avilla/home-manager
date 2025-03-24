{
  lib,
  pkgs,
  config,
  hyprland,
  nixvim,
  ...
}:
{
  imports = [
    ./yazi.nix
    ./river.nix
    ./waybar.nix
    ./hyprland.nix
    ./fuzzel.nix
    ./starship.nix
  ];

  options.variables = {
    terminal = lib.mkOption {
      type = lib.types.str;
      default = "ghostty";
      description = "Default teriminal";
    };

    fontFamily = lib.mkOption {
      type = lib.types.str;
      default = "Fira Code";
      description = "Default font";
    };
  };

  config = {
    nixpkgs.config.allowUnfree = true;

    home.sessionVariables = {
      EDITOR = "nvim";
      NIXOS_OZONE_WL = 1;
    };

    xdg.mimeApps = {
      enable = true;

      defaultApplications = {
        "x-scheme-handler/http" = "google-chrome.desktop";
        "x-scheme-handler/https" = "google-chrome.desktop";
        "text/html" = "google-chrome.desktop";
        "application/pdf" = "org.pwmt.zathura.desktop";
      };
    };

    home.packages = with pkgs; [
      nixvim.packages.${pkgs.system}.default
      wget
      fastfetch
      wl-clipboard
      google-chrome
      eza
      bat
      ripgrep
      fira-code
      jq
      tree
      hyprpicker
      cloc

      discord
      spotify

      hyprshot
      grim
      slurp
    ];

    services.cliphist.enable = true;

    fonts.fontconfig.enable = true;

    programs = {
      git = {
        userName = "Wyatt Avilla";
        userEmail = "wyattmurphy1@gmail.com";
        extraConfig.init.defaultBranch = "main";
        signing = {
          signByDefault = true;
        };
      };

      zsh = {
        enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        shellAliases = {
          ls = "eza --group-directories-first --icons";
          cat = "bat";
          grep = "rg";
          lf = "${config.programs.yazi.shellWrapperName}";
          vim = "nvim";
        };

        initExtra = ''
          bindkey -v

          bindkey -M vicmd 'n' backward-char
          bindkey -M vicmd 'e' down-line-or-history
          bindkey -M vicmd 'i' up-line-or-history
          bindkey -M vicmd 'o' forward-char
          bindkey -M vicmd 'h' vi-insert
          bindkey -v '^?' backward-delete-char

          export KEYTIMEOUT=1

          function zle-keymap-select {
            if [[ ''${KEYMAP} == vicmd ]] ||
               [[ $1 = 'block' ]]; then
              echo -ne '\e[1 q'
            elif [[ ''${KEYMAP} == main ]] ||
                 [[ ''${KEYMAP} == viins ]] ||
                 [[ ''${KEYMAP} = ''' ]] ||
                 [[ $1 = 'beam' ]]; then
              echo -ne '\e[5 q'
            fi
          }
          zle -N zle-keymap-select

          zle-line-init() {
            zle -K viins
            echo -ne "\e[5 q"
          }
          zle -N zle-line-init

          echo -ne '\e[5 q'
          preexec() { echo -ne '\e[5 q' ;}
        '';

        profileExtra = ''
          if [[ -z $SSH_TTY && $TTY == /dev/tty1 ]]; then
            Hyprland > /dev/null
          fi
        '';
      };

      ghostty = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          confirm-close-surface = false;
          window-decoration = false;
          font-family = config.variables.fontFamily;
        };
      };

      zathura = {
        enable = true;
        mappings = {
          "n" = "scroll left";
          "e" = "scroll down";
          "i" = "scroll up";
          "o" = "scroll right";

          "E" = "navigate next";
          "I" = "navigate previous";
        };

        options = {
          "selection-clipboard" = "clipboard";
        };
      };
    };
  };
}

{
  lib,
  pkgs,
  config,
  hyprland,
  nixvim,
  ...
}:
{
  config.nixpkgs.config.allowUnfree = true;

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

  config.home.sessionVariables = {
    EDITOR = "nvim";
    NIXOS_OZONE_WL = 1;
  };

  imports = [
    ./yazi.nix
    ./river.nix
    ./waybar.nix
    ./hyprland.nix
    ./fuzzel.nix
  ];

  config.xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "x-scheme-handler/http" = "google-chrome.desktop";
      "x-scheme-handler/https" = "google-chrome.desktop";
      "text/html" = "google-chrome.desktop";
      "application/pdf" = "org.pwmt.zathura.desktop";
    };
  };

  config.home.packages = with pkgs; [
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

    hyprshot
    grim
    slurp
  ];

  config.services.cliphist.enable = true;

  config.fonts.fontconfig.enable = true;

  config.programs.git = {
    userName = "Wyatt Avilla";
    userEmail = "wyattmurphy1@gmail.com";
    extraConfig.init.defaultBranch = "main";
  };

  config.programs.zsh = {
    enable = true;
    autosuggestion.enable = true;

    shellAliases = {
      ls = "eza --group-directories-first --icons";
      cat = "bat";
      grep = "rg";
      lf = "yazi";
      vim = "nvim";
    };

    profileExtra = ''
      if [[ -z $SSH_TTY && $TTY == /dev/tty1 ]]; then
        Hyprland > /dev/null
      fi
    '';
  };

  config.programs.starship = {
    enable = true;
    settings = {
      format = "󱄅(red) $username $directory $all";
      add_newline = true;

      username = {
        format = "[$user]($style)";
        show_always = true;
        style_user = "purple bold";
      };

      directory = {
        format = "at [$path]($style)[$read_only]($read_only_style)";
        truncation_length = 5;
        truncation_symbol = ".../";
        home_symbol = " ~";
        read_only = "  ";
        read_only_style = "red";
      };
    };
  };

  config.programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      confirm-close-surface = false;
      window-decoration = false;
      font-family = config.variables.fontFamily;
    };
  };

  config.programs.zathura = {
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
}

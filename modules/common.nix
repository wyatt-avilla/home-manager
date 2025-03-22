{
  lib,
  pkgs,
  config,
  hyprland,
  nixvim,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;

  home.sessionVariables = {
    NIXOS_OZONE_WL = 1;
  };

  imports = [
    ./yazi.nix
    ./river.nix
    ./waybar.nix
    ./hyprland.nix
  ];

  home.packages = with pkgs; [
    nixvim.packages.${pkgs.system}.default
    wget
    fastfetch
    wl-clipboard
    google-chrome
    wakatime-cli
    eza
    bat
    ripgrep
    fira-code
    jq
    tree
  ];

  fonts.fontconfig.enable = true;

  programs.git = {
    userName = "Wyatt Avilla";
    userEmail = "wyattmurphy1@gmail.com";
    extraConfig.init.defaultBranch = "main";
  };

  programs.zsh = {
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

  programs.starship = {
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

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      confirm-close-surface = false;
      window-decoration = false;
      font-family = "Fira Code";
    };
  };

  programs.zathura = {
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

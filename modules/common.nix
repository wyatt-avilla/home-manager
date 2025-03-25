{
  lib,
  pkgs,
  config,
  hyprland,
  nixvim,
  ...
}:

let
  allowedSigners = "${config.home.homeDirectory}/.ssh/allowed_signers";
in
{
  imports = [
    ./yazi.nix
    ./river.nix
    ./waybar.nix
    ./hyprland.nix
    ./fuzzel.nix
    ./starship.nix
    ./zsh.nix
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

    home = {
      file."${allowedSigners}".text =
        "* ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA/UBGJmU3oFOq4m7z0ZV9wzfUoU3UUdr4GE8x/VCjZU wyatt@puriel";

      sessionVariables = {
        EDITOR = "nvim";
        NIXOS_OZONE_WL = 1;
      };

      packages = with pkgs; [
        nixvim.packages.${pkgs.system}.default
        wget
        fastfetch
        wl-clipboard
        google-chrome
        eza
        bat
        ripgrep
        fira-code
        nerd-fonts.fira-code

        jq
        tree
        hyprpicker
        cloc

        discord
        spotify

        feh
        hyprshot
        grim
        slurp
      ];
    };

    xdg.mimeApps = {
      enable = true;

      defaultApplications = {
        "x-scheme-handler/http" = "google-chrome.desktop";
        "x-scheme-handler/https" = "google-chrome.desktop";
        "text/html" = "google-chrome.desktop";
        "application/pdf" = "org.pwmt.zathura.desktop";
        "image/png" = "feh.desktop";
        "image/jpeg" = "feh.desktop";
        "image/gif" = "feh.desktop";
        "image/webp" = "feh.desktop";
        "image/bmp" = "feh.desktop";
        "image/tiff" = "feh.desktop";
      };
    };

    services = {
      cliphist.enable = true;
      swaync.enable = true;
    };

    fonts.fontconfig.enable = true;

    programs = {
      git = {
        enable = true;
        userName = "Wyatt Avilla";
        userEmail = "wyattmurphy1@gmail.com";
        extraConfig.init.defaultBranch = "main";
        extraConfig.gpg.ssh.allowedSignersFile = allowedSigners;

        signing = {
          key = "~/.ssh/id_ed25519.pub";
          format = "ssh";
          signByDefault = true;
        };
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
          n = "scroll left";
          e = "scroll down";
          i = "scroll up";
          o = "scroll right";

          E = "navigate next";
          I = "navigate previous";
        };

        options = {
          selection-clipboard = "clipboard";
        };
      };
    };
  };
}

{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:

let
  allowedSigners = "${config.home.homeDirectory}/.ssh/allowed_signers";
  nixvim-stylix = inputs.nixvim.packages.${pkgs.system}.default;

  commandLine = with pkgs; [
    (lib.hiPrio uutils-coreutils-noprefix)
    nixvim-stylix
    wget
    jq
    tree
    hyprpicker
    cloc
    eza
    bat
    ripgrep
    fastfetch
    fzf
    fd
    btop
    delta
    ffmpeg
    duf
    zip
    unzip
    file
    usbutils
    entr
  ];

  gui = with pkgs; [
    fira-code
    nerd-fonts.fira-code
    google-chrome
    discord
    feh
    hyprshot
    wl-clipboard
    alsa-utils
    obs-studio
  ];

  dev = with pkgs; [
    cargo
    python3
    gh
    pre-commit
  ];

in
{
  imports = [
    ./yazi.nix
    ./hyprland.nix
    ./fuzzel.nix
    ./starship.nix
    ./zsh.nix
    ./stylix.nix
    ./spicetify.nix
  ];

  options.variables = {
    terminal = lib.mkOption {
      type = lib.types.str;
      default = "ghostty";
      description = "Default teriminal";
    };

    wallPaper = lib.mkOption {
      type = lib.types.path;
      default = builtins.fetchurl {
        url = "https://images.pexels.com/photos/3178786/pexels-photo-3178786.jpeg";
        sha256 = "sha256-E3YU/j5oLmUu9VS1aCXl4otLA86bxks3mw19Vi89gBw=";
      };
      description = "Default wallpaper";
    };
  };

  config = {
    nixpkgs.config.allowUnfree = true;

    home = {
      file."${allowedSigners}".text =
        "* ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA/UBGJmU3oFOq4m7z0ZV9wzfUoU3UUdr4GE8x/VCjZU wyatt@puriel";

      sessionVariables = {
        EDITOR = lib.getExe nixvim-stylix;
        NIXOS_OZONE_WL = 1;
      };

      packages = lib.flatten [
        commandLine
        gui
        dev
      ];

      file.".lesskey".text = ''
        # command
        e forw-line
        i back-line

        k repeat-search
        N reverse-search
      '';
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
      swaync.enable = true;
      cliphist.enable = true;
    };

    fonts.fontconfig.enable = true;

    programs = {
      git = {
        enable = true;
        userName = "Wyatt Avilla";
        userEmail = "wyattmurphy1@gmail.com";
        extraConfig = {
          init.defaultBranch = "main";
          gpg.ssh.allowedSignersFile = allowedSigners;
          push.autoSetupRemote = true;
        };

        signing = {
          key = "~/.ssh/id_ed25519.pub";
          format = "ssh";
          signByDefault = true;
        };

        delta.enable = true;
      };

      ghostty = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          confirm-close-surface = false;
          window-decoration = false;
          theme = "nix-colors";
        };

        themes = {
          nix-colors = {
            inherit (config.variables.colors) background;
            inherit (config.variables.colors) foreground;
            cursor-color = config.variables.colors.bright_white;
            palette = [
              "0=${config.variables.colors.darkest_black}"
              "1=${config.variables.colors.red}"
              "2=${config.variables.colors.green}"
              "3=${config.variables.colors.yellow}"
              "4=${config.variables.colors.blue}"
              "5=${config.variables.colors.purple}"
              "6=${config.variables.colors.cyan}"
              "7=${config.variables.colors.light_grey}"
              "8=${config.variables.colors.grey}"
              "9=${config.variables.colors.bright_red}"
              "10=${config.variables.colors.bright_green}"
              "11=${config.variables.colors.bright_yellow}"
              "12=${config.variables.colors.bright_blue}"
              "13=${config.variables.colors.bright_purple}"
              "14=${config.variables.colors.white}"
            ];
            selection-background = config.variables.colors.bright_black;
            selection-foreground = config.variables.colors.white;
          };
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

{
  lib,
  pkgs,
  inputs,
  ...
}:

let
  nixvim-stylix = inputs.nixvim.packages.${pkgs.stdenv.hostPlatform.system}.default;

  commandLine = with pkgs; [
    nixvim-stylix
    wget
    jq
    tree
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
    killall
    sops
    tldr
    hyperfine
    dust
    img2pdf
    hexyl
  ];

  gui = with pkgs; [
    fira-code
    nerd-fonts.fira-code
    google-chrome
    loupe
    hyprshot
    hyprpicker
    wl-clipboard
    alsa-utils
    obs-studio
    gimp
    obsidian
    slack
    discord
  ];

  dev = with pkgs; [
    cargo
    python3
    gh
    pre-commit
    nix-output-monitor
  ];
in
{
  imports = [
    ./hyprland
    ./walker
    ./swaync
    ./yazi.nix
    ./starship.nix
    ./zsh.nix
    ./wezterm.nix
    ./zathura.nix
    ./stylix.nix
    ./spicetify.nix
    ./git.nix
    ./ssh.nix
    ./sops.nix
    ./syncthing.nix
    ./waybar.nix
    ./opencode.nix
  ];

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ (import ../overlays/electron.nix) ];
  };

  news.display = "silent";

  home = {
    username = "wyatt";
    homeDirectory = "/home/wyatt";

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
      "inode/directory" = "yazi.desktop";
      "text/markdown" = "nvim.desktop";
      "text/x-markdown" = "nvim.desktop";
      "x-scheme-handler/http" = "google-chrome.desktop";
      "x-scheme-handler/https" = "google-chrome.desktop";
      "text/html" = "google-chrome.desktop";
      "application/pdf" = "org.pwmt.zathura.desktop";
      "image/png" = "org.gnome.Loupe.desktop";
      "image/jpeg" = "org.gnome.Loupe.desktop";
      "image/gif" = "org.gnome.Loupe.desktop";
      "image/webp" = "org.gnome.Loupe.desktop";
      "image/bmp" = "org.gnome.Loupe.desktop";
      "image/tiff" = "org.gnome.Loupe.desktop";
    };
  };

  fonts.fontconfig.enable = true;

  programs = {
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
}

{
  lib,
  pkgs,
  inputs,
  ...
}:

let
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
    killall
    sops
    tldr
    hyperfine
    dust
    img2pdf
  ];

  gui = with pkgs; [
    fira-code
    nerd-fonts.fira-code
    webcord
    google-chrome
    feh
    hyprshot
    hyprpicker
    wl-clipboard
    alsa-utils
    obs-studio
    gimp
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
    ./yazi.nix
    ./fuzzel.nix
    ./starship.nix
    ./zsh.nix
    ./ghostty.nix
    ./zathura.nix
    ./stylix.nix
    ./spicetify.nix
    ./git.nix
    ./ssh.nix
    ./sops.nix
    ./syncthing.nix
    ./waybar.nix
  ];

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ (import ../overlays/electron.nix) ];
  };

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

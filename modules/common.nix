{ pkgs, ... }:

let
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
    cheese
  ];

in
{
  imports = [
    ./headless.nix
    ./hyprland
    ./walker
    ./swaync
    ./wezterm.nix
    ./zathura.nix
    ./stylix.nix
    ./spicetify.nix
    ./git.nix
    ./ssh.nix
    ./sops.nix
    ./syncthing.nix
    ./waybar.nix
  ];

  home = {
    sessionVariables.NIXOS_OZONE_WL = 1;
    packages = gui;
  };

  programs.opencode.settings.plugin = [ "@mohak34/opencode-notifier@0.1.19" ];

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

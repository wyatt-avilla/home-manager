{ lib, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  home = {
    packages = with pkgs; [
      hyprland
      wget
      git
      neovim
      fastfetch
      ghostty
      kitty
      wl-clipboard
      google-chrome
      wakatime-cli
    ];

    username = "wyatt";
    homeDirectory = "/home/wyatt";

    stateVersion = "24.11";
  };

  programs.git = {
    userName = "Wyatt Avilla";
    userEmail = "wyattmurphy1@gmail.com";
    extraConfig.init.defaultBranch = "main";
  };

  programs.neovim = {
    vimAlias = true;
    plugins = [
      pkgs.vimPlugins.vim-wakatime
    ];
  };
}

{ lib, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  home = {
    packages = with pkgs; [
      hyprland
      wget
      git
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
    enable = true;
    vimAlias = true;
    plugins = [
      pkgs.vimPlugins.vim-wakatime
    ];
    extraLuaConfig = ''
      vim.opt.nu = true
      vim.keymap.set({ "n", "x" }, "n", "h", { noremap = true })
      vim.keymap.set({ "n", "x" }, "e", "j", { noremap = true })
      vim.keymap.set({ "n", "x" }, "i", "k", { noremap = true })
      vim.keymap.set({ "n", "x" }, "o", "l", { noremap = true })

      vim.keymap.set({ "n", "v" }, "h", "i", { noremap = true })
      vim.keymap.set({ "n", "v" }, "j", "o", { noremap = true })
      vim.keymap.set({ "n", "v" }, "k", "n", { noremap = true })
      vim.keymap.set({ "n", "v" }, "l", "e", { noremap = true })
    '';
  };
}

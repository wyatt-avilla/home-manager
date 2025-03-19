{ lib, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  home = {
    packages = with pkgs; [
      #hyprland
      wget
      fastfetch
      ghostty
      ghostty
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

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    settings = {
      general = {
        "$modifier" = "SUPER";
	layout = "master";
      };
      monitor = [
        "DP-1,2560x1440@165,0x0,1"
        "HDMI-A-1,1920x1080,2560x-200,1,transform,1"
      ];
      master = {
        new_on_top = true;
      };
      input = {
        repeat_rate = 60;
        repeat_delay = 400;
      };
      bind = [
        "$modifier,code:47,exec,ghostty"
        "$modifier,w,exec,google-chrome-stable"
        "$modifier,q,killactive"

        "$modifier,e,layoutmsg,cyclenext"
        "$modifier,i,layoutmsg,cycleprev"
        "$modifier,o,resizeactive,10 0"
        "$modifier,n,resizeactive,-10 0"

	"$modifier,a,workspace,1"
	"$modifier,r,workspace,2"
	"$modifier,s,workspace,3"
	"$modifier,t,workspace,4"

	"$modifier,a,movetoworkspace,1"
	"$modifier,r,movetoworkspace,2"
	"$modifier,s,movetoworkspace,3"
	"$modifier,t,movetoworkspace,4"
      ];
      bindm = [
        "$modifier,mouse:272,movewindow"
        "$modifier,mouse:273,resizewindow"
      ];
    };
  };
}

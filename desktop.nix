{ lib, pkgs, hyprland, hyprland-plugins, split-monitor-workspaces, ... }:
{
  nixpkgs.config.allowUnfree = true;

  home = {
    packages = with pkgs; [
      wget
      fastfetch
      wl-clipboard
      google-chrome
      wakatime-cli
      eza
      bat
      ripgrep
      yazi
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

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;

    shellAliases = {
      ls = "eza --group-directories-first --icons";
      cat = "bat";
      grep = "rg";
      lf = "yazi";
    };
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
    settings.confirm-close-surface = false;
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    defaultEditor = true;
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
    package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
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

        "$modifier SHIFT,a,movetoworkspace,1"
        "$modifier SHIFT,r,movetoworkspace,2"
        "$modifier SHIFT,s,movetoworkspace,3"
        "$modifier SHIFT,t,movetoworkspace,4"
      ];
      bindm = [
        "$modifier,mouse:272,movewindow"
        "$modifier,mouse:273,resizewindow"
      ];
      plugins = [
        #split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
      ];
    };
  };
}

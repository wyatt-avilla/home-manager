{ lib, pkgs, hyprland, hyprland-plugins, split-monitor-workspaces, ... }:
{
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    wget
    fastfetch
    wl-clipboard
    google-chrome
    wakatime-cli
    eza
    bat
    ripgrep
  ];

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

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    keymap = {
      manager.keymap = [
	{ on = "?"; run = "help"; desc = "Open help"; }
	{ on = "<Esc>"; run = "escape"; desc = "Exit visual mode, clear selected, or cancel search"; }
	{ on = "q"; run = "quit"; dect = "Exit the process"; }

	{ on = "i"; run = "arrow -1"; desc = "Move cursor up"; }
	{ on = "e"; run = "arrow 1"; desc = "Move cursor down"; }
	{ on = "I"; run = "arrow -5"; desc = "Move cursor up 5 lines"; }
	{ on = "E"; run = "arrow 5"; desc = "Move cursor down 5 lines"; }

	{ on = "n"; run = "leave"; desc = "Go back to the parent directory"; }
	{ on = "o"; run = "enter"; desc = "Enter the child directory"; }
	{ on = "N"; run = "back"; desc = "Go back to the previous directory"; }
	{ on = "O"; run = "forward"; desc = "Go forward to the next directory"; }

	{ on = ["g" "g"]; run = "arrow top"; desc = "Move cursor to the top"; }
	{ on = "G"; run = "arrow bottom"; desc = "Move cursor to the bottom"; }

	{ on = "s"; run = ["select --state=none" "arrow 1"]; desc = "Toggle the current selection state"; }
	{ on = "v"; run = "visual_mode"; desc = "Enter visual selection mode"; }
	{ on = "V"; run = "visual_mode --unset"; desc = "Enter visual selection unset mode"; }

	{ on = "O"; run = "open --interactive"; desc = "Open the selected files interactively"; }
	{ on = "<Enter>"; run = "open"; desc = "Open the selected files"; }

	{ on = "y"; run = "yank"; desc = "Copy the selected files"; }
	{ on = "Y"; run = "unyank"; desc = "Cancel the yank status of files"; }
	{ on = "x"; run = "yank --cut"; desc = "Cut the selected files"; }
	{ on = "p"; run = "paste"; desc = "Paste the files"; }
	{ on = "P"; run = "paste --force"; desc = "Paste the files (overwrite if destination exists)"; }
	{ on = "d"; run = "remove"; desc = "Move the selected files to the trash"; }
	{ on = "X"; run = "remove --permanently"; desc = "Permanently delete the files"; }
	{ on = "m"; run = "create"; desc = "Create file or directory (ends with / for directories)"; }
	{ on = "r"; run = "rename --cursor=before_ext"; desc = "Rename a file or directory"; }
	{ on = ";"; run = "shell"; desc = "Run a shell command"; }
	{ on = ":"; run = "shell --block"; desc = "Run a shell command (blocking)"; }
	{ on = "."; run = "hidden toggle"; desc = "Toggle the visibility of hidden files"; }

	{ on = "<Space>"; run = "search fd"; desc = "Search files by name using fd"; }
	{ on = ["l" "g"]; run = "search rg"; desc = "Search file contents by using ripgrep"; }

	{ on = ["c" "c"]; run = "copy path"; desc = "Copy the absolute path"; }
	{ on = ["c" "d"]; run = "copy dirname"; desc = "Copy the path of the parent directory"; }
	{ on = ["c" "f"]; run = "copy filename"; desc = "Copy the name of the file"; }

	{ on = "/"; run = "find --smart"; desc = "Find files"; }
	{ on = "k"; run = "find_arrow"; desc = "Go to next found file"; }
	{ on = "N"; run = "find_arrow --previous"; desc = "Go to previousfound file"; }
      ];

      select.keymap = [
	{ on = "?"; run = "help"; desc = "Open help"; }
	{ on = "<C-q>"; run = "close"; desc = "Cancel selection"; }
	{ on = "<Esc>"; run = "close"; desc = "Cancel selection"; }
	{ on = "<Enter>"; run = "close --submit"; desc = "Submit the selection"; }

	{ on = "i"; run = "arrow -1"; desc = "Move cursor up"; }
	{ on = "e"; run = "arrow 1"; desc = "Move cursor down"; }
	{ on = "I"; run = "arrow -5"; desc = "Move cursor up 5 lines"; }
	{ on = "E"; run = "arrow 5"; desc = "Move cursor down 5 lines"; }
      ];

      input.keymap = [
	{ on = "?"; run = "help"; desc = "Open help"; }
	{ on = "<C-q>"; run = "close"; desc = "Cancel selection"; }
	{ on = "<Esc>"; run = "close"; desc = "Go back to normal mode or cancel selection"; }
	{ on = "<Enter>"; run = "close --submit"; desc = "Submit the selection"; }
        
	{ on = "h"; run = "insert"; desc = "Enter insert  mode"; }
	{ on = "a"; run = "insert --append"; desc = "Enter append mode"; }
	{ on = "I"; run = ["move -999" "insert"]; desc = "Enter append mode"; }
	{ on = "A"; run = ["move 999" "insert --append"]; desc = "Enter append mode"; }
	{ on = "v"; run = "visual"; desc = "Enter visual mode"; }
	{ on = "V"; run = ["move -999" "visual" "move 999"]; desc = "Enter visual mode and select all"; }

	{ on = "n"; run = "move -1"; desc = "Move back a character"; }
	{ on = "o"; run = "move 1"; desc = "Move forward a character"; }
	{ on = "b"; run = "backward"; desc = "Move back a word"; }
	{ on = "w"; run = "forward"; desc = "Move forward a word"; }
	{ on = "0"; run = "move -999"; desc = "Move to the BOL"; }
	{ on = "$"; run = "move 999"; desc = "Move to the EOL"; }

	{ on = "<Backspace>"; run = "backspace"; desc = "Delete the character before the cursor"; }

	{ on = "d"; run = "delete --cut"; desc = "Cut the selected characters"; }
	{ on = "D"; run = ["delete --cut" "move 999"]; desc = "Cut until EOL"; }
	{ on = "c"; run = "delete --cut --insert"; desc = "Cut the selected characters and enter insert mode"; }
	{ on = "C"; run = ["delete --cut --insert" "move 999"]; desc = "Cut the selected characters and enter insert mode"; }
	{ on = "x"; run = ["delete --cut" "move 1 --in-operating"]; desc = "Cut the current character"; }
	{ on = "y"; run = "yank"; desc = "Copy the selected characters"; }
	{ on = "p"; run = "paste"; desc = "Paste the copied characters after the cursor"; }
	{ on = "P"; run = "paste --before"; desc = "Paste the copied characters before the cursor"; }

	{ on = "u"; run = "undo"; desc = "Undo the last operation"; }
	{ on = "<C-R>"; run = "redo"; desc = "Redo the last operation"; }
      ];

      help.keymap = [
	{ on = "<Esc>"; run = "escape"; desc = "Clear the filter or hide the help"; }
	{ on = "q"; run = "close"; desc = "Exit the process"; }

	{ on = "i"; run = "arrow -1"; desc = "Move cursor up"; }
	{ on = "e"; run = "arrow 1"; desc = "Move cursor down"; }
	{ on = "I"; run = "arrow -5"; desc = "Move cursor up 5 lines"; }
	{ on = "E"; run = "arrow 5"; desc = "Move cursor down 5 lines"; }

	{ on = "/"; run = "filter"; desc = "Apply a filter to the help items"; }
      ];
    };
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

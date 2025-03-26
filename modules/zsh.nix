{
  lib,
  pkgs,
  config,
  nixvim,
  ...
}:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "${lib.getExe pkgs.eza} --group-directories-first --icons";
      cat = lib.getExe pkgs.bat;
      grep = lib.getExe pkgs.ripgrep;
      lf = "${config.programs.yazi.shellWrapperName}";
      vim = lib.getExe nixvim.packages.${pkgs.system}.default;
    };

    initExtra = ''
      bindkey -v

      bindkey -M vicmd 'n' backward-char
      bindkey -M vicmd 'e' down-line-or-history
      bindkey -M vicmd 'i' up-line-or-history
      bindkey -M vicmd 'o' forward-char
      bindkey -M vicmd 'h' vi-insert
      bindkey -v '^?' backward-delete-char

      export KEYTIMEOUT=1

      function zle-keymap-select {
        if [[ ''${KEYMAP} == vicmd ]] ||
           [[ $1 = 'block' ]]; then
          echo -ne '\e[1 q'
        elif [[ ''${KEYMAP} == main ]] ||
             [[ ''${KEYMAP} == viins ]] ||
             [[ ''${KEYMAP} = ''' ]] ||
             [[ $1 = 'beam' ]]; then
          echo -ne '\e[5 q'
        fi
      }
      zle -N zle-keymap-select

      zle-line-init() {
        zle -K viins
        echo -ne "\e[5 q"
      }
      zle -N zle-line-init

      echo -ne '\e[5 q'
      preexec() { echo -ne '\e[5 q' ;}
    '';
  };
}

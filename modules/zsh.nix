{
  lib,
  pkgs,
  inputs,
  config,
  nixvim,
  ...
}:

{
  programs.fzf.enableZshIntegration = true;
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "${lib.getExe pkgs.eza} --group-directories-first --icons";
      cat = lib.getExe pkgs.bat;
      lf = "${config.programs.yazi.shellWrapperName}";
      vim = lib.getExe inputs.nixvim.packages.${pkgs.system}.default;
    };

    initContent = ''
      export KEYTIMEOUT=1
      export FZF_COMPLETION_TRIGGER='**'
      export FZF_DEFAULT_OPTS='
        --preview "bat --style=numbers --color=always {} | head -100"
        --bind ctrl-u:preview-up
        --bind ctrl-d:preview-down
      '
      export FZF_DEFAULT_COMMAND='${lib.getExe pkgs.fd} --type f'

      setopt HISTVERIFY

      rg() {
        command rg --json -C 2 "$@" | delta
      }

      bindkey -v

      bindkey -M vicmd 'n' backward-char
      bindkey -M vicmd 'e' down-line-or-history
      bindkey -M vicmd 'i' up-line-or-history
      bindkey -M vicmd 'o' forward-char
      bindkey -M vicmd 'h' vi-insert
      bindkey -v '^?' backward-delete-char

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

      if [[ $options[zle] = on ]]; then
        . $(${pkgs.fzf}/bin/fzf-share)/completion.zsh
        . $(${pkgs.fzf}/bin/fzf-share)/key-bindings.zsh
      fi

      echo -ne '\e[5 q'
      preexec() { echo -ne '\e[5 q' ;}
    '';
  };
}

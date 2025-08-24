{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  fzfPreview = pkgs.writeShellScriptBin "fzf-preview" ''
    if [[ -d "$1" ]]; then
      ${lib.getExe pkgs.eza} --tree --level=2 --color=always --group-directories-first --icons "$1"
    elif [[ -f "$1" ]]; then
      ${lib.getExe pkgs.bat} --style=numbers --color=always "$1" | head -100
    else
      echo "Cannot preview: $1"
    fi
  '';

  fzfConfig = ''
    export FZF_COMPLETION_TRIGGER='**'
    export FZF_DEFAULT_OPTS='
      --preview "${lib.getExe fzfPreview} {}"
      --bind ctrl-u:preview-up
      --bind ctrl-d:preview-down
    '
    export FZF_DEFAULT_COMMAND='${lib.getExe pkgs.fd} --type f'

    export ABBR_SET_EXPANSION_CURSOR=1

    if [[ $options[zle] = on ]]; then
      . $(${pkgs.fzf}/bin/fzf-share)/completion.zsh
      . $(${pkgs.fzf}/bin/fzf-share)/key-bindings.zsh
    fi
  '';

  vimMode = ''
    export KEYTIMEOUT=1
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
        echo -ne '\e[2 q'
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
in
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

    zsh-abbr = {
      enable = true;
      abbreviations = {
        gd = "git diff";
        gs = "git status";
        gbr = "git branch";
        gco = "git checkout";
        gsw = "git switch";
        gcm = "git commit -m \"%\"";
        gpl = "git pull";
        gph = "git push";
        grs = "git restore";

        try = "nix-shell -p % --run zsh";
        nd = "nix develop";
        nb = "nix build";

        py = "python3";
      };
    };

    initContent =
      fzfConfig
      + vimMode
      + ''
        setopt HISTVERIFY

        rg() {
          command rg --json -C 2 "$@" | delta
        }
      '';
  };
}

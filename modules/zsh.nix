{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  ezaTree = "${lib.getExe pkgs.eza} --tree --level=3 --color=always --group-directories-first --icons";

  fzfPreview = pkgs.writeShellScriptBin "fzf-preview" ''
    if [[ -d "$1" ]]; then
      ${ezaTree} "$1"
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

  nixTemp = ''
    nix-temp() {
      pkgs_json_file="/tmp/nixpkgs.json"

      if ! [[ -f "$pkgs_json_file" ]] || [[ $(find "$pkgs_json_file" -mtime +1 2>/dev/null) ]]; then
        nix search nixpkgs ''' --json 1>"$pkgs_json_file" 2>/dev/null
      fi

      selected_packages=$(
        ${lib.getExe' pkgs.coreutils "cat"} "$pkgs_json_file" |
          ${lib.getExe pkgs.jq} -r 'keys[]' |
          ${lib.getExe pkgs.gnused} 's/^legacyPackages\.${pkgs.system}\.//' |
          ${lib.getExe pkgs.fzf} -m --preview-window=wrap --wrap-sign=''' --preview "
            pkg={}
            version=\$(${lib.getExe pkgs.jq} -r \".[\\\"legacyPackages.x86_64-linux.\$pkg\\\"].version // empty\" '$pkgs_json_file')
            description=\$(${lib.getExe pkgs.jq} -r \".[\\\"legacyPackages.x86_64-linux.\$pkg\\\"].description // empty\" '$pkgs_json_file')
            
            if [[ -n \"\$version\" ]]; then
                echo \"Version: \$version\"
            fi
            
            if [[ -n \"\$description\" ]]; then
                echo \"\$description\"
            else
                echo \"No Description\"
            fi
          "
      )

      if [[ -n $selected_packages ]]; then
      	pkg_array=(''${=selected_packages})
      	nix-shell -p "''${pkg_array[@]}" --run zsh
      fi
    }
  '';

  ripGrep = ''
    rg() {
      command rg --json -C 2 "$@" | delta
    }
  '';

  style = ''
    zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
    zstyle ':completion:*:descriptions' format '[%d]'
    zstyle ':fzf-tab:complete:cd:*' fzf-preview '${lib.getExe pkgs.eza} -1 --icons=always --color=always $realpath'
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
      lt = ezaTree;
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

    plugins = [
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
    ];

    initContent = ''
      setopt HISTVERIFY
    ''
    + fzfConfig
    + style
    + vimMode
    + nixTemp
    + ripGrep;
  };
}

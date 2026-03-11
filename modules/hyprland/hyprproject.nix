{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (config.variables) terminal;
  jq = lib.getExe pkgs.jq;
  hyprctl = lib.getExe' config.wayland.windowManager.hyprland.package "hyprctl";

  launchScript = pkgs.writeShellScriptBin "hyprproject-launch" ''
    workspace_id=$(${hyprctl} activeworkspace -j | ${jq} -r '.id')
    dir_file="$XDG_RUNTIME_DIR/hyprproject/$workspace_id"

    if [ -f "$dir_file" ]; then
      dir=$(cat "$dir_file")
      exec ${terminal} start --cwd "$dir"
    else
      exec ${terminal} start --cwd "$HOME"
    fi
  '';

  hyprprojectFunction = ''
    hyprproject() {
      local runtime_dir="''${XDG_RUNTIME_DIR}/hyprproject"
      local action="$1"
      local workspace_id="$2"
      local directory="$3"

      if [[ -z "$action" ]]; then
        echo "Usage: hyprproject {bind|unbind|query|display} <workspace_id|current> [directory]"
        return 1
      fi

      if [[ "$action" != "display" && -z "$workspace_id" ]]; then
        echo "Usage: hyprproject {bind|unbind|query|display} <workspace_id|current> [directory]"
        return 1
      fi

      if [[ "$workspace_id" == "current" ]]; then
        workspace_id=$(${hyprctl} activeworkspace -j | ${jq} -r '.id')
      fi

      case "$action" in
        bind)
          if [[ -z "$directory" ]]; then
            echo "Usage: hyprproject bind <workspace_id|current> <directory>"
            return 1
          fi
          mkdir -p "$runtime_dir"
          echo "$directory" > "$runtime_dir/$workspace_id"
          ;;
        unbind)
          rm -f "$runtime_dir/$workspace_id"
          ;;
        query)
          local file="$runtime_dir/$workspace_id"
          if [[ -f "$file" ]]; then
            cat "$file"
          else
            return 1
          fi
          ;;
        display)
          if [[ ! -d "$runtime_dir" ]] || [[ -z "$(ls -A "$runtime_dir" 2>/dev/null)" ]]; then
            echo "No workspace bindings found."
            return 0
          fi

          local h1="WORKSPACE" h2="DIRECTORY"
          local w1=''${#h1} w2=''${#h2}
          local -A _hp_bindings

          for file in "$runtime_dir"/*; do
            local ws_id="''${file##*/}"
            local dir=$(cat "$file")
            _hp_bindings[$ws_id]="$dir"
            (( ''${#ws_id} > w1 )) && w1=''${#ws_id}
            (( ''${#dir} > w2 )) && w2=''${#dir}
          done

          (( w1 += 2 ))
          (( w2 += 2 ))
          local total=$(( w1 + w2 + 3 ))

          _hp_rep() { printf "%0.s$1" $(seq 1 $2); }

          local title="Workspace Bindings"
          local title_pad=$(( total - 3 - ''${#title} ))

          echo "╭$(_hp_rep ─ $((total - 2)))╮"
          printf "│ %s%*s│\n" "$title" "$title_pad" ""
          echo "├$(_hp_rep ─ $w1)┬$(_hp_rep ─ $w2)┤"
          printf "│ %-*s│ %-*s│\n" "$((w1 - 1))" "$h1" "$((w2 - 1))" "$h2"
          echo "├$(_hp_rep ─ $w1)┼$(_hp_rep ─ $w2)┤"

          for ws_id in $(echo ''${(k)_hp_bindings} | tr ' ' '\n' | sort -n); do
            local dir="''${_hp_bindings[$ws_id]}"
            printf "│ %-*s│ %-*s│\n" "$((w1 - 1))" "$ws_id" "$((w2 - 1))" "$dir"
          done

          echo "╰$(_hp_rep ─ $w1)┴$(_hp_rep ─ $w2)╯"
          ;;
        *)
          echo "Usage: hyprproject {bind|unbind|query|display} <workspace_id|current> [directory]"
          return 1
          ;;
      esac
    }
  '';
in
{
  options.variables.hyprprojectLaunchScript = lib.mkOption {
    type = lib.types.str;
    default = lib.getExe launchScript;
    readOnly = true;
    description = "Path to the hyprproject terminal launch script";
  };

  config = {
    programs.zsh.initContent = hyprprojectFunction;
  };
}

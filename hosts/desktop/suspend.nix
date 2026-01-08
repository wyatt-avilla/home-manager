{ lib, pkgs, ... }:
let
  jq = lib.getExe pkgs.jq;
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  cat = "${pkgs.coreutils}/bin/cat";
  systemctl = "${pkgs.systemd}/bin/systemctl";

  mkSuspendScripts =
    className: commandName:
    let
      lower = lib.strings.toLower className;
      flagFile = "/tmp/${lower}-running.flag";
    in
    {
      pre = pkgs.writeShellScriptBin "${lower}-pre-suspend" ''
        client=$(${hyprctl} clients -j | ${jq} -c '.[] | select(.class == "${className}")')
        ws_id=$(echo "$client" | ${jq} -r '.workspace.id' | head -n1)
        address=$(echo "$client" | ${jq} -r '.address' | head -n1)

        if [ -n "$address" ] && [ -n "$ws_id" ] && [[ "$ws_id" =~ ^[0-9]+$ ]]; then
          ${hyprctl} dispatch killwindow address:"$address"
          echo "$ws_id" > ${flagFile}
          echo "Closed ${className} on workspace $ws_id"
        else
          rm -f ${flagFile}
        fi
      '';

      post = pkgs.writeShellScriptBin "${lower}-post-resume" ''
        if [ -f ${flagFile} ]; then
          ws_id=$(${cat} ${flagFile})
          rm -f ${flagFile}

          if [ -n "$ws_id" ] && [[ "$ws_id" =~ ^[0-9]+$ ]]; then
            ${hyprctl} dispatch exec "[workspace $ws_id silent] ${commandName}"
            echo "Restored ${commandName} to workspace $ws_id"
          fi
        fi
      '';
    };

  mkSuspendWrapper =
    name: scripts:
    pkgs.writeShellScriptBin name ''
      set -e
      ${lib.concatStringsSep "\n  " (map (script: "${script}/bin/${script.name}") scripts)}
    '';

  discordScripts = mkSuspendScripts "spotify" "spotify";

  allPreScripts = [ discordScripts.pre ];

  allPostScripts = [ discordScripts.post ];

  preSuspendScript = mkSuspendWrapper "pre-suspend-all" allPreScripts;
  postResumeScript = mkSuspendWrapper "post-resume-all" allPostScripts;
in
{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        before_sleep_cmd = "${preSuspendScript}/bin/pre-suspend-all";
        after_sleep_cmd = "${postResumeScript}/bin/post-resume-all";
      };
      listener = {
        timeout = 60 * 20;
        on-timeout = "${systemctl} suspend";
      };
    };
  };
}

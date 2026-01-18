{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  sshPubSecret = "${config.variables.secretsDirectory}/ssh-public-key";
  sshPrivateSecret = "${config.variables.secretsDirectory}/ssh-private-key";

  keyDirectory = "${config.home.homeDirectory}/.ssh/";

  sshKeyLoadScript = pkgs.writeShellScriptBin "ssh-key-load" ''
    if [ -s "${sshPubSecret}" ] && [ -s "${sshPrivateSecret}" ]; then
      cp -f "${sshPubSecret}" "${config.variables.sshKeyPairPaths.public}"
      cp -f "${sshPrivateSecret}" "${config.variables.sshKeyPairPaths.private}"
    fi
  '';
in
{
  options.variables = {
    sshKeyPairPaths = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        public = "${keyDirectory}/id_ed25519.pub";
        private = "${keyDirectory}/id_ed25519";
      };
      description = "SSH key pair paths";
    };
  };

  config = {
    programs.ssh = {
      enable = true;
      matchBlocks = {
        "homelab" = {
          hostname = inputs.nix-secrets.nixosModules.plainSecrets.vps.publicIp;
          port = 2222;
          user = "wyatt";
          setEnv = {
            TERM = "xterm-256color";
          };
        };
        "vps" = {
          hostname = inputs.nix-secrets.nixosModules.plainSecrets.vps.publicIp;
          user = "wyatt";
          setEnv = {
            TERM = "xterm-256color";
          };
        };
      };
    };

    services.ssh-agent.enable = true;
    systemd.user.services.ssh-key-load = {
      Unit = {
        Description = "Generate ssh keypair from decrypted secrets";
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${sshKeyLoadScript}/bin/ssh-key-load";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}

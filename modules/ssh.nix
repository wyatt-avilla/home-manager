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

  sshKeyLoadScript = pkgs.writeShellScript "ssh-key-load" ''
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
      enableDefaultConfig = false;
      settings =
        let
          hostname = "ssh.${inputs.nix-secrets.nixosModules.plainSecrets.domain.personal}";
          user = "wyatt";
          jumpHost = "vps-jump";
          homelabWireguardIP = "10.0.0.2";
        in
        {
          ${jumpHost} = {
            User = user;
            HostName = hostname;
            Port = 2222;
            SetEnv = {
              TERM = "xterm-256color";
            };
          };
          "homelab" = {
            User = user;
            HostName = homelabWireguardIP;
            ProxyJump = jumpHost;
            SetEnv = {
              TERM = "xterm-256color";
            };
          };
          "vps" = {
            User = user;
            HostName = hostname;
            SetEnv = {
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
        ExecStart = "${sshKeyLoadScript}";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}

{
  pkgs,
  config,
  inputs,
  ...
}:
let
  email = inputs.nix-secrets.nixosModules.plainSecrets.email.linux;
  allowedSigners = "${config.home.homeDirectory}/.ssh/allowed_signers";

  allowedSignersScript = pkgs.writeShellScriptBin "allowed-signers-file-gen" ''
    if [ -s "${config.variables.secretsDirectory}/ssh-public-key" ]; then
      printf "${email} $(cat "${config.variables.secretsDirectory}/ssh-public-key")" > "${allowedSigners}"
    fi
  '';
in
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Wyatt Avilla";
        inherit email;
      };

      init.defaultBranch = "main";
      gpg.ssh.allowedSignersFile = allowedSigners;
      push.autoSetupRemote = true;
    };

    signing = {
      key = config.variables.sshKeyPairPaths.public;
      format = "ssh";
      signByDefault = true;
    };
  };

  programs.difftastic = {
    enable = true;
    git.enable = true;
  };

  systemd.user.services.allowed-signers-file-gen = {
    Unit = {
      Description = "Generates an allowed signers file from the user's decrypted public ssh key";
    };

    Service = {
      ExecStart = "${allowedSignersScript}/bin/allowed-signers-file-gen";
      Type = "oneshot";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}

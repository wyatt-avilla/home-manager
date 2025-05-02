{
  lib,
  pkgs,
  config,
  ...
}:

let
  keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  sopsPrivateKey = "${config.variables.secretsDirectory}/sops-private-key";

  sopsKeyFileGenScript = pkgs.writeShellScriptBin "sops-key-file-gen" ''
    if [ -s "${sopsPrivateKey}" ]; then
      cp -f "${sopsPrivateKey}" "${keyFile}"
    fi
  '';
in
{
  options.variables.secretsDirectory = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/.config/sops-nix/secrets";
    description = "Decrypted SOPS secrets directory";
  };

  config = {
    sops.age.keyFile = keyFile;

    systemd.user.services.sops-key-file-gen = {
      Unit = {
        Description = "Copies SOPS private key to the age key file location, if present.";
      };

      Service = {
        ExecStart = "${sopsKeyFileGenScript}/bin/sops-key-file-gen";
        Type = "oneshot";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}

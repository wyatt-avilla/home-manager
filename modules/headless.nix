{
  lib,
  pkgs,
  inputs,
  ...
}:

let
  nixvim = inputs.nixvim.packages.${pkgs.stdenv.hostPlatform.system}.default;

  commandLine = with pkgs; [
    nixvim
    codex
    wget
    jq
    tree
    cloc
    eza
    bat
    ripgrep
    fastfetch
    fzf
    fd
    btop
    delta
    ffmpeg
    duf
    zip
    unzip
    file
    usbutils
    entr
    killall
    sops
    tldr
    hyperfine
    dust
    img2pdf
    hexyl
    nh
    git
    openssh
  ];

  dev = with pkgs; [
    cargo
    python3
    gh
    pre-commit
    nix-output-monitor
  ];
in
{
  imports = [
    ./yazi.nix
    ./starship.nix
    ./zsh.nix
    ./opencode.nix
  ];

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ (import ../overlays/codex.nix) ];
  };

  news.display = "silent";

  home = {
    username = "wyatt";
    homeDirectory = "/home/wyatt";

    sessionVariables.EDITOR = lib.getExe nixvim;

    packages = lib.flatten [
      commandLine
      dev
    ];

    file.".lesskey".text = ''
      # command
      e forw-line
      i back-line

      k repeat-search
      N reverse-search
    '';
  };

  programs.difftastic = {
    enable = true;
    git.enable = true;
  };
}

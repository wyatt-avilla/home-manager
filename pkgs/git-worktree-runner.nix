{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  bash,
  coreutils,
  findutils,
  gawk,
  git,
  gnugrep,
  gnused,
  perl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "git-worktree-runner";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "coderabbitai";
    repo = "git-worktree-runner";
    rev = "v${version}";
    hash = "sha256-k2bJiT2bElUewypuuW5hHZWA9/Q2AfzrRLzUkuowh3c=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -d "$out/libexec/git-worktree-runner"
    cp -r adapters bin completions lib "$out/libexec/git-worktree-runner/"
    patchShebangs "$out/libexec/git-worktree-runner/bin"

    makeWrapper "$out/libexec/git-worktree-runner/bin/git-gtr" "$out/bin/git-gtr" \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          coreutils
          findutils
          gawk
          git
          gnugrep
          gnused
          perl
        ]
      }

    install -Dm644 completions/_git-gtr "$out/share/zsh/site-functions/_git-gtr"
    install -Dm644 completions/gtr.bash "$out/share/bash-completion/completions/git-gtr"
    install -Dm644 completions/git-gtr.fish "$out/share/fish/vendor_completions.d/git-gtr.fish"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Portable Git worktree manager with editor and AI tool integration";
    homepage = "https://github.com/coderabbitai/git-worktree-runner";
    license = licenses.asl20;
    mainProgram = "git-gtr";
    platforms = platforms.unix;
  };
}

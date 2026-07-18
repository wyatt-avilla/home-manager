{
  lib,
  fetchurl,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation rec {
  pname = "codex";
  version = "0.144.6";

  src = fetchurl {
    url = "https://github.com/openai/codex/releases/download/rust-v${version}/codex-x86_64-unknown-linux-musl.tar.gz";
    hash = "sha256-ap3vUaCtjOpmhNjrO/AzyJ8z47xc/kkvGh4KcYRRocY=";
  };

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -Dm755 codex-x86_64-unknown-linux-musl "$out/bin/codex"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Lightweight coding agent that runs in your terminal";
    homepage = "https://github.com/openai/codex";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    mainProgram = "codex";
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
  };
}

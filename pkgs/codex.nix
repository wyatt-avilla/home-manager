{
  autoPatchelfHook,
  fetchurl,
  glibc,
  lib,
  ncurses,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation rec {
  pname = "codex";
  version = "0.153.4";

  src = fetchurl {
    url = "https://github.com/openai/codex/releases/download/rust-v${version}/codex-package-x86_64-unknown-linux-musl.tar.gz";
    hash = "sha256-qCIYfhokIMYcWSZyG/vYeHAe2VVHybsNTeRJiha6GCE=";
  };

  appServerSrc = fetchurl {
    url = "https://github.com/openai/codex/releases/download/rust-v${version}/codex-app-server-x86_64-unknown-linux-musl.tar.gz";
    hash = "sha256-rODnlMU9DBq+L9uSSGhJBNBLCKylp4UbxKfOCId3PPA=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    glibc
    ncurses
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp -r bin codex-package.json codex-path codex-resources "$out/"

    tar -xzf "$appServerSrc"
    install -Dm755 codex-app-server-x86_64-unknown-linux-musl "$out/bin/codex-app-server"

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

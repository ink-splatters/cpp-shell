{ pkgs, lib, llvmPackages, system, ... }:
let inherit (llvmPackages) lldb stdenv;
in rec {
  replaceStdenv = pkg: pkg.overrideAttrs (_: { inherit stdenv; });

  CFLAGS =
    lib.optionalString ("${system}" == "aarch64-darwin") "-mcpu=apple-m1";
  CXXFLAGS = "${CFLAGS}";
  LDFLAGS = "-fuse-ld=lld";

  nativeBuildInputs = with pkgs;
    [ bison ccache cmake conan gnumake flex meson ninja ]
    ++ [ lldb (replaceStdenv pkgs.xcodebuild) ];
}

{
  pkgs ? import <nixpkgs> { },
}:
let
  inherit (pkgs.llvmPackages_18) stdenv;
in
pkgs.mkShell {
  inherit stdenv;

  CXXFLAGS = [
    "-O3"
    "-ffast-math"
    "-mtune=native"
    "-funroll-loops"
    "-flto=thin"
    "-mcpu=apple-m1"
  ];

  LDFLAGS = [ "-fuse-ld=lld" ];

  hardeningDisable = [
    "format"
    "stackprotector"
    "fortify"
    "pie"
    "relro"
    "bindnow"
    "pic"
  ];

  nativeBuildInputs = with pkgs; [
    cmake
    ninja
    pkg-config
  ];

  shellHook = ''
    export CXXFLAGS="$CXXFLAGS -O3 -ffast-math -mtune=native -funroll-loops -flto=thin -mcpu=apple-m1"
    export LDFLAGS="$LDFLAGS -fuse-ld=lld"
  '';
}

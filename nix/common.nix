{
  llvmPackages_18,
  lib,
  lld_18,
  pkgs,
  system,
  ...
}:
let
  inherit (llvmPackages_18) bintools libcxx;
in
rec {
  CFLAGS = lib.optionalString ("${system}" == "aarch64-darwin") "-mcpu=apple-m1 ";
  CXXFLAGS = "${CFLAGS}";
  LDFLAGS = "-fuse-ld=lld -lc++ -lc++abi";

  buildInputs = [
    libcxx
    bintools
  ];
  nativeBuildInputs = with pkgs; [
    ccache
    cmake
    gnumake
    lld_18
    ninja
    pkg-config
  ];
}

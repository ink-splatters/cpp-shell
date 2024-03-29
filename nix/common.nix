{ llvmPackages_17, lib, lld_17, pkgs, system, ... }:
let inherit (llvmPackages_17) bintools libcxx;
in rec {
  CFLAGS =
    lib.optionalString ("${system}" == "aarch64-darwin") "-mcpu=apple-m1 ";
  CXXFLAGS = "${CFLAGS}";
  LDFLAGS = "-fuse-ld=lld -lc++ -lc++abi";

  buildInputs = [ libcxx bintools ];
  nativeBuildInputs = with pkgs; [
    ccache
    cmake
    gnumake
    lld_17
    ninja
    pkg-config
  ];
}

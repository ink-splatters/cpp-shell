{ pkgs, lib, system, ... }:
let inherit (pkgs.llvmPackages_17) bintools libcxx;
in with pkgs; rec {
  CFLAGS =
    lib.optionalString ("${system}" == "aarch64-darwin") "-mcpu=apple-m1 "
    + "-I${lib.getDev libcxx}/include/c++/v1";
  CXXFLAGS = "${CFLAGS}";
  LDFLAGS = "-fuse-ld=lld -L${libcxx}/lib";

  nativeBuildInputs = with pkgs; [
    bison
    ccache
    cmake
    conan
    gnumake
    flex
    meson
    ninja
    lldb_17
    bintools # https://matklad.github.io/2022/03/14/rpath-or-why-lld-doesnt-work-on-nixos.html
  ];
}

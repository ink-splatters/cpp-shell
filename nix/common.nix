{ pkgs, lib, system, ... }: rec {
  CFLAGS =
    lib.optionalString ("${system}" == "aarch64-darwin") "-mcpu=apple-m1";
  CXXFLAGS = "${CFLAGS}";
  LDFLAGS = "-fuse-ld=lld";

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
    llvmPackages_17.bintools # https://matklad.github.io/2022/03/14/rpath-or-why-lld-doesnt-work-on-nixos.html
  ];
}

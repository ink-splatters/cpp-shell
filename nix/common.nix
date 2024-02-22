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
  ];
}

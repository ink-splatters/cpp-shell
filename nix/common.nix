{ llvmPackages, lib, system, ... }@pkgs:
let inherit (llvmPackages) lld xcodebuild clang-tools lldb;
in with pkgs; {
  flags = rec {
    CFLAGS =
      lib.optionalString ("${system}" == "aarch64-darwin") "-mcpu=apple-m1";
    CXXFLAGS = "${CFLAGS}";
    LDFLAGS = "-fuse-ld=lld";
  };
  nativeBuildInputs = [ bison ccache cmake conan gnumake flex meson ninja ]
    ++ [ lldb xcodebuild ];

  buildInputs = [ clang-tools lldb ];
  # ++ [
  #   ccls
  # ]
}

{
  description = "basic cpp development shell";

  outputs = { nixpkgs, flake-utils, self, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          # config.allowUnsupportedSystem = true;
        };

        CFLAGS = pkgs.lib.optionalString ("${system}" == "aarch64-darwin") "-mcpu=apple-m1";
        CXXFLAGS = CFLAGS;
        LDFLAGS = "-fused-ld=lld";

        nativeBuildInputs = with pkgs; [
          bison
          ccache
          cmake
          conan
          gnumake
          flex
          meson
          ninja
          (with llvmPackages; [ lld xcodebuild ])
        ];

        buildInputs = with pkgs; [
          (with llvmPackages; [ clang-tools lldb ])
          ccls
        ];

        inherit (pkgs.llvmPackages) stdenv;

        default = with pkgs; mkShell.override { stdenv = stdenv; } {
          inherit CFLAGS CXXFLAGS LDFLAGS nativeBuildInputs;

          shellHook = ''
            export PS1="\n\[\033[01;32m\]\u $\[\033[00m\]\[\033[01;36m\] \w >\[\033[00m\] "
          '';
        };

        unhardened = {
          hardeningDisable = [ "all" ];
        } // default;

        O3 = {
          CFLAGS = "${CFLAGS} -O3";
          CXXFLAGS = "${CXXFLAGS} -O3";
        } // default;

        O3-unhardened = O3 // unhardened;
      in
      {

        checks.default = stdenv.mkDerivation {
          inherit (self.devShells.${system}.default) nativeBuildInputs CFLAGS CXXFLAGS LDFLAGS;

          name = "check";
          src = ./checks;
          dontBuild = true;
          doCheck = true;

          checkPhase = ''
            clang++ main.cpp -o helloworld
          '';
          installPhase = ''
            mkdir "$out"
          '';
        };
        formatter = pkgs.nixpkgs-fmt;
        devShells = {
          inherit default O3 unhardened O3-unhardened;
        };
        packages.default = pkgs.buildEnv {
          name = "cpp-env";

          paths = buildInputs;
        };

      });
}

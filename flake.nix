{
  description = "basic cpp development shell";

  outputs = { nixpkgs, flake-utils, self, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnsupportedSystem = true;
        };
        hardeningDisable = [ "all" ];
        CFLAGS = "-fuse-ld=lld";
        CXXFLAGS = "${CFLAGS} -stdlib=libc++";

        mkSh = args: with pkgs; mkShell.override { inherit (llvmPackages_latest) stdenv; }
          {
            inherit CFLAGS CXXFLAGS;

            nativeBuildInputs = [
              cmake
              ninja
              gnumake
              buck2
              meson
              flex
              bison
              ccls
              ccache
              (with llvmPackages_latest; [ llvm lldb clang-tools lld ])
            ];

            shellHook = ''
              export PS1="\n\[\033[01;32m\]\u $\[\033[00m\]\[\033[01;36m\] \w >\[\033[00m\] "
            '';
          } // args;

      in
      with pkgs; {
        formatter = nixpkgs-fmt;
        devShells = {
          default = mkSh { };

          O3 = mkSh {
            CFLAGS = "${CFLAGS} -O3";
            CXXFLAGS = "${CXXFLAGS} -O3";
          };

          unhardened = mkSh {
            inherit hardeningDisable;
          };

          O3-unhardened = mkSh {
            inherit hardeningDisable;
            CFLAGS = "${CFLAGS} -O3";
            CXXFLAGS = "${CXXFLAGS} -O3";
          };
        };

        checks.default =
          let
            inherit (self.devShells.${system}.default) stdenv nativeBuildInputs CFLAGS CXXFLAGS;
          in
          stdenv.mkDerivation {


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
      });
}

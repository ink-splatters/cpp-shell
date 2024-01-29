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


        CFLAGS = "-mcpu native";
        CXXFLAGS = "${CFLAGS} -stdlib=libc++";
        mkSh = args:
          let
            inherit (pkgs) llvmPackages_latest;
          in
          pkgs.mkShell.override
            {
              inherit (llvmPackages_latest) stdenv;
            }
            {

              inherit CFLAGS CXXFLAGS;
              nativeBuildInputs = with pkgs;[
                cmake
                ninja
                gnumake
                buck2
                meson
                xmake
                llvmPackages_latest.llvm
              ];


              shellHook = ''
                export PS1="\n\[\033[01;32m\]\u $\[\033[00m\]\[\033[01;36m\] \w >\[\033[00m\] "
              '';
            } // args;

      in
      {
        formatter = pkgs.nixpkgs-fmt;
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

        checks.default = pkgs.stdenv.mkDerivation {
          inherit (self.devShells.${system}.default) CFLAGS CXXFLAGS;

          name = "check";
          src = ./checks;
          dontBuild = true;
          doCheck = true;

          checkPhase = ''
            clang++ checks/main.cpp -o helloworld
          '';
          installPhase = ''
            mkdir "$out"
          '';
        };
      });
}

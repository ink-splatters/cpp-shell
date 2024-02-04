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

        mkSh = args: with pkgs; mkShell
          {
            LDFLAGS = "-fused-ld=lld";

            nativeBuildInputs = [
              cmake
              ninja
              gnumake
              meson
              flex
              bison
              ccache
            ];


            shellHook = ''
              export PS1="\n\[\033[01;32m\]\u $\[\033[00m\]\[\033[01;36m\] \w >\[\033[00m\] "
            '';
          } // args;

      in
      with pkgs; {

        checks.default =
          let
            inherit (self.devShells.${system}.default) stdenv nativeBuildInputs LDFLAGS;
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
        formatter = nixpkgs-fmt;
        devShells = {
          default = mkSh { };

          O3 = mkSh {
            CFLAGS = "-O3";
            CXXFLAGS = "-O3";
          };

          unhardened = mkSh {
            inherit hardeningDisable;
          };

          O3-unhardened = mkSh {
            inherit hardeningDisable;
            CFLAGS = "-O3";
            CXXFLAGS = "-O3";
          };
        };
        packages.default = buildEnv {
          name = "cpp-env";

          paths = with llvmPackages; [
            # ccls
            lldb
            llvm
            clang-tools
            xcodebuild
          ];
        };

      });
}

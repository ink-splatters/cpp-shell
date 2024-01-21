{
  description = "basic cpp development shell";


  outputs = { nixpkgs, flake-utils, self, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        hardeningDisable = [ "all" ];

        shellHook = ''
          export PS1="\n\[\033[01;32m\]\u $\[\033[00m\]\[\033[01;36m\] \w >\[\033[00m\] "
        '';

        CFLAGS = "-mcpu native";
        CXXFLAGS = "${CFLAGS} -stdlib=libc++";
        mkShell =
          let
            inherit (pkgs) mkShell llvmPackages_latest;
          in
          mkShell.override {
            inherit (llvmPackages_latest) stdenv;
          };
      in
      {
        formatter = pkgs.nixpkgs-fmt;
        devShells = {
          default = mkShell {
            inherit CFLAGS CXXFLAGS shellHook;
          };

          O3 = mkShell {
            inherit shellHook;

            CFLAGS = "${CFLAGS} -O3";
            CXXFLAGS = "${CXXFLAGS} -O3";
          };

          unhardened = mkShell {
            inherit CFLAGS CXXFLAGS shellHook hardeningDisable;
          };

          O3-unhardened = mkShell {
            inherit shellHook hardeningDisable;

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

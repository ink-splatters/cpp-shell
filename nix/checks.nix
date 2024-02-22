{ pkgs, pre-commit-hooks, system, common, ... }: {
  default = pkgs.llvmPackages_17.stdenv.mkDerivation rec {

    inherit (common) CFLAGS CXXFLAGS LDFLAGS;

    name = "check";

    src = ../checks;

    # dontBuild = true;
    doCheck = true;

    buildPhase = ''
      clang++ main.cpp -o helloworld
    '';
    checkPhase = ''
      ./helloworld
    '';
    installPhase = ''
      mkdir "$out"
    '';
  };

  pre-commit-check = pre-commit-hooks.lib.${system}.run {
    src = ../.;
    hooks = {
      clang-format.enable = true;
      clang-tidy.enable = true;
      deadnix.enable = true;
      markdownlint.enable = true;
      nil.enable = true;
      nixfmt.enable = true;
      statix.enable = true;
    };

    settings.markdownlint.config = { MD041.level = 2; };

    tools = pkgs;
  };
}

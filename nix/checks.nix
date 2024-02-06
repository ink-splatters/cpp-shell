{ pkgs, pre-commit-hooks, system, ... }@common: {
  default = pkgs.stdenv.mkDerivation {
    name = "check";
    src = ../checks;
    dontBuild = true;
    doCheck = true;

    # inherit (common) nativeBuildInputs CFLAGS CXXFLAGS LDFLAGS;

    checkPhase = ''
      clang++ main.cpp -o helloworld
    '';
    installPhase = ''
      mkdir "$out"
    '';
  } // common;

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

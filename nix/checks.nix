{pkgs, pre-commit-hooks, nativeBuildInputs, flags,...}@common : {
 default = stdenv.mkDerivation {
    name = "check";
    src = ../checks;
    dontBuild = true;
    doCheck = true;

    inherit nativeBuildInputs;

    checkPhase = ''
      clang++ main.cpp -o helloworld
    '';
    installPhase = ''
      mkdir "$out"
    '';
  } // flags;

  pre-commit-check = pre-commit-hooks.lib.${system}.run {
      src = ./.;
      hooks = {
        clang-format.enable = true;
        clang-tidy.enable = true;
        deadnix.enable = true;
        markdownlint.enable = true;
        nil.enable = true;
        nixpkgs-fmt.enable = true;
        statix.enable = true;
      };

      tools = pkgs;
    };
}
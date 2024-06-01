{
  pkgs,
  common,
  self,
  system,
  ...
}:
let
  preCommitShellHook =
    let
      inherit (self.checks.${system}.pre-commit-check) shellHook;
    in
    shellHook;
in
with pkgs;
rec {
  default = mkShell.override { inherit (llvmPackages_18) stdenv; } {

    inherit (common)
      CFLAGS
      CXXFLAGS
      LDFLAGS
      buildInputs
      nativeBuildInputs
      ;

    name = "cpp-shell";

    shellHook =
      preCommitShellHook
      + ''
        export PS1="\n\[\033[01;36m\]‹⊂˖˖› \\$ \[\033[00m\]"
        echo -e "\nto install pre-commit hooks:\n\x1b[1;37mnix develop .#install-hooks\x1b[00m"
      '';
  };

  unhardened = default.overrideAttrs (_: {
    hardeningDisable = [ "all" ];
  });

  O3 = default.overrideAttrs (
    _:
    let
      inherit (common) CFLAGS CXXFLAGS;
    in
    {
      CFLAGS = "${CFLAGS} -O3";
      CXXFLAGS = "${CXXFLAGS} -O3";
    }
  );

  O3-unhardened = O3.overrideAttrs (_: {
    hardeningDisable = [ "all" ];
  });

  install-hooks = mkShell.override { stdenv = stdenvNoCC; } {
    inherit system;
    shellHook = ''
      ${preCommitShellHook}
      echo Done!
      exit
    '';
  };
}

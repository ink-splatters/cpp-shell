{
  callPackage,
  llvmPackages_18,
  mkShell,
  stdenvNoCC,
  pkgs,
  pre-commit-check,
  ...
}:
let
  compilerFlags = callPackage ./compiler-flags.nix { maxPerf = true; };
in
{
  default = mkShell.override { inherit (llvmPackages_18) stdenv; } {
    name = "cpp-shell";

    inherit (compilerFlags)
      CFLAGS
      CXXFLAGS
      LDFLAGS
      hardeningDisable
      ;

    nativeBuildInputs = with pkgs; [
      ccache
      cmake
      gnumake
      lld_18
      ninja
      pkg-config
    ];

    shellHook =
      pre-commit-check.shellHook
      + ''
        export PS1="\n\[\033[01;36m\]‹⊂˖˖› \\$ \[\033[00m\]"
        echo -e "\nto install pre-commit hooks:\n\x1b[1;37mnix develop .#install-hooks\x1b[00m"
      '';
  };
  install-hooks = mkShell.override { stdenv = stdenvNoCC; } {
    shellHook =
      let
        inherit (pre-commit-check) shellHook;
      in
      ''
        ${shellHook}
        echo Done!
        exit
      '';
  };
}

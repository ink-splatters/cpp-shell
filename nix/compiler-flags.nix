{
  pkgs,
  llvmPackages_18,
  maxPerfUnhardened ? false,
  maxPerf ? maxPerfUnhardened,
  isThinLTO ? false,
  isLTO ? maxPerf,
  isLLD ? true,
  ...
}:
let
  inherit (pkgs) clang_18 lib;

  oneOf =
    cond: lst1: lst2:
    if cond then lst1 else lst2;
  opt = cond: lst: oneOf cond lst [ ];

  flags =
    opt llvmPackages_18.stdenv.isDarwin [ "-mcpu=apple-m1" ]
    ++ oneOf maxPerf [ "-O3" ] [ "-O2" ]
    ++ opt maxPerf [ "-ffast-math" ]
    ++ opt maxPerf [ "-mtune=native" ]
    ++ opt maxPerf [ "-funroll-loops" ]
    ++ opt isThinLTO [ "-flto=thin" ]
    ++ opt (isLTO && !isThinLTO) [ "-flto" ];

  hardeningDisable = opt maxPerfUnhardened [ "all" ];
  LDFLAGS = lib.optionalString isLLD ? "-fuse-ld=lld";

  inherit (builtins) concatStringsSep readFile;
  getNixCompilerFlags =
    lst: map (flags: (lib.removeSuffix "\n" (readFile "${clang_18}/nix-support/${flags}"))) lst;

  mergeFlags = lst: concatStringsSep " " lst;

in
{
  CFLAGS = mergeFlags (
    flags
    ++ getNixCompilerFlags [
      "cc-cflags"
      "libc-cflags"
      "libcxx-cxxflags"
    ]
  );
  CXXFLAGS = mergeFlags (flags ++ getNixCompilerFlags [ "libcxx-cxxflags" ]);
  inherit LDFLAGS;
  inherit hardeningDisable;
}

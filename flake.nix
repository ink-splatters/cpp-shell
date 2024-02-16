{
  description = "basic cpp development shell";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  nixConfig = {
    extra-substituters = "https://cachix.cachix.org";
    extra-trusted-public-keys =
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM=";
  };

  outputs = { nixpkgs, flake-utils, pre-commit-hooks, self, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          # config.allowUnsupportedSystem = true;
        };

        inherit (pkgs) callPackage;

        common = callPackage ./nix/common.nix { inherit system; };
      in {

        checks = import ./nix/checks.nix {
          inherit pkgs pre-commit-hooks system common;
        };

        formatter = pkgs.nixfmt;

        devShells =
          import ./nix/shells.nix { inherit pkgs common self system; };

        packages.cpp-tools = with pkgs;
          buildEnv {
            name = "cpp-tools";
            paths = map common.replaceStdenv [ clang-tools lldb ];
          };
      });
}

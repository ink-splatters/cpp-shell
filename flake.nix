{
  description = "basic cpp development shell";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";

    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        gitignore.follows = "gitignore";
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs";
      };
    };
  };

  nixConfig = {
    extra-substituters = "https://cachix.cachix.org";
    extra-trusted-public-keys = "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM=";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      git-hooks,
      self,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        inherit (pkgs) callPackage;

        common = callPackage ./nix/common.nix { inherit system; };
      in
      {

        checks.pre-commit-check = callPackage ./nix/pre-commit-check.nix { inherit pkgs git-hooks system; };

        formatter = pkgs.nixfmt-rfc-style;

        devShells = import ./nix/shells.nix {
          inherit
            pkgs
            common
            self
            system
            ;
        };
      }
    );
}

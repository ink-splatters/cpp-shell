{
  description = "basic cpp development shell";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
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
    extra-trusted-public-keys = "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM=";
  };

  outputs = { nixpkgs, flake-utils, pre-commit-hooks,self, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          # config.allowUnsupportedSystem = true;
        };
        inherit (pkgs) callPackage;

        # inherit (llvmPackages)stdenv;
        common = (callPackage ./nix/common {} );
        package =  pkg: callPackage { inherit common ; };
        
      in with pkgs; {

        devShells =  package ./nix/shells {};
        checks =  package ./nix/checks {};

        formatter = pkgs.alejandra;

        packages.cpp-tools = pkgs.buildEnv {          
          name = "cpp-tools";
          
          paths = buildInputs;
        };

      });
}

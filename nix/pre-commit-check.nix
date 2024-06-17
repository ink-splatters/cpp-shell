{
  pkgs,
  git-hooks,
  system,
  ...
}:

git-hooks.lib.${system}.run {
  src = ../.;
  hooks = {
    clang-format.enable = true;
    clang-tidy.enable = true;
    deadnix.enable = true;
    markdownlint = {
      enable = true;
      settings.configuration = {
        MD041.level = 2;
      };
    };

    nil.enable = true;
    nixfmt = {
      package = pkgs.nixfmt-rfc-style;
      enable = true;
    };
    statix.enable = true;
  };

  tools = pkgs;
}

{flags, }@common:
let 
	inh

{

  default = mkShell.override { stdenv = stdenv; } {
  inherit CFLAGS CXXFLAGS LDFLAGS buildInputs nativeBuildInputs;

  shellHook = ''
    export PS1="\n\[\033[01;32m\]\u $\[\033[00m\]\[\033[01;36m\] \w >\[\033[00m\] "
  '';
  };

  unhardened = {
    hardeningDisable = [ "all" ];
  } // default;

  O3 = {
    CFLAGS = "${CFLAGS} -O3";
    CXXFLAGS = "${CXXFLAGS} -O3";
  } // default;

  O3-unhardened = O3 // unhardened;

}
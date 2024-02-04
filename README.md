## dev-shells / cpp

barebone cpp development shell based on `nix flakes`

### Requirements

`nix` with `flake` support

to enable it, given nix is installed:

```shell
mkdir -p $HOME/.config/nix
cat <<'EOF' >> $HOME/.config/nix.conf

experimental-features = flakes nix-command

EOF
```

alternatively, add the following alias to your shell:

```shell
alias nix='nix --arg experimental-features='nix-command flakes'
```

### Shells

default shell can be entered using:

```shell
nix develop github:ink-splatters/cpp-shell

```

there are 3 more shell types:

- `#O3` ( adds `-O3` to `CFLAGS` and `CXXFLAGS` )
- `#unhardened` ( disables hardening using [hardeningDisable](https://nixos.wiki/wiki/C)
- `#O3-unhardened` ( self explanatory )

all the shells feature:
- `-mcpu=apple-m1` if applicable
- LDFLAGS=`-fused-ld=lld`


### Examples

#### Enter O3 shell
```shell
nix develop github:ink-splatters/cpp-shell#O3
```

#### Enter O3-unhardened shell locally

```shell
git clone https://github.com/ink-splatters/cpp-shell.git
cd cpp-shell
nix develop .#O3-unhardened
```

### nix profile installation

optionally, the following  tools can be installed `nix profile` - wise:

- `lldb`
- `clang-format`, `clangd` and more tools included in nix `clang-tools` package

to install it:

```
nix profile install github:ink-splatters/cpp-shell
```

### Alternatives

More advanced `nix`-based alternatives which support wider range of tools and options:

[devshell](https://github.com/numtide/devshell)
[devenv](http://devenv.sh)


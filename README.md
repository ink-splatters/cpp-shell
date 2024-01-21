## Cpp Dev Shell

barebone cpp dev shell based on `nix flakes`

production ready and much more feature-rich alternative: https://devenv.sh

### Requirements

`nix` with `flake` support

to enable it, given nix is installed:

```shell
mkdir -p $HOME/.config/nix
cat <<'EOF' >> $HOME/.config/nix.conf

experimental-features = flakes nix-command

EOF
```

### Usage

- enter shell

```shell
nix develop github:ink-splatters/cpp-shell --impure
```

- enter shell with -O3 enabled, locally:

```shell
git clone https://github:ink-splatters/cpp-shell.git
cd cpp-shell
nix develop .#O3 --impure
```

### Shell List

- default
- `cpp-O3`

with hardening disabled:

- `unhardened`
- `O3-unhardened`

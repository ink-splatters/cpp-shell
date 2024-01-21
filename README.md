## Dev Shells

barebone dev shells based on `nix flakes`

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

```shell
nix develop github:ink-splatters/dev-shells#<name> --impure
```

#### Examples

- enter `swift` shell (contains `swift` and swift package manager) without cloning the repo:

```shell
nix develop github:ink-splatters/dev-shells#swift --impure
```

- enter `cpp` shell, locally:

```shell
git clone https://github:ink-splatters/dev-shells.git
cd dev-shells
nix develop .#cpp
```

### Shell List

- `cpp`
- `cpp-O3`
- `swift`
- `swift-O3`

with hardening disabled:

- `cpp-unhardened`
- `cpp-O3-unhardened`
- `swift-unhardened`
- `swift-O3-unhardened`

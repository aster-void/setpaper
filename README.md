# Setpaper script

usage:

```sh
setpaper ./path/to/wallpaper.png # temporary, will reset after reboot
setpaper --write ./path/to/wallpaper.jpg # create a symlink at ~/.config/wallpaper as well as changing the paper
```
## compilation

you need nix with flakes to compile.

```sh
nix build .#setpaper
```

## installation

you need nix to install.

```nix
# using devShell flake
{
  inputs.setpaper = "github:aster-void/setpaper";
  inputs.setpaper.inputs.nixpkgs.follows = "nixpkgs"; # to avoid downloading unnecessary nixpkgs
  outputs = { nixpkgs, setpaper, ... }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    devShell.${system} = pkgs.mkShell {
      buildInputs = [
        # ...
        setpaper.packages.${system}.default
      ];
    };
  };
}
```

same thing on nixos and home manager.

## runtime dependencies

- Hyprland
- hyprpaper

{
  description = "Wallpaper changer";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, self }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        usage = ''
        '';
        script = import ./main.sh;
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [ ];
        };
        packages.default = self.packages.${system}.setpaper;
        packages.setpaper = pkgs.stdenvNoCC.mkDerivation {
          src = ./.;
          name = "setpaper";
          installPhase = ''
            mkdir -p $out/bin
            cp ${script} $out/bin/setpaper
          '';
        };
      });
}

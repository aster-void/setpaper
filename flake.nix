{
  description = "Wallpaper changer";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pname = "setpaper";
        version = "0.1.0";
      in
      {
        packages.setpaper = pkgs.stdenvNoCC.mkDerivation {
          inherit pname version;
          src = ./.;
          buildInputs = [ pkgs.bun ];
          buildPhase = ''
            bun build . --compile --outfile ./setpaper
          '';
          installPhase = ''
            mkdir -p $out/bin
            cp ./setpaper $out/bin
          '';
        };
        packages.default = self.packages.x86_64-linux.setpaper;
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [ bun ];
        };
      });
}

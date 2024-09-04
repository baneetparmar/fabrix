{
  description = "Fabric Bar Example";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/24.05";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    fabric.url = "github:wholikeel/fabric-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      treefmt-nix,
      fabric,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        fabric-overlay = fabric.overlays.${system}.default;
        pkgs = (nixpkgs.legacyPackages.${system}.extend fabric-overlay);
        treefmtEval = treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} ./treefmt.nix;
      in
      {
        formatter = treefmtEval.config.build.wrapper;
        devShells.default = pkgs.callPackage ./shell.nix { inherit pkgs; };
        packages.default = pkgs.callPackage ./derivation.nix { inherit (pkgs) lib python3Packages; };
        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/fabrix";
        };
      }
    );
}

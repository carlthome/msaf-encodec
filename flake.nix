{
  description = "A little Python environment for MIR research";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages =
        rec {
          encodec = pkgs.callPackage ./packages/encodec.nix { };
          pedalboard = pkgs.callPackage ./packages/pedalboard.nix { };
          vmo = pkgs.callPackage ./packages/vmo.nix { };
          jams = pkgs.callPackage ./packages/jams.nix { };
          msaf = pkgs.callPackage ./packages/msaf.nix { inherit jams; inherit vmo; };

          pythonEnvironment = (pkgs.python3.withPackages (ps: [
            encodec
            pedalboard
            vmo
            ps.mir_eval
            jams
            msaf
          ]));

          main =
            let
              name = "main";
              settings = { libraries = [ msaf encodec ]; };
              script = builtins.readFile ./main.py;
            in
            pkgs.writers.writePython3Bin name settings script;

          default = main;
        };

      apps = {
        default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/main";
        };
      };

      devShells = {
        default = pkgs.mkShell {
          packages = with pkgs; [
            self.packages.${system}.pythonEnvironment
            pre-commit
            jupyter
            black
          ] ++ black.optional-dependencies.jupyter;
        };
      };

      formatter = pkgs.nixpkgs-fmt;
    });
}

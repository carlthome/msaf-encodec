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
          mir_eval = pkgs.callPackage ./packages/mir_eval.nix { };
          jams = pkgs.callPackage ./packages/jams.nix { inherit mir_eval; };
          msaf = pkgs.callPackage ./packages/msaf.nix { inherit mir_eval; inherit jams; inherit vmo; };

          pythonEnvironment = (pkgs.python3.withPackages (ps: [
            encodec
            pedalboard
            vmo
            mir_eval
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
          buildInputs = [
            self.packages.${system}.pythonEnvironment
            pkgs.pre-commit
            pkgs.python3Packages.ipykernel
          ];
        };
      };

      formatter = pkgs.nixpkgs-fmt;
    });
}

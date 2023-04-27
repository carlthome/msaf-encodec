{
  description = "A little Python environment for MIR research";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      buildPythonPackage = pkgs.python3Packages.buildPythonPackage;
      buildPythonApplication = pkgs.python3Packages.buildPythonApplication;
    in
    {
      packages = rec {
        vmo = pkgs.callPackage ./packages/vmo.nix { inherit buildPythonPackage; };
        mir_eval = pkgs.callPackage ./packages/mir_eval.nix { inherit buildPythonPackage; };
        jams = pkgs.callPackage ./packages/jams.nix { inherit buildPythonPackage; inherit mir_eval; };
        msaf = pkgs.callPackage ./packages/msaf.nix { inherit buildPythonPackage; inherit mir_eval; inherit jams; inherit vmo; };
        pythonEnvironment = (pkgs.python3.withPackages (ps: [
          ps.ipython
          mir_eval
        ]));
        main = pkgs.writers.writePython3Bin "main" { libraries = [ msaf ]; } (builtins.readFile ./main.py);
        default = main;
      };

      apps = {
        default = {
          type = "app";
          program = "${self.packages.${system}.main}/bin/main";
        };
      };

      devShells = {
        default = pkgs.mkShell {
          buildInputs = [ self.packages.${system}.pythonEnvironment ];
        };
      };

      formatter = pkgs.nixpkgs-fmt;
    });
}

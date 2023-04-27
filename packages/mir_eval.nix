{ lib, buildPythonPackage, fetchPypi, fetchFromGitHub, python3Packages }:
buildPythonPackage {
  name = "mir_eval";

  src = fetchPypi {
    pname = "mir_eval";
    version = "0.7";
    hash = "sha256-4f66pXZsZadUXCoXCyQUkPR6mJhzcLHgZ0JCTF3r5l4=";
  };

  nativeBuildInputs = [
    python3Packages.future
    python3Packages.six
  ];

  propagatedBuildInputs = [
    python3Packages.numpy
    python3Packages.scipy
    python3Packages.matplotlib
  ];

  # TODO Fix tests.
  doCheck = false;

  meta = {
    description = "Common metrics for common audio/music processing tasks";
    homepage = "https://github.com/craffel/mir_eval";
    license = lib.licenses.mit;
    maintainers = [
      (import ./maintainer.nix)
    ];
  };
}

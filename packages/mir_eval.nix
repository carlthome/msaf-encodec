{ pkgs
, stdenv
, lib
, fetchPypi
, fetchFromGitHub
, python3Packages
}:
pkgs.python3Packages.buildPythonPackage {
  name = "mir_eval";
  format = "setuptools";

  src = fetchPypi {
    pname = "mir_eval";
    version = "0.7";
    hash = "sha256-4f66pXZsZadUXCoXCyQUkPR6mJhzcLHgZ0JCTF3r5l4=";
  };

  propagatedBuildInputs = with python3Packages; [
    future
    six
    numpy
    scipy
    matplotlib
  ];

  pythonImportsCheck = [
    "mir_eval"
  ];

  meta = {
    description = "Common metrics for common audio/music processing tasks";
    homepage = "https://github.com/craffel/mir_eval";
    license = lib.licenses.mit;
    maintainers = [
      (import ./maintainer.nix)
    ];
  };
}

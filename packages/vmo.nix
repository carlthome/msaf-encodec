{ lib, buildPythonPackage, fetchPypi, fetchFromGitHub, python3Packages }:
buildPythonPackage {
  name = "vmo";

  src = fetchPypi {
    pname = "vmo";
    version = "0.30.5";
    hash = "sha256-yXt+a7a3JM3aSy8usgCKzab4JK5lTQR1AiMEcFdjNdY=";
  };

  nativeBuildInputs = [
    python3Packages.setuptools_scm
  ];

  propagatedBuildInputs = [

  ];

  # TODO Fix tests.
  doCheck = false;

  meta = {
    description = "Python Modules of Variable Markov Oracle";
    homepage = "https://github.com/wangsix/vmo";
    license = lib.licenses.gpl3;
    maintainers = [
      (import ./maintainer.nix)
    ];
  };
}

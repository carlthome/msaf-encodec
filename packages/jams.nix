{ lib, buildPythonPackage, fetchPypi, fetchFromGitHub, python3Packages, mir_eval }:
buildPythonPackage {
  name = "jams";

  src = fetchPypi {
    pname = "jams";
    version = "0.3.4";
    hash = "sha256-i7IVi9GbTwV7i5AyG0Sx3RZZxmy+vg1CGYidMdf4iLk=";
  };

  nativeBuildInputs = [
    python3Packages.future
    python3Packages.six
  ];

  propagatedBuildInputs = [
    python3Packages.pandas
    python3Packages.jsonschema
    python3Packages.decorator
    python3Packages.sortedcontainers
    mir_eval
  ];

  # TODO Fix tests.
  doCheck = false;

  meta = {
    description = "A JSON Annotated Music Specification for Reproducible MIR Research";
    homepage = "https://github.com/marl/jams";
    license = lib.licenses.isc;
    maintainers = [
      (import ./maintainer.nix)
    ];
  };
}

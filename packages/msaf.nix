{ lib, buildPythonPackage, fetchPypi, fetchFromGitHub, python3Packages, mir_eval, jams, ffmpeg, vmo, libsndfile }:
buildPythonPackage {
  name = "msaf";

  src = fetchFromGitHub {
    owner = "urinieto";
    repo = "msaf";
    rev = "1fb42a80c4b0cce981df470ff6360243c2a63cdf";
    sha256 = "sha256-JkSwcpVGkK0OzidvS8EucCrU8FwgABDb8cFwkLfGBC8=";
  };

  patches = [
    ./remove_enum34.patch
  ];

  nativeBuildInputs = [
    #setuptools_scm
  ];

  propagatedBuildInputs = with python3Packages; [
    cvxopt
    enum-compat
    enum34
    ffmpeg
    future
    jams
    librosa
    libsndfile
    mir_eval
    numpy
    scikit-learn
    seaborn
    types-enum34
    vmo
  ];

  checkInputs = [
    python3Packages.pytest
  ];

  # TODO Fix tests.
  doCheck = false;

  meta = {
    description = "Python package for discovering the structure of music files";
    homepage = "https://github.com/urinieto/msaf";
    license = lib.licenses.mit;
    maintainers = [
      (import ./maintainer.nix)
    ];
  };
}

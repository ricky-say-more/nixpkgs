{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, pytestCheckHook
, pytorch
, numpy
, scipy
, librosa
}:

buildPythonPackage rec {
  pname = "torch-stft";
  version = "0.1.4";

  disabled = isPy27;

  src = fetchPypi {
    pname = "torch_stft";
    inherit version;
    sha256 = "05vja7b9nqjdnvqsymc5y410gr70zhj5hlh3vrcfyzanv8010z8x";
  };

  propagatedBuildInputs = [
    pytorch
    numpy
    scipy
    librosa
  ];

  doCheck = false;

  meta = with lib; {
    description = "An STFT/iSTFT for PyTorch";
    homepage = "https://github.com/pseeth/torch-stft";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ricky_s ];
  };
}

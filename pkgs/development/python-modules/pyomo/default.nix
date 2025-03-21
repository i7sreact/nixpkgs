{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  parameterized,
  ply,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyomo";
  version = "6.8.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    repo = "pyomo";
    owner = "pyomo";
    tag = version;
    hash = "sha256-n/Nt9omZfYSK/dvfp82aGfWIAAxF2mXYCJ1QcR6j8Ic=";
  };

  build-system = [ setuptools ];

  dependencies = [ ply ];

  nativeCheckInputs = [
    parameterized
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyomo" ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  disabledTestPaths = [
    # Don't test the documentation and the examples
    "doc/"
    "examples/"
    # Tests don't work properly in the sandbox
    "pyomo/environ/tests/test_environ.py"
  ];

  disabledTests = [
    # Test requires lsb_release
    "test_get_os_version"
  ];

  meta = with lib; {
    description = "Python Optimization Modeling Objects";
    homepage = "http://www.pyomo.org/";
    changelog = "https://github.com/Pyomo/pyomo/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = [ ];
    mainProgram = "pyomo";
  };
}

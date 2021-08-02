{ stdenv, lib, bundlerApp }:
let
  name = "docsplit";
  version = "0.7.6";
in bundlerApp {
  pname = name;
  exes = [ "docsplit" ];
  gemdir = ./.;

  meta = with lib; {
    Description =
      "A command-line utility and Ruby library for splitting apart documents into their component parts";
    homepage = "https://github.com/documentcloud/docsplit";
    license = licenses.lgpl3Only;
    maintainers = [ ];
    platforms = platform.unix;
  };
}

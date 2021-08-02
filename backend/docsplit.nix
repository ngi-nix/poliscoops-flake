{ stdenv
, lib
, bundlerApp

, fetchFromGitHub
}:
with lib;
let
  name = "docsplit";
  version = "0.7.6";
in
bundlerApp {
  pname = name;

  gemdir = fetchFromGitHub {
    owner = "documentcloud";
    repo = name;
    rev = version;
    sha256 = "sha256-lR8A4wZaaVS3GpoSplWRjpxnK+jZeDWtoPBGVrUDZtk=";
  };

  exes = [ "docsplit" ];

  buildInputs =
    [ rake
    ];
}

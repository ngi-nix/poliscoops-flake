{ stdenv
, lib

, python3, poppler, poppler_utils
, fetchFromGitHub
}:
with lib;
let
  name = "poliscoops";
  version = "master";
in
stdenv.mkDerivation {
  inherit version;
  pname = name + "backend";

  src = fetchFromGitHub {
    owner = "openstate";
    repo = name;
    rev = "fc8d34f89e67b13f1f02ec6c030df0c9b6fca4c7";
    sha256 = "sha256-mK5IG214g+JM4VxzwlwZKc4r+29037DkcmYQJobInGk=";
  };

  nativeBuildInputs =
    [ python3.withPackages (pkgs: with pkgs;
      [ av setuptools software-properties ])
    ];
}

{ stdenv
, lib

, fetchFromGitHub
, sphinx
, python3
}:
with lib;
let
  name = "poliscoops";
  version = "master";
in
stdenv.mkDerivation {
  inherit version;
  pname = name + "-nginx";

  src = fetchFromGitHub {
    owner = "openstate";
    repo = name;
    rev = "fc8d34f89e67b13f1f02ec6c030df0c9b6fca4c7";
    sha256 = "sha256-mK5IG214g+JM4VxzwlwZKc4r+29037DkcmYQJobInGk=";
  };

  makeFlags = "html";

  preBuild = ''cd docs'';

  nativeBuildInputs =
    [ (python3.withPackages (pkgs: with pkgs;
      [ sphinx sphinx_rtd_theme sphinxcontrib_httpdomain ]))
    ];

  installPhase = ''
    mkdir -p $out
    cp -r _build/html/. $out
  '';
}

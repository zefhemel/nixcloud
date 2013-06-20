{ pkgs ? import <nixpkgs> {}
, stdenv ? pkgs.stdenv
, ... }:
let
  inherit (pkgs) pythonPackages;
in pythonPackages.buildPythonPackage rec {
  name = "nixcloud-${version}";
  version = "0.1";
  namePrefix = "";
  src = ./.;
  doCheck = false;
  propagatedBuildInputs =
    [ pythonPackages.psycopg2
      pythonPackages.pika ];
}

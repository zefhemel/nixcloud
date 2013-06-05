{ pkgs, stdenv, ... }:
stdenv.mkDerivation rec {
  name = "nixcloud-${version}";
  version = "0.1";
  src = ./nixcloud;
  buildInputs = [ pkgs.python ];
  installPhase = ''
    mkdir -p $out
    cp -r bin $out/bin
  '';
}

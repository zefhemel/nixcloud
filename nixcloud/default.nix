{ pkgs, stdenv, ... }:
stdenv.mkDerivation {
  src = ./nixcloud;
}

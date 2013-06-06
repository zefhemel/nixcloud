{ pkgs ? import <nixpkgs> {} }:
with pkgs;
stdenv.mkDerivation {
  name = "nixpkgs";
  src = pkgs.fetchgit {
    url = "https://github.com/NixOS/nixpkgs.git";
    rev = "bc409a6e00c5ac691d5e632402fd06bb70a8f24a";
    sha256 = "0l5znmq9m5hg2kc4prixg02z4f96b7fswdf746havsrc8jv78yrc";
  };
  dontBuild = true;
  dontStrip = true;
  dontPatchELF = true;
  dontPatchShebangs = true;
  installPhase = ''
    mkdir -p $out
    cp -r * $out/
  '';
}

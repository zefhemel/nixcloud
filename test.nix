{ pkgs ? import <nixpkgs> {} }:
let
  stdenv = pkgs.stdenv;
  mkRunner =
    { command }: 
    pkgs.writeText "runner.sh" ''
      echo "Running on port: $1"

      export PORT=$1
      echo "Going to run: ${command}"
      ${command}
    '';
in rec {
  runner = mkRunner {
    command = "${pkgs.nodejs}/bin/node ${app}/server.js";
  };
  app = stdenv.mkDerivation {
    name = "testapp";
    src = ./app;
    buildInputs = [ pkgs.nodejs ];
    PORT = "8080";
    installPhase = ''
      mkdir $out
      cp -r * $out/
    '';
  };
  resources.ports.web = {
    public = true;
  };
}

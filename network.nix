let
  pkgs = import <nixpkgs> {};
  nixcloud = import ./default.nix { 
    inherit pkgs;
    inherit (pkgs) stdenv;
  };
in {
  network.description = "NixCloud";
  builder = import ./builder.nix {
    inherit pkgs nixcloud;
  };
}

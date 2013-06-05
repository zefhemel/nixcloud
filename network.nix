{
  network.description = "NixCloud";
  builder = { pkgs, ...}:
    let
      nixcloud = import ./default.nix { 
        inherit pkgs;
        inherit (pkgs) stdenv;
      };
    in import ./builder.nix { inherit pkgs nixcloud; };
  host = { pkgs, ...}:
    let
      nixcloud = import ./default.nix { 
        inherit pkgs;
        inherit (pkgs) stdenv;
      };
    in import ./host.nix { inherit pkgs nixcloud; };
}

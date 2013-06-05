# nix-instantiate info.nix --eval-only --xml --strict --arg exprPath ./test.nix -A info
{ exprPath }:
let
  content = import exprPath {};
in {
  info = rec {
    runner = content.runner.outPath;
    ports = content.resources.ports;
  };
}

# nix-instantiate extract.nix --eval-only --xml --strict --arg exprPath ./test.nix -A info
# nix-build -A systemDService extract.nix --arg exprPath ./test/default.nix --argstr user zef --arg env '{PORT="8080";}'
{ exprPath
, user ? "root" 
, env ? {}
}:
let
  content = import exprPath {};
  pkgs = import <nixpkgs> {};
  inherit (pkgs.lib) concatMapStrings getAttr attrNames;
in {
  info = rec {
    runner = content.runner.outPath;
    ports = content.resources.ports;
  };
  systemDService = pkgs.writeText "systemd.service" ''
[Service]
Type=forking
ExecStart=${pkgs.bash}/bin/bash ${content.runner}
${concatMapStrings (n: "Environment=\"${n}=${getAttr n env}\"\n") (attrNames env)}
Restart=on-failure
User=${user}
MemoryLimit=256M
'';
}

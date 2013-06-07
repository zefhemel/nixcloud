{ pkgs, nixcloud, ... }:
let
  nixpkgsCollection = import ./nixpkgs.nix { inherit pkgs; };
  inherit (pkgs) stdenv;
  hipache = stdenv.mkDerivation {
    name = "hipache";
    src = pkgs.fetchurl {
      url = http://download.zef.s3.amazonaws.com/hipache.tar.gz;
      sha256 = "1gnsjlgi69w784j3h0qrp0jg14x9phvlk983j7w7z6i76hxxb4pw";
    };
    buildInputs = [ pkgs.nodejs ];
    installPhase = ''
      mkdir -p $out
      cp -r * $out/
    '';
  };
  hipachecfg = pkgs.writeText "hipache.json" ''
    {
      "server": {
          "accessLog": "/var/log/hipache_access.log",
          "port": 80,
          "workers": 5,
          "maxSockets": 100,
          "deadBackendTTL": 10
      },
      "redisHost": "127.0.0.1",
      "redisPort": 6379
    }
  '';
in {
  environment.systemPackages = [ pkgs.git pkgs.vim nixcloud ];

  services.rabbitmq.enable = true;
  services.redis.enable = true;

  networking.extraHosts = ''
  127.0.0.1 builder
  '';

  systemd.services."activate-worker" = {
    description = "activation worker";
    wantedBy = [ "multi-user.target" ];
    after = [ "rabbitmq.service" ];
    script = ''
    export PATH=$PATH:/run/current-system/sw/bin:/run/current-system/sw/sbin
    # RabbitMQ takes some time to startup and does not signal it properly
    # Therefore let's wait a few seconds during boot
    sleep 10
    ${nixcloud}/bin/nixcloud-activate-worker
    '';
    serviceConfig = {
      Type="simple";
      Restart="on-failure";
      RestartSec="10s";
    };
  };

  systemd.services.hipache = {
    description = "hipache";
    wantedBy = [ "multi-user.target" ];
    after = [ "redis.service" ];
    script = "${hipache}/bin/hipache --config ${hipachecfg}";
    serviceConfig = {
      Type="simple";
      Restart="on-failure";
      RestartSec="3s";
    };
  };

  systemd.services."setup-once" = {
    description = "One off system setup job";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    script = ''
      PATH=$PATH:/run/current-system/sw/bin:/run/current-system/sw/sbin
      mkdir -p /root/.ssh
      cp ${./keys/serverkey} /root/.ssh/id_rsa
      chmod 600 /root/.ssh/id_rsa
      echo "Host host*" > /root/.ssh/config
      echo "   StrictHostKeyChecking no" >> /root/.ssh/config

      rm -f /etc/nixos/nixpkgs
      ln -s ${nixpkgsCollection} /etc/nixos/nixpkgs
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}

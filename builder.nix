{ pkgs, nixcloud, ... }:
{
  environment.systemPackages = [ pkgs.git pkgs.vim nixcloud ];

  services.rabbitmq.enable = true;

  systemd.services."activate-worker" = {
    description = "activation worker";
    wantedBy = [ "multi-user.target" ];
    after = [ "rabbitmq.service" ];
    script = ''
    export PATH=$PATH:/run/current-system/sw/bin:/run/current-system/sw/sbin
    ${nixcloud}/bin/nixcloud-activate-worker
    '';
    serviceConfig = {
      Type="simple";
      Restart="on-failure";
    };
  };

  systemd.services."setup-once" = {
    description = "One off system setup job";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    script = ''
      PATH=$PATH:/run/current-system/sw/bin:/run/current-system/sw/sbin
      nixos-checkout || true
      mkdir -p /root/.ssh
      cp ${./keys/serverkey} /root/.ssh/id_rsa
      chmod 600 /root/.ssh/id_rsa
      echo "Host host*" > /root/.ssh/config
      echo "   StrictHostKeyChecking no" >> /root/.ssh/config
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}

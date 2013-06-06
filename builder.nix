{ pkgs, nixcloud, ... }:
{
  environment.systemPackages = [ pkgs.git nixcloud ];

  services.rabbitmq.enable = true;

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

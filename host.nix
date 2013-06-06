{ pkgs, nixcloud, ... }:
{
  environment.systemPackages = [ nixcloud pkgs.vim ];

  systemd.services."setup-once" = {
    description = "One off system setup job";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    script = ''
      mkdir -p /root/.ssh
      cp ${./keys/serverkey.pub} /root/.ssh/authorized_keys
      chmod 600 /root/.ssh/authorized_keys
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}

{ pkgs, nixcloud, ... }:
{
  environment.systemPackages = [ pkgs.git nixcloud ];

  systemd.services."package-checkout-init" = {
    description = "Nix repo checkout";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    script = ''
      PATH=$PATH:/run/current-system/sw/bin:/run/current-system/sw/sbin
      nixos-checkout || true
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}

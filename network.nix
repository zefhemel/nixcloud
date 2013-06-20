{
  network.description = "NixCloud";

  node = { pkgs, ... }:
    let
      nixpkgsCollection = import ./nixpkgs.nix { inherit pkgs; };
      nixcloud = import ./default.nix { 
        inherit pkgs;
        inherit (pkgs) stdenv;
      };
      inherit (pkgs) stdenv;
    in {
      environment.systemPackages = [ pkgs.git pkgs.vim nixcloud ];

      users.extraUsers.git = {
        createHome = true;
        group = "git";
        home = "/home/git";
        shell = "/run/current-system/sw/bin/bash";
      };

      users.extraGroups.git = {};

      security.sudo.configFile = ''
      git ALL= NOPASSWD: /run/current-system/sw/bin/systemctl, NOPASSWD: /run/current-system/sw/sbin/useradd
      '';

      systemd.services."setup-once" = {
        description = "One off system setup job";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        script = ''
          source /etc/profile
          GITHOME=/home/git
          GITUSER=git

          mkdir -p $GITHOME/.ssh
          touch $GITHOME/.ssh/authorized_keys
          cp ${./script/receive.sh} $GITHOME/receiver
          chmod +x $GITHOME/receiver
          chown -R $GITUSER $GITHOME

          chgrp git /run/systemd/system
          chmod g+w /run/systemd/system

          rm -f /etc/nixos/nixpkgs
          ln -s ${nixpkgsCollection} /etc/nixos/nixpkgs
        '';
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
      };
    };
}

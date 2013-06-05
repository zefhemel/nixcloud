{ pkgs, nixcloud, ... }:
{
  environment.systemPackages = [ pkgs.git nixcloud ];
}

{ config, lib, pkgs, ... }:

{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 22 ];
    allowedUDPPorts =[ 51820 ];
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips =[ "10.100.0.1/24" ];
      listenPort = 51820;

      privateKeyFile = "/var/lib/wireguard/private.key";

      peers =[
        {
          publicKey = lib.removeSuffix "\n" (builtins.readFile /var/lib/wireguard/client_public.key);
          allowedIPs =[ "10.100.0.2/32" ];
        }
      ];
    };
  };
}
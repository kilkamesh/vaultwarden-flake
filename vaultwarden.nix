{ config, pkgs, ... }:

let
  domain = "pass.your-domain.la"; 
in {
  services.vaultwarden = {
    enable = true;
    dbBackend = "sqlite";
    config = {
      DOMAIN = "https://${domain}";
      SIGNUPS_ALLOWED = false;
      ROCKET_PORT = 8222;
    };
  };

  services.caddy = {
    enable = true;
    virtualHosts."${domain}".extraConfig = "reverse_proxy localhost:8222";
  };
  
  networking.firewall.allowedTCPPorts =; 
}

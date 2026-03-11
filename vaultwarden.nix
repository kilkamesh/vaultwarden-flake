{ config, lib, pkgs, ... }:

let
  cfg = config.services.myVaultwarden;
in {
  options.services.myVaultwarden = {
    enable = lib.mkEnableOption "Vaultwarden service";
    domain = lib.mkOption { 
      type = lib.types.str; 
      default = "vault.example.com";
    };
  };

  config = lib.mkIf cfg.enable {
    services.vaultwarden = {
      enable = true;
      dbBackend = "sqlite";
      backupDir = "/var/lib/vaultwarden/backups";
      config = {
        DOMAIN = "https://${cfg.domain}";
        SIGNUPS_ALLOWED = false;
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;
      };
    };

    services.caddy = {
      enable = true;
      virtualHosts."${cfg.domain}".extraConfig = ''
        @blocked not remote_ip 10.100.0.0/24 127.0.0.1/8
        respond @blocked "Access Denied" 403

        reverse_proxy localhost:8222
      '';
    };
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 80 ];
    };
  };
}
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
    environment.systemPackages = with pkgs; [
      nss.tools
    ];

    security.pki.certificateFiles = [
      "/var/lib/caddy/.local/share/caddy/pki/authorities/local/root.crt"
    ];

    services.vaultwarden = {
      enable = true;
      dbBackend = "sqlite";
      backupDir = "/var/backup/vaultwarden"; 
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
        tls internal
        reverse_proxy localhost:8222
      '';
    };
  };
}

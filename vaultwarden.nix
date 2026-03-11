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
      globalConfig = ''
        params {
          pki {
            ca local {
              skip_install_trust
            }
          }
        }
      '';
      virtualHosts."${cfg.domain}".extraConfig = ''
        tls internal
        reverse_proxy localhost:8222
      '';
    };
  };
}
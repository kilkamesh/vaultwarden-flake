{ config, lib, pkgs, ... }:

let
  cfg = config.services.FwknopConfig;
in {
  options.services.FwknopConfig = {
    enable = lib.mkEnableOption "Custom Fwknop config";
    key = lib.mkOption { type = lib.types.str; };
    hmacKey = lib.mkOption { type = lib.types.str; };
    interface = lib.mkOption { type = lib.types.str; default = "ens3"; };
  };

  config = lib.mkIf cfg.enable {
    services.fwknop = {
      enable = true;
      settings.PCAP_INTF = cfg.interface;
      access."default" = {
        KEY_ASCII = cfg.key;
        HMAC_KEY_ASCII = cfg.hmacKey;
        SOURCE = "ANY";
        OPEN_PORTS = "tcp/22,tcp/443";
        FW_ACCESS_TIMEOUT = 30;
      };
    };

    networking.firewall = lib.mkForce {
      enable = true;
      allowedTCPPorts = [ 80 ];
      allowedUDPPorts = [ 62201 ];
    };
  };
}

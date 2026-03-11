{
  description = "NixOS Flake for Vaultwarden VPS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations.vps-hostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        "/etc/nixos/configuration.nix"
        ./hardware-configuration.nix
        ./nix-mineral.nix
        ./vaultwarden.nix
        ./fwknop.nix
      ];
    };
  };
}

{
  description = "NixOS Flake for Vaultwarden VPS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    wg.url = "github:kilkamesh/wireguard-flake";
  };

  outputs = { self, wg, ... }: {
    nixosModules = {
      wg = wg.nixosModules.default; 
      mineral = ./nix-mineral.nix;
      vaultwarden = ./vaultwarden.nix;
    };
  };
}

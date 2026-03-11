{
  description = "NixOS Flake for Vaultwarden VPS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
  };

  outputs = { self, ... }: {
    nixosModules = {
      vaultwarden = ./vaultwarden.nix;
      fwknop = ./fwknop.nix;
      mineral = ./nix-mineral.nix;
    };
  };
}

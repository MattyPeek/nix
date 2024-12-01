{ inputs, ... }@flakeContext:
let
  darwinModule = { config, lib, pkgs, ... }: {
    config = {
      documentation = {
        enable = false;
      };
    };
  };
in
inputs.nix-darwin.lib.darwinSystem {
  modules = [
    darwinModule
    ./packages.nix
    ./system.nix
  ];
  system = "aarch64-darwin";
}

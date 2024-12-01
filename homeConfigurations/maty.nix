{ inputs, ... }@flakeContext:
let
  homeModule = { config, lib, pkgs, ... }: {
    config = {
      home = {
        stateVersion = "24.11";
      };
      programs = {
        bash = {
          enable = true;
          enableCompletion = true;
        };
        neovim = {
          enable = true;
        };
        ranger = {
          enable = true;
        };
        ssh = {
          enable = true;
        };
        tmux = {
          enable = true;
        };
      };
    };
  };
  nixosModule = { ... }: {
    home-manager.users.maty = homeModule;
  };
in
(
  (
    inputs.home-manager.lib.homeManagerConfiguration {
      modules = [
        homeModule
      ];
      pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
    }
  ) // { inherit nixosModule; }
)

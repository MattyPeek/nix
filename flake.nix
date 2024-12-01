{
  description = "MattyPeek's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = { self, nix-darwin, nixpkgs, nix-homebrew, ... }@inputs:
  let
    commonConfig = { pkgs, config, ... }: {
      nix.settings = {
        experimental-features = [ "nix-command" "flakes" ];
        trusted-users = [ "root" "@wheel" ];
      };
    };
  in {
    darwinConfigurations = {
      darwinPackages = self.darwinConfigurations."mcbp".pkgs;
      "mcbp" = nix-darwin.lib.darwinSystem {
        modules = [ 
          commonConfig 
          ./system/mcbp
          ./packages/mcbp
          ./services/mcbp
          nix-homebrew.darwinModules.nix-homebrew {
            nix-homebrew = {
              enable = true;
              enableRosetta = true; # For apple silicon
              user = "maty";
              autoMigrate = true; # If homebrew was already installed
            };
          }
        ];
      };
      "mcbp2" = nix-darwin.lib.darwinSystem {
        modules = [ 
          commonConfig 
        ];
      };
    };
  };
}

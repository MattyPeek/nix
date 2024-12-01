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
      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;
    };
  in {
    darwinConfigurations = {
      darwinPackages = self.darwinConfigurations."mcbp".pkgs;
      "mcbp" = nix-darwin.lib.darwinSystem {
        modules = [ 
          commonConfig # Main flake defined config 
          nix-homebrew.darwinModules.nix-homebrew { # homebrew setup
            nix-homebrew = {
              enable = true;
              enableRosetta = true; # For apple silicon
              user = "maty";
              autoMigrate = true; # If homebrew was already installed
            };
          }
          # Included files:
          #./system/mcbp
          #./packages/mcbp
          #./services/mcbp
          ./modules/mcbp/packages.nix
          ./modules/mcbp/services.nix
          ./modules/mcbp/system.nix
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

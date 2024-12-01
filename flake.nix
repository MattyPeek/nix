{
  description = "mcbp flake";
  inputs = {
    nixpkgs.url = "flake:nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "flake:nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs:
    let
      flakeContext = {
        inherit inputs;
      };
    in
    {
      darwinConfigurations = {
        mcbp = import ./darwinConfigurations/mcbp.nix flakeContext;
        #mcbp2 = import ./darwinConfigurations/mcbp2.nix flakeContext;
      };
    };
}

{
  description = "mcbp flake";
  inputs = {
    nixpkgs.url = "flake:nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "flake:nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    #home-manager.url = "flake:home-manager";
    #home-manager.inputs.nixpkgs.follows = "nixpkgs";
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
      };
      #homeConfigurations = {
        #maty = import ./homeConfigurations/maty.nix flakeContext;
      #};
    };
}

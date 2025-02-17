{
    description = "MattyPeek's nix flake";
    inputs = {
        nixpkgs.url = "flake:nixpkgs/nixpkgs-unstable";
        nix-darwin.url = "flake:nix-darwin";
        nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    };
    outputs = {self, nixpkgs, nix-darwin, ... }@inputs:{
        darwinConfigurations = {
            mcbp = nix-darwin.lib.darwinSystem {
	            specialArgs = { inherit inputs; };
                modules = [
                    ./config/mcbp/packages.nix
                    ./config/mcbp/system.nix
                ];
            };
        };
        nixosConfigurations = {
            brokolice = nixpkgs.lib.nixosSystem {
	            specialArgs = { inherit inputs; };
                modules = [
	                /etc/nixos/hardware-configuration.nix
	                ./config/brokolice/packages.nix
	                ./config/brokolice/system.nix
	                ./config/brokolice/nginx.nix
	                ./config/brokolice/services.nix
                ];
            };
        };
    };
}

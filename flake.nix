# NIX_CONFIG="experimental-features = nix-command flakes" ; sudo -E nixos-install --flake ./#natalie --no-write-lock-file
# NIX_CONFIG="experimental-features = nix-command flakes" ; sudo -E nixos-install --flake github:mattypeek/nix#natalie --no-write-lock-file

{
    description = "MattyPeek's nix flake";
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/24.11";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
        nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-24.11";
        nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
        disko.url = "github:nix-community/disko";
        disko.inputs.nixpkgs.follows = "nixpkgs";
    };
    outputs = {self, nixpkgs, nix-darwin, disko, ... }@inputs:{
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
            natalie = nixpkgs.lib.nixosSystem {
	            specialArgs = { inherit inputs disko; };
                modules = [
                    inputs.disko.nixosModules.disko
	                ./config/natalie/disks.nix
	                ./config/natalie/system.nix
	                ./config/natalie/amdgpu.nix
	                ./config/natalie/packages.nix
	                ./config/natalie/network.nix
	                ./config/natalie/firewall.nix
	                ./config/natalie/wireguard.nix
	                ./config/natalie/desktop.nix
                ];
            };
        };
    };
}

# NIX_CONFIG="experimental-features = nix-command flakes" ; sudo -E nixos-install --flake ./#natalie --no-write-lock-file
# NIX_CONFIG="experimental-features = nix-command flakes" ; sudo -E nixos-install --flake github:mattypeek/nix#natalie --no-write-lock-file

{
    description = "MattyPeek's nix flake";
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/25.05";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
        
        nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
        nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
        
        disko.url = "github:nix-community/disko";
        disko.inputs.nixpkgs.follows = "nixpkgs";
        
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };
    outputs = {self, nixpkgs, nixpkgs-unstable, nix-darwin, disko, home-manager, ... }@inputs:{
        darwinConfigurations = {
            mcbp = nix-darwin.lib.darwinSystem {
	            specialArgs = { inherit inputs nixpkgs-unstable nixpkgs; };
                modules = [
                    ./config/mcbp/packages.nix
                    ./config/mcbp/system.nix
                    ./config/mcbp/aerospace.nix
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
	                ./config/brokolice/zrepl.nix
	                ./config/brokolice/cron.nix
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
	                ./config/natalie/zrepl.nix
	                #./config/natalie/games.nix
                ];
            };
            hlinik = nixpkgs.lib.nixosSystem {
	            specialArgs = { inherit inputs disko; };
                modules = [
                    inputs.disko.nixosModules.disko
	                ./config/hlinik/disks.nix
	                ./config/hlinik/system.nix
	                #./config/hlinik/amdgpu.nix
	                ./config/hlinik/nvidia.nix
	                ./config/hlinik/packages.nix
	                ./config/hlinik/network.nix
	                ./config/hlinik/firewall.nix
	                #./config/hlinik/wireguard.nix
	                ./config/hlinik/desktop.nix
	                #./config/hlinik/zrepl.nix
                ];
            };
        };
        homeConfigurations = {
            "darwin.maty" = home-manager.lib.homeManagerConfiguration {
                pkgs = import nixpkgs { system = "aarch64-darwin"; };
                modules = [
                    ./home/darwin/maty.nix
                ];
            };
        };
    };
}

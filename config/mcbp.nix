{ inputs, ... }@flakeContext:
inputs.nix-darwin.lib.darwinSystem {
  modules = [
    ./mcbp/packages.nix
    ./mcbp/system.nix
  ];
  system = "aarch64-darwin";
}

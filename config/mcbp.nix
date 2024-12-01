{ inputs, ... }@flakeContext:
inputs.nix-darwin.lib.darwinSystem {
  modules = [
    ./packages.nix
    ./system.nix
  ];
  system = "aarch64-darwin";
}

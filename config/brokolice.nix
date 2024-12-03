{ inputs, ... }@flakeContext:
inputs.nix-darwin.lib.darwinSystem {
  modules = [
    ./brokolice/hardware.nix
    ./brokolice/system.nix
    ./brokolice/packages.nix
  ];
  system = "x86_64-linux";
}

{config, lib, pkgs, ...}: {

    hardware.graphics.extraPackages = with pkgs; [
        rocmPackages.clr.icd
    ];
    
    environment.systemPackages = with pkgs; [
        clinfo
    ];
    
    hardware.graphics.enable32Bit = true;


}

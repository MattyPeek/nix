{ config, lib, pkgs, ... }: {
  config = {
   fonts = {
     packages = [
       pkgs.nerd-fonts.hack
     ];
   };
   homebrew = {
     brews = [
       "mas"
       "ansible"
       "asciiquarium"
       "bash"
       "bat"
       "cmatrix"
       "dialog"
       "docker"
       "ffmpeg"
       "freerdp"
       "gnupg"
       "handbrake"
       "jq"
       "midnight-commander"
       "ncdu"
       "ncurses"
       "neofetch"
       "openssh"
       "openvpn"
       "pinentry"
       "pinentry-mac"
       "python"
       "pkgconf"
       #"skhd" tap needed
       "socat"
       "sqlite"
       "telnet"
       "wget"
     ];
     casks = [
       "hammerspoon"
       "firefox"
       "iina"
       "the-unarchiver"
       "imageoptim"
       "gimp"
       "disk-inventory-x"
       "blender"
       "handbrake"
       "obs"
       "inkscape"
       "iterm2"
       "openzfs"
       "unetbootin"
       "alt-tab"
       "raycast"
     ];
     enable = true;
     masApps = {
       Keka = 470158793;
     };
     onActivation = {
       autoUpdate = true;
       cleanup = "zap";
       upgrade = true;
     };
   };
   nixpkgs = {
     config = {
       allowUnfree = true;
     };
     hostPlatform = "aarch64-darwin";
   };
 };
}

{ config, lib, pkgs, ... }: {
    config = {
        fonts = {
            packages = [
                pkgs.nerd-fonts.hack
            ];
        };
        
        environment.systemPackages = with pkgs; [
            wimlib
            zulu17
            procps
            bash-completion
            nix-bash-completions
            neovim
            pinentry_mac
            pinentry-curses
            vesktop
            cmatrix
            baobab
            dialog
            socat
            ansible
            asciiquarium
            bat
            util-linux
            inetutils
            socat
            docker
            ffmpeg
            #handbrake # broken
            jq
            #mas # installed as HB dependency
            freerdp
            mc
            ncdu
            pwgen
            ncurses
            neofetch
            wimlib
            python3Full
            pkgconf
            sqlite
            wget
            openssh
            gnupg
            openvpn
            skhd
            iina
            #blender # broken
            gimp
            inkscape
            iterm2
            #disk-inventory-x # x86_64
            raycast
            alt-tab-macos
            #firefox
     ];
   homebrew = {
     casks = [
       "hammerspoon"
       "blender"
       "firefox"
       "imageoptim"
       #"obs"
       #"gimp"
       #"openzfs"
       "onyx"
       "handbrake"
       #"unetbootin"
     ];
     enable = true;
     masApps = {
       Keka             = 470158793;
       GrandPerspective = 1111570163;
     };
     onActivation = {
       autoUpdate = true;
       #cleanup = "zap";
       cleanup = "uninstall";
       upgrade = true;
     };
     #brewPrefix = "/usr/local/bin/";
     brewPrefix = "/opt/homebrew/bin/";
   };
   nixpkgs = {
     config = {
       allowUnfree = true;
       allowBroken = true; # Allow packages marked as broken
     };
     hostPlatform = "aarch64-darwin";
   };
   # Fix app aliases
   system.activationScripts.applications.text = let
     env = pkgs.buildEnv {
       name = "system-applications";
       paths = config.environment.systemPackages;
       pathsToLink = "/Applications";
     };
   in
     pkgs.lib.mkForce ''
       # Set up applications.
       echo "setting up /Applications..." >&2
       rm -rf /Applications/Nix\ Apps
       mkdir -p /Applications/Nix\ Apps
       find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
         while read -r src; do
           app_name=$(basename "$src")
           echo "copying $src" >&2
           ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
         done
     '';
 };
}

{ config, lib, pkgs, nixpkgs-unstable, ... }: 
let
    unstable = import nixpkgs-unstable { system = "x86_64-darwin"; config = { allowUnfree = true; }; };
in {
    config = {
        fonts = {
            packages = with pkgs; [
                nerd-fonts.hack
                #(nerdfonts.override { fonts = [ "Hack" ]; })
            ];
        };
        
        environment.systemPackages = with pkgs; [
            wimlib
            yazi
            awscli
            nmap
            go  
            #nodejs_23
            #nodePackages.typescript
            invidious
            lynx
            w3m
            #surf
            #qutebrowser
            #browsh
            #librewolf-unwrapped
            mutt
            neomutt
            tmux
            #cope
            zulu17
            procps
            bash-completion
            nix-bash-completions
            neovim
            htop
            iperf
            catdoc
            antiword
            aldente
            pinentry_mac
            pinentry-curses
            gtop
            btop
            vesktop
            iproute2mac
            cmatrix
            baobab
            dialog
            socat
            ansible
            jmeter
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
            pkgconf
            sqlite
            wget
            openssh
            gnupg
            openvpn
            skhd
            jankyborders
            mousecape
            #sketchybar
            iina
            #blender # broken
            #unstable.gimp
            #gimp3
            gimp
            inkscape
            iterm2
            #disk-inventory-x # x86_64
            #raycast
            unstable.raycast
            alt-tab-macos
            #vitetris
            raylib-games
            #rpi-imager
            #firefox
            pipx
            python312Full
            python310Full
            python310Packages.python
            python312Packages.python
            python312Packages.passlib
            python312Packages.jmespath
            #matterhorn
        ];
        homebrew = {
            taps = [
                "browsh-org/homebrew-browsh"
            ];
            casks = [
                "hammerspoon"
                "blender"
                "firefox"
                #"librewolf"
                "imageoptim"
                #"obs"
                #"gimp"
                "openzfs"
                #"onyx"
                "handbrake-app"
                #"unetbootin"
                "obsidian"
                "keyboardcleantool"
                "stremio"
                "qutebrowser"
                "sequel-ace"
                "mysql-shell"
                #"mysql-client"
                "android-commandlinetools"
            ];
            brews = [
                "browsh"
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
            user = "maty";
            userApps = "/Users/${user}/Applications";
            nixApps = "${userApps}/NixApps";
            env = pkgs.buildEnv {
                name = "system-applications";
                paths = config.environment.systemPackages;
                pathsToLink = "/Applications";
            };
        in pkgs.lib.mkForce ''
            echo "setting up ${nixApps}..." >&2
            rm -rf ${nixApps}
            mkdir -p ${nixApps}
            
            find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
            while read -r src; do
                app_name=$(basename "$src")
                echo "Creating alias for $app_name" >&2
                ${pkgs.mkalias}/bin/mkalias "$src" "${nixApps}/$app_name"
            done
        '';
    };
}

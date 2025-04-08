{ config, lib, pkgs, ... }: {
    config = {
        fonts = {
            packages = with pkgs; [
                #nerd-fonts.hack
                (nerdfonts.override { fonts = [ "Hack" ]; })
            ];
        };
        
        environment.systemPackages = with pkgs; [
            wimlib
            #cope
            zulu17
            procps
            bash-completion
            nix-bash-completions
            neovim
            htop
            iperf
            pinentry_mac
            pinentry-curses
            gtop
            btop
            vesktop
            darwin.iproute2mac
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
            #vitetris
            raylib-games
            #firefox
            pipx
            python312Packages.python
            python312Packages.passlib
            python312Packages.jmespath
        ];
        homebrew = {
            casks = [
                "hammerspoon"
                "blender"
                "firefox"
                "imageoptim"
                #"obs"
                #"gimp"
                "openzfs"
                "onyx"
                "handbrake"
                #"unetbootin"
                "obsidian"
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
        system.activationScripts.applications.text = lib.mkForce ''
            echo "setting up ~/Applications..." >&2
            applications="$HOME/Applications"
            nix_apps="$applications/Nix Apps"

            # Needs to be writable by the user so that home-manager can symlink into it
            if ! test -d "$applications"; then
                mkdir -p "$applications"
                chown maty: "$applications"
                chmod u+w "$applications"
            fi

            # Delete the directory to remove old links
            rm -rf "$nix_apps"
            mkdir -p "$nix_apps"
            find ${config.system.build.applications}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
            while read -r src; do
                # Spotlight does not recognize symlinks, it will ignore directory we link to the applications folder.
                # It does understand MacOS aliases though, a unique filesystem feature. Sadly they cannot be created
                # from bash (as far as I know), so we use the oh-so-great Apple Script instead.
                /usr/bin/osascript -e "
                    set fileToAlias to POSIX file \"$src\"
                    set applicationsFolder to POSIX file \"$nix_apps\"
                    tell application \"Finder\"
                    make alias file to fileToAlias at applicationsFolder
                    # This renames the alias; 'mpv.app alias' -> 'mpv.app'
                    set name of result to \"$(rev <<< "$src" | cut -d'/' -f1 | rev)\"
                    end tell
                " 1>/dev/null
             done
        '';
    };
}

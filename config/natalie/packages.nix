{ config, lib, pkgs, ... }: {
  
    config = {
        fonts = {
            packages = [
                pkgs.nerd-fonts-hack
            ];
        };
        environment.systemPackages = with pkgs; [
            nix
            curl
            bash-completion
            nix-bash-completions
            neovim
            pinentry-curses
            cmatrix
            dialog
            socat
            wireguard-tools
            ansible
            asciiquarium
            bat
            jdk17
            inetutils
            socat
            unzip
            docker
            ffmpeg
            jq
            freerdp
            mc
            ncdu
            ncurses
            neofetch
            python3Full
            pkgconf
            sqlite
            wget
            openssh
            gnupg
            openvpn
            nginx
            vim
            ipfetch
            bind
            traceroute
        ];
        nixpkgs = {
            config = {
                allowUnfree = true;
                #allowBroken = true; # Allow packages marked as broken
            };
            hostPlatform = "x86_64-linux";
        };
    };
}

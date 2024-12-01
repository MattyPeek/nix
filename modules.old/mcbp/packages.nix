{ config, pkgs, inputs, ... }: {

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages =
    [
      pkgs.vim
      pkgs.tmux
      pkgs.alacritty
      pkgs.mkalias
    ];

  fonts.packages =
    [
      #(pkgs.nerdfonts.override { fonts = [ "Hack" ]; })
      pkgs.nerd-fonts.hack
    ];

  homebrew = {
    enable = true;
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
    masApps = {
      "Keka" = 470158793;
    };
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };
}

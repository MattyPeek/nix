{ inputs, ... }@flakeContext:
let
  darwinModule = { config, lib, pkgs, ... }: {
    imports = [
      inputs.home-manager.darwinModules.home-manager
      inputs.self.homeConfigurations.maty.nixosModule
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
    config = {
      documentation = {
        enable = false;
      };
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
      security = {
        pam = {
          enableSudoTouchIdAuth = true;
        };
      };
      services = {
        nix-daemon = {
          enable = true;
        };
        sketchybar = {
          enable = false;
        };
      };
      system = {
        defaults = {
          dock = {
            autohide = true;
            mru-spaces = false;
          };
          finder = {
            FXPreferredViewStyle = "Nlsv";
            ShowPathbar = true;
            ShowStatusBar = true;
          };
          loginwindow = {
            LoginwindowText = "brm brm";
          };
        };
        stateVersion = 5;
      };
      users = {
        users = {
          maty = {
            home = "/Users/maty";
          };
        };
      };
    };
  };
in
inputs.nix-darwin.lib.darwinSystem {
  modules = [
    darwinModule
  ];
  system = "aarch64-darwin";
}

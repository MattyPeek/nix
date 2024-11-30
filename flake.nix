{
  description = "MattyPeek's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, config, ... }: {
      
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      
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


      system.defaults = {
        "com.apple.finder.FXPreferredViewStyle" = "Nlsv";
        "com.apple.finder.ShowToolbar" = true;
        "com.apple.finder.ShowStatusBar" = true;
        "com.apple.finder.ShowPathbar" = true;
        dock.autohide = true;
        dock.mru-spaces = false;
        loginwindow.LoginwindowText = "brm brm";
      }

      security.pam.enableSudoTouchIdAuth = true;

      services.nix-daemon.enable = true;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;
      programs.bash.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."mcbp" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration 
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true; # For apple silicon
            user = "maty";
            autoMigrate = true; # If homebrew was already installed
          };
        }
      ];
    };

    darwinPackages = self.darwinConfigurations."mcbp".pkgs;
  };
}

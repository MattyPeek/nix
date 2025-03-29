{ config, lib, pkgs, ... }: {

	services.xserver.enable = true;
	services.displayManager.sddm.enable = true;
	services.desktopManager.plasma6.enable = true;
	
	services.displayManager.defaultSession = "plasma"; # wayland plasma
	services.displayManager.sddm.wayland.enable = true; # wayland sddm

	environment.plasma6.excludePackages = with pkgs.kdePackages; [
  		plasma-browser-integration
  		oxygen
	];

	qt = {
  		enable = true;
  		platformTheme = "gnome";
  		style = "adwaita-dark";
	};


}

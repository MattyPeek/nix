{ config, lib, pkgs, ... }: {

	services.xserver.enable = true;
	services.xserver.videoDrivers = [ "amdgpu" ];
	services.displayManager.sddm.enable = true;
	services.displayManager.sddm.wayland.enable = true; # wayland sddm
	services.desktopManager.plasma6.enable = true;
	#services.xserver.desktopManager.plasma5.enable = true;

    # Disable display manager systemd unit.
    services.displayManager.enable = false;
	
	services.displayManager.defaultSession = "plasma"; # wayland plasma

    services.displayManager.sddm.settings.General.DisplayServer = "wayland";

	#environment.plasma6.excludePackages = with pkgs.kdePackages; [
  	#	plasma-browser-integration
  	#	oxygen
	#];

	#qt = {
  	#	enable = true;
  	#	platformTheme = "gnome";
  	#	style = "adwaita-dark";
	#};


}

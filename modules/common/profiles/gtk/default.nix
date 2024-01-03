{ config, lib, type, ... }:
let
  cfg = config.my.profiles.gtk;
in
{
  options.my.profiles.gtk = with lib; {
    enable = mkEnableOption "gtk profile";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (lib.optionalAttrs (type == "home") {
      # GTK theme configuration
      my.home.gtk.enable = true;
    })

    (lib.optionalAttrs (type == "nixos") {
      # Allow setting GTK configuration using home-manager
      programs.dconf.enable = true;
    })
  ]);
}

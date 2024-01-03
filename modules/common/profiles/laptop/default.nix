{ config, lib, type, ... }:
let
  cfg = config.my.profiles.laptop;
in
{
  options.my.profiles.laptop = with lib; {
    enable = mkEnableOption "laptop profile";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (lib.optionalAttrs (type == "home") {
      # Enable battery notifications
      my.home.power-alert.enable = true;
    })

    (lib.optionalAttrs (type == "nixos") {
      # Enable touchpad support
      services.xserver.libinput.enable = true;

      # Enable TLP power management
      my.services.tlp.enable = true;

      # Enable upower power management
      my.hardware.upower.enable = true;
    })
  ]);
}

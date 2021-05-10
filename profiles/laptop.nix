{ config, lib, ... }:
let
  cfg = config.my.profiles.laptop;
in
{
  options.my.profiles.laptop = with lib; {
    enable = mkEnableOption "laptop profile";
  };

  config = lib.mkIf cfg.enable {
    # Enable touchpad support
    services.xserver.libinput.enable = true;

    # Enable upower power management
    my.modules.upower.enable = true;

    # Enable battery notifications
    my.home.power-alert.enable = true;
  };
}

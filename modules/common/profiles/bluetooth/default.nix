{ config, lib, type, ... }:
let
  cfg = config.my.profiles.bluetooth;
in
{
  options.my.profiles.bluetooth = with lib; {
    enable = mkEnableOption "bluetooth profile";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (lib.optionalAttrs (type == "home") {
      my.home.bluetooth.enable = true;
    })

    (lib.optionalAttrs (type == "nixos") {
      my.hardware.bluetooth.enable = true;
    })
  ]);
}

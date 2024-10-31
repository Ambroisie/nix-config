{ config, inputs, lib, ... }:
let
  cfg = config.my.home.nixgl;
in
{
  options.my.home.nixgl = with lib; {
    enable = mkEnableOption "nixGL configuration";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      nixGL = {
        inherit (inputs.nixgl) packages;
      };
    }
  ]);
}

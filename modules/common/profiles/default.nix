# Configuration that spans accross system and home, or are almagations of modules
{ config, lib, type, ... }:
{
  imports = [
    ./bluetooth
    ./devices
    ./gtk
    ./laptop
    ./wm
    ./x
  ];

  config = lib.mkMerge [
    # Transparently enable home-manager profiles as well
    (lib.optionalAttrs (type == "nixos") {
      home-manager.users.${config.my.user.name} = {
        config = {
          my = {
            inherit (config.my) profiles;
          };
        };
      };
    })
  ];
}

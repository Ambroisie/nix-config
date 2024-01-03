# Configuration that spans accross system and home, or are almagations of modules
{ ... }:
{
  imports = [
    ./devices
    ./gtk
    ./laptop
    ./wm
    ./x
  ];
}

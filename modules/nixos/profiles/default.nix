# Configuration that spans accross system and home, or are almagations of modules
{ ... }:
{
  imports = [
    ./gtk
    ./laptop
    ./wm
    ./x
  ];
}

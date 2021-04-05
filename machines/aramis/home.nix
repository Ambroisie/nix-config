{ ... }:
{
  my.home = {
    # Firefo profile and extensions
    firefox.enable = true;
    # Termite terminal
    terminal.program = "termite";
    # i3 settings
    wm.windowManager = "i3";
    # Keyboard settings
    x.enable = true;
    # Zathura document viewer
    zathura.enable = true;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Enable i3
  services.xserver.windowManager.i3.enable = true;
}

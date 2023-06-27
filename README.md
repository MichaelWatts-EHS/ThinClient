# ThinClient
Preseed a linux install for use as a Thin Client

B.4.0. Command line switches

Normally the installer asks for the localization info immediately (before preseeding).  
Passing the "auto=true" switch tells it to wait until after the preseed file has been read.

  auto=true

The installer uses the fancy graphical interface by default.
This switch tells it to use the old (more-compatible) interface.

  vga=788

All questions & popups are asked by default.
This switch tells it to suppress (and try to intuit) anything that isn't critical.

  priority=critical

Lastly, the preseed file itself

  url=https://server/preseed.cfg
  
  file=/cdrom/preseed.cfg

The resulting command line perameters make for a truely silent install.
Assuming of course all the questions are answered in the preseed.cfg.

  auto=true vga=788 priority=critical url=https://server/preseed.cfg

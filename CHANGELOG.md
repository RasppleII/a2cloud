# Changelog

Notable changes to a2cloud will be documented here.  This document is for
users, rather than developers.  If you want an immutable history of all
changes made, you can follow git history so far as it goes and we'll try
to preserve more detail from the time before as we may.  We will try to
update older entries to reflect changes that have been reverted, please
file an issue if you notice something the changelog says should work, and
it no longer does.

## [Unreleased]

### Added

- Installation run from source tree (or git repo) no longer downloads any
  part of the installation from the internet since you've already got it.

- Created new scripts for a2cloud-setup and a2cloud-update to use that
  actually download the source tree and install from that.  This avoids
  some potential bugs and better security and integrity checks later.

- New scripts in scripts/ you can run separately from the full installer,
  install_archive_tools, install_comm_tools, and install_emulators. There
  are others too, but these are the ones you might want to be able to run
  yourself.

- lftp, an advanced ftp client with lots of power, tab-completion, etc.
  Much more user-friendly than the basic ftp client while maintaining the
  command line interface.  Supports mirroring, if you want that.

- mc (Midnight Commander), a Norton Commander style file manager.  It too
  has its own FTP interface capability and might be considered a possible
  alternative to cftp, assuming you become comfortable with using mc for
  file management tasks.

### Fixed

- Actually install unzip as prerequisite for undoit.

- Correct typo in a2chat

- No longer disables ::1 for exim.  Having that used to cause an error, so
  we'd modified your configuration to remove the use of IPv6.  We don't
  undo that if it was done in the past, but a new install won't do it.

### Changed

- Unexpectedly large version bump.  Because the last released version was
  1.9.x, we haven't really got version-space for pre-releases, so we've
  bumped the pre-release tree to version 2.9.0 to give us plenty of room
  for pre-releases before a major version bump.

- Oysttyer version we install is now 2.9.1.

- Modified the format of the this changelog ultimately to be hopefully
  more user-friendly.

- Ivan Drucker has agreed to allow his scripts and future work to be
  released under the CC0 Public Domain release.  Previously his scripts were
  under the "WTFPL".  Creative Commons is less "expressive", but more legally
  correct in countries without explicit support for public domain or a sense
  of humor.  ;)

- On desktop Debian systems, we now use default-jre instead of Oracle.
  For now we're still using Oracle on RPi, but that may soon change.

### Removed

- cftp has been removed.  It was always highly-buggy alpha software and
  it didn't do much.  If you want that kind of interface with some more
  maturity, connect to your ftp server with lynx.  Or see above.

- The ttytter command is gone.  TTYtter is abandoned upstream, but the
  developer's allowed others to take up development under a new name.
  Oysttyer may already be installed on your system and we've already been
  using it, just continuing to call it tttytter.

- The A2CLOUD_SCRIPT_URL and A2CLOUD_BINARY_URL environment variables,
  which probably nobody else was using since they were kind of only for
  a2cloud developers anyway, are gone.  Just run scripts from the source
  tree you're working on now.

- The raspbian-update script is gone.  Also gone are the aliases for
  raspi-config, appleiipi-update, and rasppleii-update.  (FIXME: a2server
  has debupdate as a replacement.  Do we want it in a2cloud?)

## [1.9.0] - 2016-07-23

  * [40b55a5] fix motd, and icon creation error messages in setup
  * [83a40d7] make "baud" command compatible with systemd

## [1.8.3] - 2016-01-19

### Added
  * First release from GitHub version

### Changes by Ivan Drucker
  * fix bug where language isn't properly selected for A2 login
  * download from Apple first, then Internet Archive as fallback

### Changes by Joseph Carter
  * Archived Ivan Drucker's A2CLOUD site in source tree
  * As this package will be native package, convert its changelog to Debian
    style.  Developers may want to install the devscripts package and have a
    look at the manpage for dch(1).  Mac developers, if you use TextExpander,
    I can share a snippet for RFC-2822 compliant dates.
  * Make adtpro.sh delay only happen when running interactively.
  * Begin using $PATH to find things so we can replace local binaries with
    packages later on.
  * Use unar package if it's available.
  * Use download.apple.com for Apple // files when possible, with archive.org
    as a fallback.
  * setup.txt is now 7-bit clean (the only reason it wasn't is the extended
    changelog at the bottom)

### Changes from 1.8.2
  * download from Internet Archive

## [1.8.1] - 2015-05-05

  * ADTPro 2.0.1
  * Apple II Pi client 1.5
  * set JAVA_HOME correctly for Java 8 (Pi, webupd8, Ubuntu for Pi 2B)

## [1.8.0] - 2015-03-17

  * compatible with every Raspberry Pi, including Raspberry Pi 2 Model B
  * GSport installed for non-Raspberry Pi computers, with option for
    new GS/OS+Spectrum installation, or GSport Internet Starter Kit premade
    image
  * add Links web browser
  * desktop shortcuts and Apple II menu group for emulators and ADTPro
  * adds LXTerminal to desktop for non-A2Pi version
  * new "a2cloud-update os" command will perform full Raspple II update,
    including Raspbian OS and NOOBS install manager, A2CLOUD, A2SERVER, and
    Apple II Pi
  * ProDOS instruction screen on GSOS install
  * provide via downloaded program that is dd notrunc'd over PRODOS (instead
    of writeCharsHex)
  * figure out why lines in autostart are supposed to start with @ (daemon;
    restarts command on crash)
  * install AppleCommander-1.3.5.13id (so Spectrum installer will work)
  * fix mouse in VirtualBox framebuffer, requires uninstalling (or temporarily
    disabling, if possible) VirtualBox guest additions
  * offer to uninstall vboxguestmodule if gsport is in run console
  * rename slot6drive1 and 2 to not contain "-blank" in slot6.tgz and gsport
    and kegs (x86) archives
  * fix webupd8team getting added twice to sources.list
  * command "a2cloud-update rasppleii" to update raspple ii
  * prevent samba update causing dialog to come up
  * create rasppleii-update
  * make rasppleii-update universal even for non-Raspple II installs -- it's
    just raspbian-update + a2cloud-update + a2server-update
  * download gsport and kegs icons
  * no longer opens terminal window (since icons exist)
  * create aliases for raspbian-update and rasppleii-update
  * update A2CLOUD help file and aliases for GSport
  * create raspbian-update
  * update a2cloud-help
  * update motd (vm, raspple ii/a2cloud-pi) for gsport
  * see if shortcuts work in Raspple II 110
  * check for /etc/xdg/lxsession/LXDE-pi; if so:
    * create ~/.config/menus/lxde-pi-applications.menu, with reference to
      /etc/xdg/menus/lxde-pi-applications.menu
    * no xrandr VBOX0 on the Pi; remove it if present (a2cloud 1.7.x may have
      put it there)
  * user groups for pi user not only apple2
  * gsport-setup and kegs post install text to say ctrl-F12 for reboot
  * add "links" to motd and help
  * added 'disablesafemode' to NOOBS recovery.cmdline (also in
    raspbian-update) to make it work on (at least) my A+
  * option for GISK rather than clean setup for GSport on x86
  * provide actual command for clean GSOS + Spectrum install, which is what
    gsport runs if no HD available
  * provide command for clean GSOS install for KEGS
  * add Dave's preflight/postflight stuff (groups, ownership permissions) for
    gsport
  * install libpcap0.8-dev as part of Apple II Pi, GSport install, and GSport
    launcher
  * make kegs-setup
  * make kegs splash text
  * doesn't add VirtualBox 800x600 if installing on Pi
  * stop xrandr from being added multiple times to autostart in VirtualBox
  * only install vbox 800x600 if running in VirtualBox
  * disable screen blanking in vbox console
  * disable screensaver/blanking in vbox LXDE
  * don't create LXTerminal desktop shortcut if RPi
  * -6 arg provides empty ProDOS disks in S6D1 and S6D2 to GSport/KEGS to
    speed things up
  * can test if password is "raspberry" or "apple2" and advise accordingly
  * enable Uthernet by default in gsport-setup
  * enable AppleTalk Turbo by default in gsport-setup
  * make kegs run as root
  * consolidate gsport-setup and kegs-setup
    * gsport-setup is gsport, gsport-setup -k is kegs
    * clean up KEGS/GSport installer sections to be consistent
    * create kegs-setup placeholders that call gsport-setup -k
  * gsport-setup only offer system disks/GSport if java/acmd are available
  * suppress policykit error that appears after upgrade (see
    http://www.raspberrypi.org/forums/viewtopic.php?t=98617 for details)
  * see if uninstalling vbox additions is really necessary (nope)

## [1.7.2] - 2015-02-07

  * supports Raspberry Pi Model A and A+ (and Pi 2 Model B)
  * manually triggers udev rules during startup if ttyusbhandler script didn't
    execute (resolves issues with Raspbian 2015-01-31/kernel 3.18)
  * doesn't provide Java space warning if java is already installed

## [1.7.1] - 2014-08-11

  * A2CLOUD is no longer “beta” on non-Raspberry Pi computers
  * A2CLOUD includes KEGS and Linapple on debian_x86
  * kegs launch script creates additional symlink called ROM
  * linapple launch script sets up framebuffer and udev mouse rule
  * A2CLOUD has a faster install script for non-Raspberry Pi computers
    (downloads debian7_x86 and rpi binaries)
  * unbit/unexec/bsq archive tools are installed
  * perl version for ttytter not hardcoded
  * apt-get clean after all installs
  * installer option to compile all rather than download binaries
  * login message mentions A2SERVER if it is installed
  * LXDE terminal window now in global autostart (opens for any user)
  * LXDE desktop defaults to 800x600 if running in VirtualBox VM

## [1.7.0] - 2014-08-02

  * a2cloud-setup installs Java 8 if not already installed

## [1.6.9] - 2014-07-24

  * ADTPro 2.0.0 (quicker and more reliable transfer; selectable filenames from
    list)
  * new A2CLOUD disks with A2PI client 1.8
  * tested working on Raspberry Pi Model B+ (use USB ports closest to Ethernet
    jack for ttyUSBlower and ttyUSBupper)

## [1.6.8] - 2014-04-07

  * ADTPro 1.3.0
  * tests for adtpro existence with either adtpro.sh or ADTPro.html
  * TTYtter installs properly on non-Pi systems

## [1.6.7] - 2014-02-19

  * cppo installed from a2cloud directory on web server (a2server has symlink)
  * fixed cppo -e bug that always created a resource fork file even if there
    is no resource fork
  * shk2image leaves nothing behind in /tmp
  * wildcard copy all files on A2PI disk except PRODOS/BASIC.SYSTEM/*A3* to
    A2CLOUD disks when building
  * A2CLOUD boot floppy contains A2PI client version 1.4
  * update before install for a2chat, a2news, kegs, kegs-setup, linapple,
    gsport, gsport-setup
  * a2cloud-setup updates a2news/a2chat/kegs/kegs-setup/linapple wrappers
  * disables IPv6 for exim4 to properly prevent startup error messages;
    restores log folder if not there
  * A2CLOUD boot floppy splash screen provides simple menu for virtual drives,
    Apple II Pi, or BASIC
  * A2CLOUD.HDV is now called A2CLOUD.PO (a symbolic link called A2CLOUD.HDV
    is still there for backwards compatibility/habits)
  * renamed MACRO files on server to be .txt and moved to files
  * added screen to a2cloud-help

## [1.6.6] - 2014-02-17

  * beta support for Debian and Ubuntu Linux on non-Pi machines
    * compiles binaries rather than downloads if not running on Pi
    * gets and supports Oracle x86 Java if not on Pi
    * installs X11 and LXDE if not installed
    * ttyUSBupper is always ttyUSB0, ttyUSBlower is always ttyUSB1
    * adtpro.sh supports USB-to-serial on all architectures
  * installs curl if not installed (for ttytter)
  * ttytter support for color and avoiding non-ASCII characters when running
    under Screen
  * opens LXTerminal window by default when starting graphical desktop
  * a2cloud-setup installs Screen if not already installed, also -v arg
  * a2cloud-setup shows installed and available versions
  * a2cloud-setup -y bypasses all prompts (removed -n)
  * a2cloudrc is now downloaded rather than created by script
  * LANG is now set in /usr/local/etc/a2cloud-lang rather than in a2cloudrc
  * fixed bug which checked for nulib2 instead of unar when seeing if needing
    to compile
  * setup exits properly whether run via source or shell
  * moved cftp to files

## [1.6.5] - 2014-02-05

  * can use "term mono" and "term color" instead of "term vt100" and "term
    pcansi", "none" also works
  * minor reorganization of configuration of a2cloudrc and screenrc

## [1.6.4] - 2014-01-31

  * support for "screen" command to allow switching between multiple terminals
    on Apple II
  * term command now has -f argument to force emulation setting
  * bash.bashrc now calls /usr/local/etc/a2cloudrc, which in turn calls
    a2cloud-aliases

## [1.6.3] - 2014-01-23

  * Set TTYtter to always use -ssl mode, which is required by Twitter after
    14-Jan-14.
  * Set TTYtter to avoid display of non-ASCII characters on serial port shell
  * Set TTYtter to use color ANSI text (for IIgs) if shell is currently set to
    display it
  * Provided TTYtter readline module for enhanced input with -readline option
  * Added "appleiipi-update" command

## [1.6.2 - 2014-01-19

  * Improved display of non-ASCII characters in Apple II terminal emulation
    programs by using ISO-8859 charset for serial port instead of UTF-8
  * adds 'term' command for setting vt100 or ANSI emulation
    This should help with Spectrum's ANSI display
  * perform apt-get clean at end of A2CLOUD install
  * Added "sciibin" and "unblu" for converting BinSCII and Binary II files
  * add 300 to the supported rates of baud command, in case you *really* want
    to kick it old school
  * alias a2cloud-update to a2cloud-setup
  * cmd line options and prompts to install everything or install individual
    pieces
  * revised intrudiction info in setup script

## [1.6.1] - 2014-01-14

  * Added "telnet" and "ttytter" (Twitter client)
  * fix for network boot failure when set up under v1.6
  * prevents exim4 error messages after Tin installation

## [1.6.0] - 2013-12-31

### Changed in 1.6.0
  * include check for ADTPro updates
  * remove hardcoding of ADTPro version in favor of script variable
  * asks for prodos volume name for new disk image; 8192 max
  * fixed order of files on 140K disk to be consistent with 800K disk
  * adtpro-start start now checks for USB adapter before starting
  * restarts ADTPro server on vsd1/vsd2 after prompting
  * created vsdsync alias to adtpro-restart; acmd warns if neeed
  * acmd warns if vsd1/vsd2 changes, and advises vsdsync if so
  * acmd now provides acmd help even on AppleCommander error
  * updates ADTPro/VSDRIVE to 1.2.9
    * pro: VSDRIVE can be run via ProDOS program launcher, not just BASIC
    * pro: much faster virtual drive read performance
    * con: short delay on vsd# commands
    * con: need to type vsdsync after changing active virtual drive image
      directly on the Pi

### Changed in 1.5.3
  * gets motd from web
  * sets password to apple2
  * if A2SERVER is installed, shares the ADTPro disks folder as ADTDISKS on the
    network
  * don't prompt for restart after install by default
  * avahi-daemon installed (so "raspberrypi.local" works as on Bonjour-enabled
    machines)
  * include backup server for shrinkit

## [1.5.2] - 2013-12-22

### Changed in 1.5.2
  * Apple II Pi is now installed with GSport emulator and “apple2user” packages
  * speedier install by downloading A2CLOUD disk images instead of building them
  * cleans up after installation
  * misc bug fixes
  * -h option for installer help

### Changed in 1.5.1
  * added "dos2pro" command

## [1.5] - 2013-12-01

  * Adds IRC and newsreader clients (Irssi and Tin) and, with shortcuts for
    Apple II community ("a2chat" and "a2news" commands)
  * adds KEGS and LinApple emulators
  * installs Apple II Pi
  * easy installation via Raspple II

## [1.2.3] - 2013-11-30

### Changed after 1.2.3
  * Date is approximated in changelog format conversion
  * Rewrote entry to combine multiple different changelogs

### Changed in 1.2.3
  * A2PI client version 1.3 added to A2CLOUD disk

### Changed in 1.2.2
  * download pre-compiled unar/lsar, nulib2, and cftp if possible
  * install only runtime dependencies for these tools if compiling them is
    unnecessary
  * console (built-in serial) login disabled, to allow Apple II Pi to have
    that port
  * installs xrdp/tightvncserver for remote desktop access from another
    computer
  * adds DSK2FILE image utility to A2CLOUD disk

## [1.0] - 2013-09-02

  * first proper release with full documentation, bug fixes, and demo video

## [0.99beta] - 2013-07-27

  * internet access and virtual drives for any Apple II via a Raspberry Pi;
    introduced at KansasFest 2013

# [A2CLOUD][1]

<!--
This file is an export of the [WordPress site][1] for A2CLOUD, pulled in
October 2015.  The formatting and links have been pretty heavily modified to
convert the page to Markdown format.
-->

* [love and hate mail: ivan@ivanx.com](mailto:ivan@ivanx.com)


## Table of Contents

* [A2CLOUD: intro][2]
* [A2CLOUD: what you need][3]
* [A2CLOUD: prepare your Pi][4]
* [A2CLOUD: go headless (optional)][5]
* [A2CLOUD: install the software][6]
* [A2CLOUD: attach your cables][7]
* [A2CLOUD: make your boot disk][8]
* [A2CLOUD: use virtual drives!][9]
* [A2CLOUD: log in from your Apple II][10]
* [A2CLOUD: make a floppy or image][11]
* [A2CLOUD: learn some Unix][12]
* [A2CLOUD: “insert” a disk image][13]
* [A2CLOUD: connect with other people][14]
* [A2CLOUD: browse &amp; download][15]
* [A2CLOUD: use disk images][16]
* [A2CLOUD: expand archives][17]
* [A2CLOUD: transfer files][18]
* [A2CLOUD: increase serial port speed][19]
* [A2CLOUD: emulate an Apple II][20]
* [A2CLOUD: Apple II Pi][21]
* [A2CLOUD: release history and notes][22]
* [A2CLOUD: other stuff][23]



# A2CLOUD: intro

Hello, and welcome to A2CLOUD! It provides any Apple II — even a IIc — with
internet access, mass storage, and floppy disk transfer, via a [Raspberry
Pi][24], a tiny silent $35 computer. You can also use A2CLOUD with other Linux
computers or virtual machines; [click here][25] for details.

This web page is the user guide; just read the posts in order. The table of
contents is over on the right. You might want to start with the intro video
below. (For other ways to use your Raspberry Pi with your Apple II, check
out [A2SERVER][26], and [Apple II Pi][27], both part of [Raspple II][28].)

*5-May-15: A2CLOUD 1.8.1 is available, featuring compatibility with every
Raspberry Pi including Raspberry Pi 2 Model B and Raspberry Pi 1 Model A+, and
non-Pi users now get the GSport emulator. If you already have A2CLOUD
installed, type `a2cloud-update` to update, or start over with the [Raspple
II][28] easy installation method (or upgrade Raspple II with `a2cloud-update
os`). The complete version history is [here][22].*

[![YouTube: A2CLOUD setup part 1: intro and demo][v_img01]][video01]

[v_img01]: http://img.youtube.com/vi/kYkOxe4mjHg/0.jpg
[video01]: http://www.youtube.com/watch?v=kYkOxe4mjHg

This entry was posted on July 14, 2013 by [ivanx][29]



# A2CLOUD: what you need

To use A2CLOUD, you need various things. Here’s a video to show you what
goes where, followed by your shopping list. (Don’t pay much attention to
2:00 through 6:00, as it’s now much simpler to set up A2CLOUD than when
I made the video.)

[![YouTube: A2CLOUD setup part 2: configure your Raspberry Pi][v_img02]][video02]

[v_img02]: http://img.youtube.com/vi/saIdvQNgm3c/0.jpg
[video02]: http://www.youtube.com/watch?v=saIdvQNgm3c


Places to purchase are linked:

* for virtual drives, any Apple II model with Applesoft

* for internet, an Apple IIc, IIgs, or 128K Apple IIe enhanced (though Apple
  II Plus and unenhanced IIe [might work][30])

* any Raspberry Pi, B/B+ models recommended
  ([buy direct from distributor][31], or at Amazon: [Pi 2 model B][32],
  [Pi 1 model B+][33], [Pi 1 model B][34], [Pi 1 model A+][35])

* a [4 GB or larger SD card][36] ([8 GB or larger][37] recommended)
* a [good power supply][38] with a micro-USB plug that provides at least 1A of
  current

* an [ethernet cable][39] attached to your router, or a
  [Wi-Fi adapter][40] (more complex)

* a [null modem Apple II serial cable][41] (or: [roll your own][42])

* a [USB-to-serial adapter][43]

* a [Super Serial Card][44], if you have an Apple IIe (see note below)


If you want simultaneous virtual drives and internet access from your
Apple II:

* another [null modem Apple II serial cable][41] (or: [roll your own][42])

* another [USB-to-serial adapter][43]

* another [Super Serial Card][44], if you have an Apple IIe (see note below)


Optional items:

* an [SD card reader][45] to prepare the SD card, if your computer doesn’t
  have one

* a [USB keyboard][46] and possibly [mouse][47] (or: you can
  [control the Pi from another computer][5])

* a [*powered* USB hub][48] (if you don’t have a free port for a USB-to-serial
  adapter)

* an [Apple II Pi card][49], or another [Super Serial Card][44] with a
  [Raspberry Pi Console cable][50], if you want to use [Apple II Pi][21]


If you have a straight-through serial cable rather than a null modem serial
cable, and you are using a IIgs or IIc (no Super Serial Card), you can use a
[DE-9 (aka DB-9) male-to-female null modem adapter][51].

If you have a Super Serial Card, its jumper block needs to point towards
“Modem” if you have a null modem cable, or “Terminal” if you have a
straight-through cable. (Or, if you are using it with a Raspberry Pi console
cable, that acts as a null modem cable, so reverse the jumper positions
described here.)

(A note about the USB-to-serial adapter: there are lots of different brands
and models of these. The only ones I have ever tested, including the TRENDnet
model linked above, are those based on the Prolific PL2303 chipset. Other
models based on other chipsets such as FTDI may also work; I just haven’t
tried them.)

This entry was posted on July 14, 2013 by [ivanx][29].



# A2CLOUD: prepare your Pi

### Starting Fresh

If you have never used your Pi, you will need to prepare your SD card.
Download [Raspple II][28] (a distribution of the Raspbian operating system
with Apple II goodies preinstalled), and expand the .zip file. Copy all of its
files to a 4 GB or larger SD card (8 GB or larger recommended). Then put the
SD card in your Pi, and attach power. The operating system will automatically
install, which will take about 20 minutes. If you don’t have a screen attached
to your Pi, you’ll know when it’s done when the ACT/OK lamp on the Raspberry
Pi board stops flickering.

(If you are starting over with the same SD card, or want to ensure the card is
formatted correctly, you can use the official [SD Formatter][51]  utility —
carefully! — before copying the files.)  

### If you’re already up and running, or want to customize the installation

You can also install A2CLOUD from the Raspbian command line. Type:

```
wget appleii.ivanx.com/a2cloud/setup; source setup
```

If you want all the features, answer “Y” to the questions. Then be patient, as
it takes a little while to install.


This entry was posted on July 14, 2013 by [ivanx][29].



# A2CLOUD: go headless (optional)

For basic A2CLOUD use, I recommend going headless with your Raspberry Pi —
that is, using it without a screen and keyboard. This will keep your USB ports
free and reduce clutter, plus make it feel more like an Apple II
peripheral. It’s pretty doable because you can always display your Pi’s screen
on a newer computer on your network, and you can even log into its command
line from your Apple II.

With that said, you may want a screen and keyboard attached if you want to use
[Apple II Pi][21], or you just feel more comfortable using it that way. So if
you’re not ready to go headless, you can skip the rest of this post.


### Log in to the Pi’s command line:

If you’re gonna go headless, then you’ll need to take a few steps so that you
can control your Pi from another computer, which could be an Apple II, as I’ll
explain in a few posts. But you can also use a current-day computer on your
network.

On a Mac, open Terminal (in the Utilities folder of the Applications folder),
and at the prompt, type `ssh pi@raspberrypi.local` to connect. If you have
Windows, you can install [Bonjour Print Services][52], and then use
[PuTTY][53] to connect to the address “raspberrypi.local”.

If that doesn’t work, try updating A2CLOUD by typing `a2cloud-setup`. If it
still doesn’t work, or you don’t want to install Bonjour Print Services for
Windows, you will need to find your Pi’s IP address and use that instead. If
you have a Mac, you can use [Pi Finder][54] to help with this; if you have
Windows, you can use [Advanced IP Scanner][55].

The username is “pi” and the password is “apple2″ (or instead “raspberry” if
you installed a fresh copy of Raspbian, rather than Raspple II). You should
arrive at the Linux prompt.


### Remotely Access the Raspbian desktop

You can access the Raspbian graphical desktop by using remote desktop
software. Use the Remote Desktop Connection application included with
Microsoft Windows, or its [Mac version][56], to connect to your Raspberry Pi
by putting in “raspberrypi.local”, or your Pi’s IP address. (If you would
prefer to use a VNC client, [configure tightvncserver][57]. You could also use
RDP or VNC clients for other platforms, like iOS and Android.)


### Get a consistent IP Address

If “raspberrypi.local” doesn’t work for you for some reason, and you don’t
want to have to use Pi Finder or Advanced IP Scanner every time you want to
log into your Pi, I suggest you create a DHCP reservation in your router. This
will make your router give your Pi the same IP address every time. Every
router’s configuration screen is a little different, but they all require the
same things: the 12-digit MAC (ethernet hardware) address, and the IP address
that should be assigned to it.

Pi Finder and Advanced IP Scanner give you this info. Alternatively, from your
Pi, type `ip addr` and you’ll find the MAC address as six pairs of digits
separated by colons, in a line that starts with “link”, and the IP address as
four numbers separated by periods immediately after the word “inet”. If you
need help creating DHCP reservations on your particular router, check the
manual, or Google for it.

If your router can’t provide a DHCP reservation, you can alternatively
configure your Pi to have a static IP address (which is permanently set,
rather than asking your router for it) via the method discussed [here][58].

 
This entry was posted on July 14, 2013 by [ivanx][29].



# A2CLOUD: install the software

If you used the [Raspple II][28] installation method, you’ve already installed
the A2CLOUD software, and can skip the rest of this post.

If you don’t have A2CLOUD installed yet — because, for example, you installed
vanilla NOOBS or Raspbian, rather than Raspple II — log in to your Pi, and at
the Linux prompt type:

```
wget ivanx.com/a2cloud/setup; source setup
```

A2CLOUD is confirmed to work on Debian 7 (“Wheezy”), all releases of Raspbian,
and possibly earlier versions of both. It is believed to work on other Debian
derivatives, such as Ubuntu 14.04 LTS. (A2CLOUD does not yet fully work on
Debian 8 or Ubuntu 15.04, or other distributions that use systemd.)

Follow the prompts; I suggest you answer “yes” to all of them, and everything
on these pages will assume that you have. When you are asked to specify the
size of your virtual disk (in KB), keep in mind that the larger it is, the
slower it will be; hopefully this will change in the future.

When it’s done, the A2CLOUD installer will ask you to reboot your Pi. Do so,
and wait about two minutes for it to complete. (If you’ve got a screen
attached, wait until it shows you the login prompt; you don’t actually need to
log in.)

You’ve now got your Raspberry Pi providing virtual drives and internet access
for your Apple II!


This entry was posted on July 14, 2013 by [ivanx][29].



# A2CLOUD: attach your cables

Figure out which of the following scenarios applies to you, and attach your
USB-to-serial adapter(s) according to the options you see.

If you are using a Raspberry Pi with four USB ports, then use the pair of USB
ports next to the Ethernet port, not the ones in the corner.

If you are using a Raspberry Pi model A or A+, consider its one USB port to be
the “lower” port in the instructions below. If you have a USB hub attached to
it, then port 2 on that hub is the “upper” port, and port 3 on that hub is the
“lower” port. Since the physical ports these correspond to may vary by hub,
you may need to try different ports to figure out which is which.

You’ll see mentioned below the “lowest-numbered” or “highest-numbered” port in
a USB hub, which isn’t necessarily obvious. If you have a USB hub, try the
leftmost or topmost port, and if that doesn’t work, try the rightmost or
bottommost port. If you want to definitively know, see the note at the end.

If you have an Apple IIe, then “printer port” or “modem port” means a Super
Serial Card in slot 1 or 2, respectively.


### You have one USB-to-serial adapter, and want to use it for virtual drives

You can use:

* the lower USB port

* any port in a hub on the lower USB port if it is the only USB-to-serial
  adapter in the hub

* the lowest-numbered port on a hub with multiple USB-to-serial adapters


Connect the adapter to a serial cable attached to to your Apple II modem port.


### You have one USB-to-serial adapter, and want to use it for internet

You can use:

* the upper USB port

* any port in a hub on the upper USB port if it is the only USB-to-serial
  adapter in the hub

* the highest-numbered port on a hub with multiple USB-to-serial adapters


Connect the adapter to a serial cable attached to to your Apple II printer
port.


### You have two USB-to-serial adapters

Do both of the above.


### How to figure out the lowest or highest numbered port on your USB hub

You can attach two USB-to-serial adapters to a USB hub attached to either USB
port on the Pi. A2CLOUD tells them apart based on their being attached to a
lower numbered port for virtual drives, and a higher numbered port for
internet.

I did it this way so you can simply try the ports at either end of the USB hub
and see if you get the results you expect. But If you want to know the actual
port number, detach all of your USB-to-serial adapters, then plug in one
adapter. Then type `ls /dev/ttyUSBlower_hub*` and see what it shows you. The
number at the end is your USB port number. You can then move the adapter to a
different port and repeat until you figure out which one is the lowest and
which one is the highest.


This entry was posted on July 14, 2013 by [ivanx][29].



# A2CLOUD: make your boot disk

You’re almost ready to use virtual drives, courtesy of David Schmidt’s
[VSDRIVE][59], which is included with [ADTPro][60]. You can also use ADTPro
itself to transfer disk images to actual disks, and vice versa.

To access the virtual drives, you need to boot from the A2CLOUD disk. To get
that, you need ADTPro to transfer it to an Apple II floppy. If you’ve already
got ADTPro on an Apple II disk, boot it (choose Serial if prompted), and skip
the video and the paragraph which follows it. Or, if you’ve got some other
means of turning disk image files into floppies, you can download the
[140K A2CLOUD boot disk][61] or the [800K A2CLOUD boot disk][62], and skip the
rest of this post.

If you don’t have ADTPro on an Apple II disk already, you need to get it
running on your Apple II via a process called bootstrapping. Here’s a video to
show you how to do that, or you can read the instructions below it.

[![YouTube: A2CLOUD setup part 3: making your boot floppy][v_img03]][video03]

[v_img03]: http://img.youtube.com/vi/iOKIQNF8sZY/0.jpg
[video03]: http://www.youtube.com/watch?v=iOKIQNF8sZY


First, turn on your Apple II and press ctrl-RESET before DOS or ProDOS can
load. Next, if you have a screen, keyboard, and mouse attached to your Pi,
type `startx.` Otherwise, log in with Remote Desktop Connection (as described
in [A2CLOUD: go headless][5]) from another computer. Once you see the
desktop, double-click ADTPro Server, and when the ADTPro server window
appears, choose Bootstrapping-&gt;ProDOS-&gt;SpeediBoot and follow the
instructions which pop up. When you get to the “LOADING MLI” phase on your
Apple II, nothing may appear to happen for several minutes; just be patient
and it will eventually kick in. (You can alternatively choose
VSDRIVE+SpeediBoot to immediately gain access to the virtual drives, but as
soon as you reboot, you’ll need to bootstrap again. It’s much more convenient
to have a boot floppy.)

Once you’ve ADTPro running, put in a blank floppy disk and type F to format it
(unless you know it’s already formatted). You can use any volume name. When
it’s done, type R to receive, and then enter (in all caps) A2CLOUD.DSK for a
5.25″ drive or A2CLOUD.PO for a 3.5″ drive. The A2CLOUD disk will be copied
from your Pi to your Apple II. (You can use ADTPro to transfer any other disk
images to or from your Pi at any time.)

If you bootstrapped, once you’ve got your A2CLOUD disk, you can leave the
ADTPro server window open, or reboot your Pi. If you close the window, or quit
the Raspbian desktop without rebooting, ADTPro server will no longer be
running; you can type `adtpro-start` at a prompt to get it going again, or
reboot, or disconnect and then reconnect the USB-to-serial adapter on the
lower USB port.


This entry was posted on July 14, 2013 by [ivanx][29].



# A2CLOUD: use virtual drives!

Ok, almost there. Fire up your A2CLOUD floppy, and at the welcome screen, type
V. (If you are at an Applesoft prompt, you can instead type `-VSDRIVE`.)

Once you’ve done this, you can access your blank virtual disk on slot 2 drive
1, and the 800K version of the A2CLOUD disk on slot 2 drive 2.  Check it out
by typing `CAT,S2,D2`. After specifying the slot and drive, they will stick
for subsequent [ProDOS commands][63] (that’s a quick list; here’s a
[full manual][64]). You will no longer have access to slot 6. To regain
access to slot 6, do a full reset of your Apple II and boot any ProDOS disk as
usual.

You can also run VSDRIVE from a ProDOS 8 program launcher (e.g. the `BYE`
command). Nothing will appear to happen, but your virtual drives will become
available. (If you don’t see VSDRIVE when you’re not in BASIC.SYSTEM, update
ADTPro by typing `a2cloud-update`.)` `

If you need access to both slot 6 and the virtual drives at the same time, you
can, after booting, type:

```
-VSDRIVE.LOW
```

However, this version of the driver for the virtual disks is easily
overwritten by other software, especially if you exit BASIC.SYSTEM.  However,
ProDOS Filer works ok, so it is included on the A2CLOUD disk if you need to
transfer files from slot 6 to a virtual drive. Just type `-FILER` to use it.
Note that if you’re transferring from the A2CLOUD floppy disk to the virtual
A2CLOUD disk (in S2,D2 by default), you’ll first need to rename the volume of
your boot floppy to something like A2CLOUD.DISK, so Filer can tell it apart
from the volume named A2CLOUD in the virtual drive.

If you think Filer sucks, because it does, you can instead use ADTPro to
transfer your entire 5.25″ disk to a new disk image on your Pi that you can
use with VSDRIVE, or experiment with other copy programs.

You can also change the virtual drives to use different images, which I’ll
explain in a later post.


This entry was posted on July 14, 2013 by [ivanx][29].



# A2CLOUD: log in from your Apple II

If you’re happy enough controlling your Pi with a screen or keyboard attached,
or by logging into it from another computer, then you don’t really need to
read any of this post. But it’s *more fun* to log into it from your Apple II.
You try it.

To do that, you’ll need terminal communications software which supports VT-100
emulation. The A2CLOUD installer provides both [ProTERM][65] and Z-Link for
IIc, IIgs, and enhanced IIe; GS/OS users can also download and use
[Spectrum][66] for color and graphic text. Apple II Plus and unenhanced IIe
users have some options too.

Once you’ve connected with your terminal program — specifics are below — press
return a couple of times, and you should see the Raspberry Pi login prompt.
Log in with username `pi` and password `apple2` (or `raspberry`, if you
installed standard Raspbian).  You should be taken to the Linux prompt. If you
quit your terminal program, and then run it later, you’ll be right where you
left off — you won’t have to log in again unless you restart your Pi.

Then you can download files and transfer them into your disk images or to your
Apple II, and do other stuff on the internet. More on how in a future post.
(Once you’ve got one of the below terminal programs working, you may also want
to try out a [faster serial port rate][19] than the default 4800 baud.)

Once you get comfortable with logging in, you might want
multiple terminal screens you can switch freely between. To do this,
type `screen`. Then, whenever you need a new screen, type ctrl-A followed by
C. You can go back to a previous screen with ctrl-A followed by P, or forward
to the next screen by typing ctrl-A followed by N.   To close a screen,
type `exit` or ctrl-A followed by K. When you close the last screen, Screen
quits. All Screen commands start with ctrl-A; for a full list of commands,
type ctrl-A followed by a question mark. A well-written, easy-to-follow guide
on how to get the most out of Screen is [here][67].

 
### ProTERM

ProTERM is a robust and recommended terminal program, but it does not fit on
the 140K A2CLOUD disk, and it needs to stay in the drive (or virtual drive)
while being used. You’ll find it on the 800K disk, or the S2,D2 virtual drive.
When ProTERM runs, select the “Null Modem (CTS/RTS)” driver and the
IIgs/IIc/IIc+ printer port, or a Super Serial Card in slot 1. (Note that if
you use your own copy of ProTERM, the IIc/IIc+ printer port is not listed, so
for that machine you’d need to use the copy that A2CLOUD provides; thanks to
Hugh Hood for this patch.) For printer, select No Printer In System. When
you’re ready to connect, choose Parameters from the Online menu, choose 4800
baud and VT-100 emulation, hide the status bar, and select Line Status:
Online. (Thanks to Tony Diaz and Intrec Software for making ProTERM free to
the community.)

 
### Spectrum

[Spectrum][66], for the Apple IIgs, is not provided on the A2CLOUD disk,
[but is freely available for download][68]. From the Settings menu, choose
Port and select the printer port at 4800 baud. Then in the Settings menu,
choose Online Display and select VT-100 (monochrome text), or ANSI (color and
graphic text, though slower). Then from the Show menu, choose Online Display.
If you are using ANSI, type `term color` after logging in, or `term -d color`
if you don’t want to do it every time. You can also type `term mono` if you
want to switch it back for use with other terminal programs. When you’re done,
type Apple-W to “close” the display. (Thanks to Ewen Wannop for making
Spectrum free to the community.)


### Z-Link

Z-Link is provided on both the 5.25″ and 3.5″ versions of the A2CLOUD disk.
While not quite as capable as ProTERM, it is able to fit on a 5.25″ disk and
is self-contained in memory without needing further disk access. When you
first run Z-Link, you need to configure it by pressing openApple-W and
choosing 4800 baud, slot 1. Then press openApple-T until VT-100 emulation is
enabled. Finally, press open-apple-S and type the file name `Z.LINK.CONFIG` to
save the configuration and have it be loaded whenever you run Z.LINK.

If you want to run Z-Link from a virtual drive, you need to first copy
Z.LINK.CONFIG from your floppy, because otherwise it will go online
immediately using slot 2, which makes the virtual drive stop working.  Boot
your A2CLOUD disk and set it up as above. Then, at the Applesoft prompt,
type `-VSDRIVE.LOW` followed by `-FILER`. Once in Filer, rename the volume of
your A2CLOUD floppy to A2CLOUD.DISK, then copy /A2CLOUD.DISK/Z.LINK.CONFIG to
/A2CLOUD/Z.LINK.CONFIG.


### Apple II Plus and unenhanced IIe

If you have an Apple II Plus or unehnanced IIe, there have been reports
of success with using [Kermit 3.87][69], or DCOM 3.3,
for terminal access to your Raspberry Pi. They need to be set for VT-100
emulation, and on an Apple II Plus you need a Videx VideoTerm (but not
UltraTerm) for 80 column support. I haven’t tried them, but [here’s the
relevant discussion thread][70].


This entry was posted on July 14, 2013 by [ivanx][29].



# A2CLOUD: make a floppy or image

If you have [A2SERVER][26] installed — which you do if you installed A2CLOUD
with [Raspple II][28] — it’s easy to download software with your modern
computer and turn it into a floppy disk with your Apple II, or use it as a
virtual drive. And it’s just as easy to make an image from an Apple II floppy
that you can use in an emulator on your modern computer.

(If you don’t have A2SERVER installed, you can start over with
[Raspple II][28], or you can, at your Raspberry Pi’s prompt, type `wget
ivanx.com/a2server/setup; source setup` to install it. If you’re not sure,
type `a2server-help`; if you get a help screen, you’ve got A2SERVER.)

On your newer computer, you can browse your network and you should see
 “raspberrypi” as a server you can connect to. You can log in as Guest if
asked.

On Mac OS X, it should appear under Shared in the sidebar of a Finder window,
or under “Network” from the “Go” menu of the Finder. On Windows, it should
appear under Network. On Mac OS 7 through 9, open Chooser from the Apple menu
and click on AppleShare.

(If you can’t browse to the server on your network, try typing
`a2server-setup` to update it, and if that doesn’t work, type `showip` to get
your Pi’s IP address. On Mac OS X, enter the IP address under “Connect To
Server…” from the Go menu of the Finder; on Windows, type the IP address
following two blackslash characters (\\) in an Explorer window.)

<!--
Content edit: Make sure both Markdown source and HTML target renderings of how
to specify a backslash-delimited UNC path are understandable.  -Joseph
-->

Open the ADTDISKS shared volume and copy any disk images you want to make into
disks in there.

Then run [ADTPro][60] on your Apple II, which is on your A2CLOUD boot disk.
Type R to receive, and type the name of the image file (case matters), and
then choose the drive containing the disk you want to put the image onto. The
disk will be erased, so be careful.  Also, if you were using VSDRIVE before
you ran ADTPro, you might not have access to slot 6; if you need it, reboot
and then run ADTPro.

If you want to turn a disk into an image, do the reverse process: type S to
send in ADTPro, and then choose the drive you wish. The image will appear in
the ADTDISKS network volume on your newer computer.

You can type D for directory in ADTPro to get a listing, but characters are
sometimes missing, so you might need to do it a few times, or refer to the
ADTDISKS network volume on your newer computer.

Unix-type computers can also use `scp` to copy files to and from A2SERVER;
Windows computers can also do so in the command window by using `pscp`
in [PuTTY][53]. The shared volume is at /media/A2SHARED/ADTDISKS.


This entry was posted on July 14, 2013 by [ivanx][29].



# A2CLOUD: learn some Unix

Once you’re logged into your Raspberry Pi, you can download disk images and
use them with VSDRIVE or transfer them with ADTPro.

To do so, you’ll need to know some Unix. Everything you type at a prompt is a
Unix command, either built-in, or a program that gets executed.  Most commands
can take additional arguments (parameters) separated by spaces to modify how
they operate. Note that everything in Unix is (usually) case-sensitive — that
is, “ls” is not the same thing as “LS”.

Here’s some basics:

`pwd` will print the path of the current directory (like PREFIX)

`cd /path/name` will change the directory to /path/name (like PREFIX
/PATH/NAME)

`ls `will list the files in the current directory (like CAT)

`ls -lp` will list the files in the current directory in long format (like
CATALOG)

`cp sourceFilePath targetFilePath` will copy a file

`mv filePath newFilePath` will move or rename a file (like RENAME)

`rm filePath` will delete a file (like DELETE)

`mkdir dirPath` will create a subdirectory (like CREATE)

`rmdir dirPath` will delete a subdirectory (like DELETE)

`logout` logs you out

`sudo shutdown -h now` will shut down your Pi

`sudo shutdown -r now` will restart your Pi


There are also three “special” directories, indicated by a single or double
period, or a tilde:

`.` means the current directory

`..` means the parent (enclosing) directory

`~` means your home directory (on the Pi’s default user, it’s /home/pi)


A couple of tips:

pressing up-arrow (or solidApple-up-arrow in ProTERM on a IIe/IIc, or in
Z-Link)  at the command prompt will display previously typed commands

pressing ctrl-A while editing a command will take you to the beginning of a
line

pressing ctrl-E while editing will take you to the end of a line


A2CLOUD provides some specialized commands as well, some of which will be
covered in upcoming posts. To see a full list, type `a2cloud-help`.

If you need additional explanation of a command and its arguments, you can
sometimes type “command -h” or “command –help”, and for most commands,
extensive help is available by typing “man command”.

This is just the tip of the iceberg. There are lots and lots of Unix commands
for every purpose imaginable. If you think there are others which should be
included here, please mention them in the comments.

 
This entry was posted on July 15, 2013 by [ivanx][29].



# A2CLOUD: “insert” a disk image

To make things easy, A2CLOUD has commands to “insert” disk image files into
the virtual drives:

`vsd1 imageFileName` will “insert” imageFileName into S2,D1

`vsd2 imageFileName` will “insert” imageFileName into S2,D2

`vsd1` or `vsd2` by itself will show you the path to the disk image currently
“in” the drive

Note that the disk image you “insert” can be either DOS-ordered or
ProDOS-ordered. VSDRIVE will figure it out. The disk doesn’t need to even
contain ProDOS, as long as you’re using ProDOS software which can access it —
for example, System Utilities can copy files from a DOS 3.3 or Pascal image.

To make new image files, you can transfer real floppy disks from your Apple II
using ADTPro. These will arrive in /usr/local/adtpro/disks, which you can also
refer to as $ADTDISKS for short; if you have A2SERVER installed, this folder
is also available [on your network][11] to other computers, so you can use the
images you create with an emulator.

Also from another computer, you can copy an image into the ADTDISKS network
folder and then insert it into a virtual drive by typing `vsd1
$ADTDISKS/imageFileName`. (For virtual drive 2, use `vsd2` instead.) Or you
can download disk images from the internet directly on your Pi, which I’ll
explain in a later post.

You can always put the A2CLOUD disk image back in virtual drive 2 with:

```
vsd2 $A2CLOUD
```

(The `vsd1` and `vsd2` commands create a symbolic link, which is like a
Windows shortcut or Mac alias, to whatever file you specify as imageFileName.
The symlinks are in /usr/local/adtpro/disks, and are called Virtual.po or
Virtual2.po, respectively.)


This entry was posted on August 11, 2013 by [ivanx][29].



# A2CLOUD: connect with other people

Once you’ve logged into your Pi — that could be from your Apple II using
ProTERM or Z-Link or Spectrum, or with a directly attached keyboard and
screen, or via SSH from another computer — you can start communicating on the
internet.

Unless you’re using ProTERM or Spectrum on an Apple IIgs, *remember to hold
down solidApple when pressing the arrow keys* when you’re using these
programs.


### IRC (Internet Relay Chat)

If you want to chat live with other Apple II people, all you need to do is
type `a2chat`. It will launch an IRC program called Irssi and connect you
directly to the #a2c.chat channel. (If you want to connect to other channels,
instead type `irssi`.) Type `/quit` when you’re done. You might want to check
out more detailed instructions for [IRC generally][71] or
[Irssi specifically][72].


### Usenet newsgroups (discussion boards)

To access the Apple II discussion boards on Usenet (often referred to as
comp.sys.apple2.\*), type `a2news` and it will start the Tin newsreader.  You
will be subscribed to only the Apple II newsgroups by default; to access all
the other ones, type Y (for “yank”) and subscribe to the ones you like. (If
you have a preferred NNTP server you would like to use, you can set it by
typing `a2news -s your.server.address`.)


### Twitter

You can indeed tweet from your Apple II, if you can believe it. Type `ttytter`
and follow the instructions. For initial setup, you’ll need to sign in to your
Twitter account from a web browser, which, if you don’t want to leave your
Apple II, could be Lynx, as I will explain in the next post.  If you need
help, an [extensive manual][73] is available for TTYtter. You can also try
starting it by typing `ttytter -readline` for enhanced input, though it is
beta and may have problems.


### Email

There are email programs you can use, but they can be challenging to set up,
so they have not formally been made a part of A2CLOUD for the moment. If you
want to give it a go, [see this comment][74] to get started, and look for help
on Linux forums if you need it.


This entry was posted on August 11, 2013 by [ivanx][29].



# A2CLOUD: browse &amp; download

If you want to get new Apple II software, there are a few ways to go about it.

You could try a desktop browser on the Pi, such as the included Epiphany
(a.k.a. Web), Midori, or Netsurf, or install an alternative such as
[Chromium][75], the open-source cousin of Google Chrome, or [Iceweasel][76],
which is a rebranded Firefox.

You can also download with a modern computer, and [copy to your Pi over your
network][11]. If you don’t want to immediately create a real floppy, see the
next post for what to do with your downloads.

Or, for maximum fun, you can browse and download with your Apple II,
because A2CLOUD provides you with the stuff on your Pi that you need. My
general advice here is to just dive in and try these out if you’re not
familiar with them. You’ll find no shortage of help for most of these if you
search for it.

Unless you’re using ProTERM or Spectrum on an Apple IIgs, *remember to hold
down solidApple when pressing the arrow keys* when you’re using these
programs.

 
`lynx`\: a text-only web browser which can access simply laid out sites.
Examples: `lynx ivanx.com`, or a download site, like `lynx
mirrors.apple2.org.za`. ProTERM and Spectrum work better for lynx than Z-Link
does. (You can also try out [alternative text-only web browsers][77].)

`links`\: another text-only web browser you might, or might not, prefer to
Lynx. If you see only a black screen when you start it, press the ESC key to
see the menu.

`cftp`\: What you’ll probably spend a lot of time using if you want new Apple
II software. It’s for logging into FTP (File Transfer Protocol) servers.
Unlike the traditional command line FTP program, cftp is full-screen, uses the
arrow keys, and is easy. Example: `cftp ftp.gno.org`

`ftp`\: The traditional command line FTP program. Example: `ftp ftp.gno.org`.
It uses (mostly) typical [Unix commands][12]. When asked for username, enter
“anonymous” and then anything for the password. Use the usual directory
listing and navigation commands (`cd`, `pwd`, `ls`), to browse the site,
then `get filename` to download a file from a site, or `put filename` to
upload a file to a site. To see the current local directory (the one you’ll be
downloading into or uploading from), type `!pwd`, and to change it, type `lcd
directoryPath`. You can see all commands by typing `help`.

`wget`\: a simple program that can download a full URL from an FTP or web site
in a single command, e.g: `wget
http://appleii.ivanx.com/slammer/files/SLAMMER111P.DSK`

 
This entry was posted on August 11, 2013 by [ivanx][29].



# A2CLOUD: use disk images

Once you’ve [downloaded stuff to your Pi][15], or [copied stuff on to it from
another computer on your network][11], you can [immediately use the `vsd1` or
 `vsd2` commands][13] for an uncompressed disk image file (.DSK, .DO, .PO,
.RAW, .HDV, .2MG. ISO) containing ProDOS files, and then access them from your
Apple II. The image file will be “inserted” into virtual drive 1 or 2, and
accessible from VSDRIVE at S2,D1 or S2,D2.

If what you download is an archive file (.SHK, .SDK, .BXY, .ZIP, .TAR.GZ,
etc.), you’ll need to expand it first, which you can read about how to do in
the next post.

If you’re not sure whether the disk image you downloaded is ProDOS format or
not, you can type `a2cat imageFileName` on your Pi, and it will catalog the
disk and tell you the format at the bottom of the listing.

If it’s a DOS 3.3 disk, you can type `dos2pro imageFileName` to copy the files
to a new ProDOS  image, or `dos2pro imageFileName DOSFILENAME` to copy a
single file. Some programs may not work when copied to ProDOS.

Or, you can use ADTPro to transfer the image file to a floppy disk. To make a
disk image available to ADTPro, you need to move it into into the ADTPro disk
images directory (/usr/local/adtpro/disks) by typing `forfloppy
imageFileName`. To access the files inside that directory, you can also refer
to it as $ADTDISKS (e.g. `ls $ADTDISKS`).

You can also use `vsd1` or `vsd2` for non-ProDOS disks, but you won’t be able
to access them from within ProDOS. However, you can use a ProDOS utility which
knows how to access the format (e.g. System Utilities can copy files from DOS
3.3 and Pascal disks).


### Some commands for working with Apple II disk images:

`mkpo -b totalBlocks newImageFileName PRODOS.VOL.NAME` will make a new disk
image that has the capacity specified in `totalBlocks`. (A block is 512 bytes,
or half a KB.) The maximum block count is 65535, though if you plan to use the
disk image with VSDRIVE, a realistic maximum is 8192. If you omit `-b
totalBlocks`, you’ll get an 800K disk image, unless your image name ends in
“.dsk”, in which case you’ll get a 140K disk image.  You can also
omit `PRODOS.VOL.NAME` to get an untitled disk image.

`dopo imageFileName` will convert a DOS-ordered 140K disk image to a
ProDOS-ordered image, or vice-versa. The original ordering will not be kept.

`acmd` will do lots of stuff with Apple II disk images (many formats,
including ProDOS, DOS 3.3, and Pascal, are supported). Type `acmd` by itself
to see usage; syntax for copying files in and out of images will be mentioned
in the next post on transferring things to your Apple II.  (`cppo` is an
alternative, but it’s even slower. It does preserve dates, however.)

`$VSD1` and `$VSD2` can be used in commands to refer to the disk images
assigned to virtual drives 1 and 2, rather than typing out the full path.


This entry was posted on August 11, 2013 by [ivanx][29].



# A2CLOUD: expand archives

If you have an archive file, on your Pi, you’ll need to expand it.

Commands for general archive formats:

`unzip archiveFileName` will extract files from a .zip archive

`gunzip compressedFileName` will uncompress a .gz compressed file

`tar xf archiveFileName` will extract files from a .tar archive

`tar zxf archiveFileName` will extract files from a .tar.gz (or .tgz) archive
(both of the previous commands in a single step)

`unar archiveFileName` will extract files from tons of archive formats,
including obsolete ones like StuffIt and DiskDoubler. See [The
Unarchiver][78] for a full list.


Commands for Apple II archive formats:

`nulib2 -x archiveFileName` will extract files from a ShrinkIt (.SHK, .SDK,
.BXY) or Binary II (.BQY, .BNY) archive. This will mostly be useful when the
archive contains a full disk image (typically, but not always, indicated as
.SDK); if the archive contains files, use one of the commands below. You can
view the contents of an archive before expanding with `nulib2 -v
archiveFileName`.

`shk2image archiveFileName imageFileName` will extract files from a ShrinkIt
or Binary II archive to a ProDOS disk image file (if the one you specify
doesn’t exist, an 800K image will be created, unless the name you gave ends in
“.dsk”, in which case a 140K image will be created). If you want the archive
to be expanded directly to virtual drive 1 or 2, use `$VSD1` or `$VSD2` for
`imageFileName`.

If you want the archive to be expanded into a ProDOS subdirectory rather than
at the top level of the disk image, you can supply a ProDOS path, without the
volume name, as an additional argument. The subdirectory (and any
subdirectories within it) will be created if it doesn’t exist.  For example:

`shk2image archiveFileName $VSD2 PATH/TO/PRODOS.DIR.NAME`

(You can also uncompress ShrinkIt archives on your Apple II by transferring
the archive, as I’ll explain in the next post. It’s slower that way, though.)

For other (and older) Apple II formats: `sciibin filename` will decode a
BinSCII file (.BSC, .BSQ); note that .BSQ files produce ShrinkIt archives when
decoded, so use `nulib2 -x` or `shk2image` on the result. `nulib2 -x
filename` will extract files from a Binary II (.BNY, .BQY) archive, and will
automatically uncompress any Squeezed (.QQ) files within the archive;
alternatively, `unblu filename` will extract files from a Binary II archive
and `usq filename` will uncompress Squeezed files. `unbit filename >
outfilename` will decode an EXEC file made by Executioner; `unexec filename >
outfilename` will decode an EXEC file containing monitor input.


This entry was posted on August 11, 2013 by [ivanx][29].



# A2CLOUD: transfer files

If you’ve got files on your Pi that aren’t inside one of your viritual disks,
and you want to transfer them to your Apple II, you’ve got a few options.


### Archive files:

If it’s an archive file, you can (and perhaps should) expand it directly on
the Pi, as explained in [A2CLOUD: working with archives and disk images][17].
Otherwise, use one of the cool moves below, and then expand it with ShrinkIt
or the appropriate program on the Apple II.

 
### Copy a file into a disk image

`acmd -c fileToBeCopied imageFileName`

You can then use `vsd1` or `vsd2` to access the image file, or, alternatively,
transfer it to a floppy with ADTPro. If you want to copy a file directly to a
disk image already in a virtual drive, use `$VSD1` or `$VSD2` for
`imageFileName`. *You must immediately type `vsdsync` if you modify an image
currently assigned to a virtual drive.*

If you want to specify a different name and/or file type, you can use the long
form:

`acmd -p imageFileName APPLE2.FILENAME fileType auxType < fileToBeCopied`

`fileType` should be a three-letter name (e.g. TXT), or a numeric type (e.g.
255 or $E0). `auxType` is also needed for file types that require it (e.g.
BIN), and can be either decimal, or hexadecimal if preceded with $. You can
use $2000 for `auxType` if you’re not sure. If you want the file to go into a
ProDOS subdirectory, you can specify the path as part of `APPLE2.FILENAME`
(but do not include the volume name); any subdirectories that don’t already
exist will be created.

(This is a slightly modified version of AppleCommander’s normal -p option: the
file type and ProDOS file name are optional, the file name is checked to make
sure it’s ProDOS-compatible, and any existing file of the same name within the
image is first deleted.)


### Transfer a file from your Pi to your Apple II

You can transfer a file to be saved on a local or virtual disk by using the
YMODEM protocol. To send one or more files with YMODEM, type:

`sb fileToBeTransferred1 fileToBeTransferred2 fileToBeTransferred3` (etc)

Once started, you will need to tell ProTERM or Z-Link to receive YMODEM.  In
ProTERM, choose YMODEM from the Receive menu; in Z-Link, type
open-apple-downarrow, then option 4. In either one, accept the default options
(unless you want to change them), and the files should transfer.  If for
whatever reason they don’t, and you can’t get access to the Linux shell prompt
again, type ctrl-X until the prompt reappears. Transfer may be slow at the
default 4800 baud rate; I’ll explain how to increase the baud rate in the next
post.

If you are using ProTERM, you can also try ZMODEM by using `sz` instead of
`sb`. ZMODEM is a more efficient protocol than YMODEM, it can auto-start, and
it can recover from incomplete transfers, but those are less important in a
direct-attached (rather than dial-up) situation, and I haven’t had as much
success with it as I have had with YMODEM.


### Transfer a file from your Apple II to your Pi

You can also go in the other direction — from your Apple II to the Pi.
Type `rb` (for YMODEM) then tell ProTERM or Z-Link to send YMODEM. (If you
prefer to send ZMODEM from ProTERM, just do that, and the Pi will
automatically start receiving; you don’t need to type a command first.)

Another option is to save a file to a virtual disk — or transfer a real floppy
using ADTPro — and then copy files out of the disk image on the Pi with this
command:

`acmd -g imageFileName APPLE2.FILENAME`

If you saved to the virtual disk, you can type `$VSD1` or `$VSD2` for
imageFileName.

acmd (AppleCommander) has some smarts, and it can translate (or “export”, as
it prefers to say) from various Apple II file formats into modern formats. If
you want it to give that a shot, use `-e` instead of `-g` above.


This entry was posted on August 11, 2013 by [ivanx][29].



# A2CLOUD: increase serial port speed

I chose the default speed of 4800 baud for Pi as a lowest common
denominator that should work in almost any situation, even a IIc using
Z-Link without any kind of hardware handshaking serial cable. It should
be fine for command-line stuff, but might be slower than you’d like if
you use any full-screen programs (like cftp) or are transferring with
YMODEM.

You can try to use a faster baud rate with the following command:

`baud baudRate`

`baudRate` can be 300, 1200, 2400, 4800, 9600, 19200, 38400, 57600,
or 115200. The change will take effect immediately (unless you’re not doing it
from your Apple II itself, in which case it won’t do anything), so you’ll need
to change the setting in ProTERM or Z-Link, too.

If you want to make the change permanent, with the change taking effect on
logout, use:

`baud -d baudRate`

To see the current speed, just type `baud` by itself.

You’ll only be able to use 38400 or 57600 on a IIgs (and not with Z-Link), but
Hugh Hood has come up with [clever ProTERM macros][79] that enable 115200
baud on any Apple II, and A2CLOUD provides them with ProTERM. If you use
115200 baud, you’ll likely drop some characters, especially on an 8-bit Apple
II. One strategy you might want to try is to use a slower speed normally, but
then “upshift” to 115200 for transfers. When you’re done, you can switch back
to the slower speed.

To use Hugh’s macros, choose “Read Globals” from the “Misc” menu, and select
either PT3.IIE.GLOBALS, PT3.IIC.GLOBALS, or PT3.IIGS.GLOBALS, depending on
what computer you’re using. Then, for a IIe or IIc/IIc+, type solid-apple-F,
and it will switch to 115200; you can still switch back to other speeds as
usual from the “Online” window. For a IIgs, type shift-option-H, and it will
switch to 115200 baud; to switch back to other speeds, type option-H to
disable the macro. If you want these macros to automatically be available when
ProTERM starts without having to use the “Read Globals” menu item, delete or
rename PT3.GLOBALS, and then rename the appropriate globals file to
PT3.GLOBALS.


This entry was posted on August 11, 2013 by [ivanx][29].



# A2CLOUD: emulate an Apple II

Though the purpose of A2CLOUD is primarily to extend the functionality of your
actual Apple II, there are also emulators provided in case you want a virtual
Apple II. (If you’re using [Apple II Pi][21], that’s in fact sort of the
point.)

You’ll either need a screen attached to your Raspberry Pi, or
[remote desktop software][5].

For an emulated Apple IIgs, use [GSport][80], a descendent of the KEGS
emulator with significant enhancements by David Schmidt, David Schmenk, Peter
Neubauer, Christopher Mason, and others.  GSport’s features include Uthernet
card emulation, AppleTalk networking, and ImageWriter and Epson printer
emulation. Type `gsport` to if you are at the command prompt and want a
full-screen experience, or double-click GSport on the Raspbian desktop. Press
F4 for the configuration screen, and alt-F4 to exit. Usage instructions are on
the [GSport home page.][80]

For a emulated Apple IIe, type `linapple` to run the [LinApple][81] emulator.
It has some nifty features like built-in software downloading and a built-in
help screen. More information is [here][81].

You can also use GSport’s ancestor, [KEGS][82], by choosing it from the menu
of the Raspbian desktop. (To start the Raspbian desktop, type `startx` or use
[remote desktop software][5].) Usage instructions are [here][83].


This entry was posted on November 29, 2013 by [ivanx][29].



# A2CLOUD: Apple II Pi

David Schmenk has created [Apple II Pi][27], which takes a different approach
than A2CLOUD. With A2CLOUD, the idea is to use your Pi as a peripheral for
your Apple II.

Apple II Pi flips this around: you can use your Apple II’s keyboard, mouse,
joystick, and drives to control your Raspberry Pi, primarily so you can use
the GSport emulator, giving you a virtual souped up Apple II. To get benefit
from this, you’ll need a screen attached to your Pi.

To use Apple II Pi, you’ll need the [Apple II Pi card][84], or a [Raspberry
Pi console cable][50] attached to a Super Serial Card (even in a IIgs) or a
IIc/IIc+ serial port, via [the appropriate serial cable][41] and possibly a
[DE-9 (aka DB-9) male-to-male null modem adapter][85]. The software is
already installed by Raspple II or A2CLOUD (if it doesn’t seem to work, try
updating A2CLOUD by typing `a2cloud-update`).

Once connected, boot the A2CLOUD floppy, and press space on the splash screen.
The first time you do this, it will ask you to choose the slot of your Apple
II Pi card or Super Serial Card. It should then connect immediately; your
Apple II will sound a tone, and any keystrokes you type will show up on the
Raspberry Pi’s screen, rather than your Apple II; on the Raspbian desktop, you
can use your Apple II mouse. And if you want to see your Apple II prompt on
your Raspberry Pi, type `a2term`; prepare to be pleasantly disoriented.

Apple II Pi also lets you go straight into GSport, bypassing the Raspbian
command line, by logging in with username “apple2″ (no password); type alt-F4
(or openApple-solidApple-4 on an Apple II keyboard) to quit. When you do, your
Pi will fully shut down.

Apple II Pi has many more sophisticated abilities, such being able to develop
6502 code on the Raspberry Pi and execute it on the Apple II.  For more info
on how to use it, check out [Dave’s web site][27] and the [Ultimate Apple 2
forums][86].


This entry was posted on November 29, 2013 by [ivanx][29].



# A2CLOUD: release history and notes

A2CLOUD is sorta always in a state of development with tiny tweaks happening
without announcement, often to the installer script rather than any visible
features per se, and those changes and other small details are (somewhat)
documented at the end of [the script itself][87]. But here are the noteworthy
enhancements. To update, type `a2cloud-update`.

### v1.8.1, May 5, 2015

* ADTPro 2.0.1

* Apple II Pi client 1.5


### v1.8.0, March 17, 2015

* compatible with every Raspberry Pi, including Raspberry Pi 2 Model B

* GSport installed for non-Raspberry Pi computers, with option for
  new GS/OS+Spectrum installation, or GSport Internet Starter Kit premade
  image

* Links web browser

* desktop shortcuts and Apple II menu group for emulators and ADTPro
* new `a2cloud-update os` command will perform full Raspple II update,
  including Raspbian OS and NOOBS install manager, A2CLOUD, A2SERVER, and
  Apple II Pi

* many small improvements and fixes to A2CLOUD environment and installer
  script


### v1.7.2, February 7, 2015

* supports Raspberry Pi Model A and A+ (and Pi 2 Model B)

* resolves issues with Raspbian 2015-01-31 (kernel 3.18)


### v1.7.1, August 11, 2014

* A2CLOUD is no longer “beta” on non-Raspberry Pi computers

* A2CLOUD includes KEGS and Linapple on non-Raspberry Pi computers

* A2CLOUD has a faster install script for non-Raspberry Pi computers
  (downloads binaries)

* unbit/unexec/bsq archive tools are installed


### v1.7.0, August 2, 2014

* a2cloud-setup installs Java 8 if not already installed


### v1.6.9, July 24, 2014 (KansasFest)

* ADTPro 2.0.0 (quicker and more reliable transfer; selectable filenames from
  list)

* confirmed working on Raspberry Pi Model B+ (use the USB ports closer to the
  Ethernet port)


### v1.6.8, Apr 7, 2014

* ADTPro 1.3.0

* TTYtter installs properly on non-Pi systems


### v1.6.7, Feb 19, 2014

* A2CLOUD boot floppy contains A2PI client version 1.4

* A2CLOUD boot floppy splash screen provides simple menu for virtual drives,
  Apple II Pi, or BASIC

* A2CLOUD.HDV is now called A2CLOUD.PO (a symbolic link called A2CLOUD.HDV is
  still there for backwards compatibility/habits)

* bug fixes for `cppo`, `shk2image`, and some launcher scripts``


### v1.6.6, Feb 17, 2014

* [beta support for Debian and Ubuntu Linux on non-Pi machines][25]

* ttytter support for color and avoiding non-ASCII characters when running
  under Screen

* opens LXTerminal window by default when starting graphical desktop

* a2cloud-setup installs Screen if not already installed

* a2cloud-setup shows installed and available versions

* a2cloud-setup -y bypasses all prompts


### v1.6.5, Feb 5, 2014

* can use `term mono` and `term color` instead of `term vt100` and `term
  pcansi`


### v1.6.4, Jan 31, 2014

* support for `screen` command to allow switching between multiple terminals
  on Apple II

* `term -f` can be used to force emulation setting even when `term` doesn’t
  want to


### v1.6.3, Jan 23, 2014

* Set TTYtter to always use -ssl mode, which is required by Twitter after
  14-Jan-14.

* Set TTYtter to avoid display of non-ASCII characters on serial port shell

* Set TTYtter to use color ANSI text (for IIgs) if shell is currently set to
  display it

* Provided TTYtter readline module for enhanced input with -readline option

* Added `appleiipi-update` command


### v1.6.2, Jan 19, 2014

* Improved display of non-ASCII characters in Apple II terminal emulation
  programs

* Support for “PC ANSI” colored text and graphics characters , for use with
  Spectrum’s ANSI online display, via new `term` command * Added `sciibin` and
  `unblu` for converting BinSCII and Binary II files

* `baud` command supports 300 baud, in case you *really* want to kick it old
  school


### v1.6.1, Jan 14, 2014

* Added `telnet` and `ttytter` (Twitter client)

* fix for network boot failure when set up under v1.6


### v1.6, Dec 31, 2013

* ADTPro/VSDRIVE 1.2.9 (much faster virtual drives read performance, for the
  price of a short delay on the `vsd1`/`vsd2` commands and a need to type
  `vsdsync` after changing an active virtual drive directly on the Pi; ability
  to run VSDRIVE from ProDOS program launcher, not just BASIC.SYSTEM)

* if A2SERVER is installed, shares the ADTPro disks folder as ADTDISKS on the
  network

* responds to name “raspberrypi.local” as alternative to IP address to Mac OS
  X (and Windows with [Bonjour Print Services][52] installed) computers on
  network


### v1.5.2, Dec 22 2013

* added `dos2pro` command

* Apple II Pi is now installed with GSport emulator and “apple2user” packages

* speedier install by downloading A2CLOUD disk images instead of building them


### v1.5, Dec 1 2013

* Adds IRC and newsreader clients (Irssi and Tin) and, with shortcuts for
  Apple II community (`a2chat` and `a2news` commands)

* adds KEGS and LinApple emulators

* installs Apple II Pi

* easy installation via [Raspple II][28]


### v1.2.3, Nov 2013

* A2PI client version 1.3 added to A2CLOUD disk

* faster install for unar/lsar, nulib2, and cftp (downloads rather than
  compiles)

* console (built-in serial) login disabled, to allow Apple II Pi to have that
  port

* installs xrdp/tightvncserver for remote desktop access from another computer

* adds DSK2FILE image utility to A2CLOUD disk


### v1.0, Sep 2 2013

* first proper release with full documentation, bug fixes, and demo video


### beta, Jul 27, 2013

* internet access and virtual drives for any Apple II via a Raspberry Pi;
  introduced at KansasFest 2013


This entry was posted on December 28, 2013 by [ivanx][29].


# A2CLOUD: other stuff

This is a post for new techniques or features that aren’t fully ready, or
other stuff that doesn’t seem to fit into the main guide. View the
comments to see, or post one of your own.

If this is at the top of a bunch of posts below, you’re reading the A2CLOUD
guide backwards. Click “A2CLOUD” in the menu header above to fix it, or just
go to [http://ivanx.com/a2cloud][1].

<!--
Ivan's comments are included below, and obviously the order of posts is fixed
in this Markdown file.  -Joseph
-->

### ivanx, January 26, 2014 at 4:03 pm

[Alistair Ross][88], who suggested the TTYtter client for Twitter that is now
in A2CLOUD, has introduced me to the Mutt email client. Mutt requires a
hand-built .muttrc file to put in account information, but Alistair has
developed a wizard that will create one for Gmail and other IMAP servers. I
have more familiarity with Alpine (a clone of my first email client from the
early 90’s, Pine), and may include one, or the other, or both, or neither, in
a future A2CLOUD release.

To install Mutt or Alpine, type: 
`sudo apt-get install mutt` (or `alpine`) 
also, get [Alistair’s Mutt configuration wizard][89]


### ivanx, January 26, 2014 at 9:44 pm

[Alistair Ross][88] also suggested the Links web browser. It has a cleaner
layout than Lynx does, devoting more screen space to web content (especially
valuable on the Apple II’s 80×24 display). You get nothing but a blank screen
on startup, but press ESC to get a menu bar, and from there it’s
self-explanatory. On a IIgs with Spectrum’s ANSI online display, you need to
enable its color support from the Settings menu. There’s also a derivative
called “Elinks” which at first glance seems to have more accurate color
support (select “16 colors” from its setup menu). Alistair also suggested w3m,
which I haven’t tried. You can get any of these with: 
`sudo apt-get install links` (or `elinks`, or `w3m`)


### ivanx, January 26, 2014 at 10:08 pm

In [this comp.sys.apple2 thread][90] I discuss various techniques for copying
contents of Apple II floppy images to another disk. In this case, it’s a hard
disk image file used by a CFFA 3000 card, but it could be any kind of “hard
disk”, including a Focus or MicroDrive card, or one provided by VSDRIVE such
as the default 4 MB disk in S2,D1.


### ivanx, February 17, 2014 at 9:43 pm

A2CLOUD can be installed on Debian or Ubuntu Linux (and possibly derivatives).
It has been tried on the 32-bit versions of Debian 7 and Ubuntu Server 13.10.
To install, type: 
```
wget ivanx.com/a2cloud/setup; source setup
```

You can also install it into the [A2SERVER][91] virtual machine with the same
command, or start fresh with the premade [A2SERVER+A2CLOUD][91] virtual
machine. To use a USB-to-serial adapter with the VM, click the USB icon in the
bottom of the window, and select the adapter. If you have two, repeat. If you
want it to be automatically recognized, you can add it under
Settings->Ports->USB.

One particular difference compared with running A2CLOUD on a Pi is
that there is no assignment of USB-to-serial adapters to specific physical USB
ports. Instead, the “upper” USB port is always the adapter that appears first
to the system (aka `/dev/ttyUSB0` or `/dev/ttyUSBupper`), and is used for
shell login. The “lower” USB port is always the adapter that appears second to
the system (aka `/dev/ttyUSB1` or `/dev/ttyUSBlower`), and is used for ADTPro
and virtual drives.

If they are both present at system startup, or connected to a hub which is
then attached to the system, there’s no way of knowing which the system will
see first. If things don’t work, either swap the cables on the Apple II side,
or unplug both adapters and reattach one at a time, starting with the one
connected to the Apple II printer port.

Apple II Pi is not offered as an installation option on non-Pi computers,
though if you’re dedicated, you can compile it yourself [here][92].


This entry was posted on January 26, 2014 by [ivanx][29].


[1]: http://appleii.ivanx.com/a2cloud/ "A2CLOUD"
[2]: #a2cloud-intro
[3]: #a2cloud-what-you-need
[4]: #a2cloud-prepare-your-pi
[5]: #a2cloud-go-headless-optional
[6]: #a2cloud-install-the-software
[7]: #a2cloud-attach-your-cables
[8]: #a2cloud-make-your-boot-disk
[9]: #a2cloud-use-virtual-drives
[10]: #a2cloud-log-in-from-your-apple-ii
[11]: #a2cloud-make-a-floppy-or-image
[12]: #a2cloud-learn-some-unix
[13]: #a2cloud-insert-a-disk-image
[14]: #a2cloud-connect-with-other-people
[15]: #a2cloud-browse-amp-download
[16]: #a2cloud-use-disk-images
[17]: #a2cloud-expand-archives
[18]: #a2cloud-transfer-files
[19]: #a2cloud-increase-serial-port-speed
[20]: #a2cloud-emulate-an-apple-ii
[21]: #a2cloud-apple-ii-pi
[22]: #a2cloud-release-history-and-notes
[23]: #a2cloud-other-stuff
[24]: http://www.raspberrypi.org "Raspberry Pi"
[25]: #ivanx-february-17-2014-at-943-pm "A2CLOUD on non-Pi computers"
[26]: http://appleii.ivanx.com/a2server/ "A2SERVER"
[27]: http://schmenk.is-a-geek.com/wordpress/ "Apple II Pi"
[28]: http://appleii.ivanx.com/rasppleii/ "Raspple II"
[29]: mailto:ivan@ivanx.com "Contact Ivan Drucker"
[30]: #apple-ii-plus-and-unenhanced-iie "A2CLOUD: log in from your Apple II"
[31]: http://www.raspberrypi.org/products/ "Raspberry Pi purchase"
[32]: http://www.amazon.com/s/ref=nb_sb_ss_i_0_4?url=search-alias%3Daps&amp;field-keywords=raspberry+pi+2&amp;sprefix=rasp%2Caps%2C173 "Raspberry Pi 2 Model B search - Amazon"
[33]: http://www.amazon.com/gp/product/B00LPESRUK/ref=as_li_tl?ie=UTF8&amp;camp=1789&amp;creative=390957&amp;creativeASIN=B00LPESRUK&amp;linkCode=as2&amp;tag=ivane-20&amp;linkId=B7F2LQNXIWGYCNYQ "Raspberry Pi 1 model B+ - Amazon"
[34]: http://www.amazon.com/gp/product/B009SQQF9C/ref=as_li_ss_tl?ie=UTF8&amp;camp=1789&amp;creative=390957&amp;creativeASIN=B009SQQF9C&amp;linkCode=as2&amp;tag=ivane-20 "Raspberry Pi 1 model B - Amazon"
[35]: http://www.amazon.com/Raspberry-Pi-Model-A-256MB/dp/B00PEX05TO/ref=sr_1_1?ie=UTF8&amp;qid=1423325260&amp;sr=8-1&amp;keywords=raspberry+pi+model+a%2B "Raspberry Pi 1 model A+ - Amazon"
[36]: http://www.amazon.com/s/?_encoding=UTF8&amp;camp=1789&amp;creative=390957&amp;field-keywords=4gb%20sd%20card&amp;linkCode=ur2&amp;rh=i%3Aaps%2Ck%3A4gb%20sd%20card&amp;sprefix=4gb%20s%2Caps&amp;tag=ivane-20&amp;url=search-alias%3Daps "SD card"
[37]: http://www.amazon.com/s/?_encoding=UTF8&amp;camp=1789&amp;creative=390957&amp;field-keywords=8gb%20sd%20card&amp;linkCode=ur2&amp;rh=i%3Aaps%2Ck%3A4gb%20sd%20card&amp;sprefix=4gb%20s%2Caps&amp;tag=ivane-20&amp;url=search-alias%3Daps "8 GB SD card at Amazon"
[38]: http://www.amazon.com/gp/product/B00A9PO5AM/ref=as_li_ss_tl?ie=UTF8&amp;camp=1789&amp;creative=390957&amp;creativeASIN=B00A9PO5AM&amp;linkCode=as2&amp;tag=ivane-20
[39]: http://www.amazon.com/s/?_encoding=UTF8&amp;camp=1789&amp;creative=390957&amp;field-keywords=ethernet%20cable&amp;linkCode=ur2&amp;rh=i%3Aaps%2Ck%3Aethernet%20cable&amp;sprefix=ethernet%2Caps&amp;tag=ivane-20&amp;url=search-alias%3Daps "ethernet cable"
[40]: http://ivanx.com/raspberrypi/raspberrypi_wifi.html "Raspberry Pi WiFi"
[41]: http://retrofloppy.com/products.html "Apple II null modem serial cable"
[42]: http://adtpro.sourceforge.net/connectionsserial.html "ADTPro serial connections"
[43]: http://www.amazon.com/gp/product/B0007T27H8/ref=as_li_ss_tl?ie=UTF8&amp;camp=1789&amp;creative=390957&amp;creativeASIN=B0007T27H8&amp;linkCode=as2&amp;tag=ivane-20 "TRENDnet TU-S9 USB-to-serial adapter"
[44]: http://www.ebay.com/sch/i.html?_nkw=apple+super+serial+card "eBay - Apple Super Serial Card"
[45]: http://www.amazon.com/gp/product/B006T9B6R2/ref=as_li_ss_tl?ie=UTF8&amp;camp=1789&amp;creative=390957&amp;creativeASIN=B006T9B6R2&amp;linkCode=as2&amp;tag=ivane-20 "SD card reader"
[46]: http://www.amazon.com/s/?_encoding=UTF8&amp;camp=1789&amp;creative=390957&amp;field-keywords=usb%20keyboard&amp;linkCode=ur2&amp;rh=i%3Aaps%2Ck%3Ausb%20keyboard&amp;tag=ivane-20&amp;url=search-alias%3Daps "USB keyboard"
[47]: http://www.amazon.com/s/?_encoding=UTF8&amp;camp=1789&amp;creative=390957&amp;field-keywords=usb%20mouse&amp;linkCode=ur2&amp;rh=i%3Aaps%2Ck%3Ausb%20mouse&amp;tag=ivane-20&amp;url=search-alias%3Daps "USB mouse"
[48]: http://www.amazon.com/s/?_encoding=UTF8&amp;camp=1789&amp;creative=390957&amp;field-keywords=powered%20usb%20hub&amp;linkCode=ur2&amp;rh=i%3Aaps%2Ck%3Apowered%20usb%20hub&amp;tag=ivane-20&amp;url=search-alias%3Daps "powered USB hub"
[49]: http://ultimateapple2.com "Apple II Pi card from Ultimate Apple 2"
[50]: http://www.pridopia.co.uk/pi-232r1-db9.html "Raspberry Pi console cable"
[51]: http://www.amazon.com/s/ref=nb_sb_noss?url=search-alias%3Delectronics&amp;field-keywords=db9+male+female+null+modem+adapter+-usb&amp;rh=n%3A172282%2Ck%3Adb9+male+female+null+modem+adapter+-usb "DE-9 male-to-female null modem adapters at Amazon"
[51]: https://www.sdcard.org/downloads/formatter_4/
[52]: http://support.apple.com/kb/dl999
[53]: http://www.chiark.greenend.org.uk/~sgtatham/putty/
[54]: http://ivanx.com/raspberrypi/files/PiFinder.zip
[55]: http://www.advanced-ip-scanner.com/
[56]: https://itunes.apple.com/us/app/microsoft-remote-desktop/id715768417?mt=12 "Microsoft Remote Desktop for Mac"
[57]: http://elinux.org/RPi_VNC_Server "configure TightVNCServer"
[58]: http://elinux.org/Configuring_a_Static_IP_address_on_your_Raspberry_Pi "Raspberry Pi static IP address"
[59]: http://adtpro.sourceforge.net/vdrive.html "VSDRIVE"
[60]: http://adtpro.sourceforge.net/ "ADTPro"
[61]: http://appleii.ivanx.com/a2cloud/files/A2CLOUD.DSK "140K A2CLOUD boot disk"
[62]: http://appleii.ivanx.com/a2cloud/files/A2CLOUD.HDV "800K A2CLOUD boot disk"
[63]: http://apple2.info/wiki/index.php?title=DOS#Commands_quick_reference "ProDOS and DOS 3.3 commands"
[64]: http://www.apple2scans.net/?p=33 "BASIC Programming with ProDOS"
[65]: http://lostclassics.apple2.info/announcements/19/proterm-a2/ "ProTERM"
[66]: http://www.wannop.info/speccie/Site/Speccies_Home_Pages.html "Spectrum for Apple IIgs"
[67]: http://www.bartbania.com/index.php/linux-screen/ "using Screen"
[68]: http://www.wannop.info/speccie/Site/Download_Centre.html "Spectrum download"
[69]: http://macgui.com/downloads/?file_id=24237 "Mac GUI Vault: Kermit 3.87"
[70]: https://groups.google.com/d/msg/comp.sys.apple2/8yUpfbAgdx0/oVwep6fMsTYJ "VT-100 on Apple II Plus and unenhanced IIe"
[71]: http://www.irchelp.org/ "IRC Help"
[72]: http://www.irssi.org/documentation/ "Irssi Documentation"
[73]: http://www.floodgap.com/software/ttytter/ "TTYtter"
[74]: #ivanx-january-26-2014-at-403-pm "email on A2CLOUD"
[75]: http://elinux.org/RPi_Chromium "Chromium (Google Chrome for Raspberry Pi)"
[76]: http://elinux.org/RPi_IceWeasel "Iceweasel (Firefox for Raspbian)"
[77]: #ivanx-january-26-2014-at-944-pm
[78]: http://unarchiver.c3.cx/formats "The Unarchiver supported formats"
[79]: https://groups.google.com/forum/#!searchin/comp.sys.apple2/115200$20hugh "Hugh Hood's 115200 baud ProTERM macros"
[80]: http://gsport.sourceforge.net/ "GSport"
[81]: http://linapple.sourceforge.net/ "LinApple"
[82]: http://kegs.sourceforge.net/ "KEGS"
[83]: http://kegs.sourceforge.net/README.kegs.txt "KEGS instructions"
[84]: https://ultimateapple2.com/ "Apple II Pi card"
[85]: http://www.amazon.com/s/?_encoding=UTF8&amp;camp=1789&amp;creative=390957&amp;field-keywords=db9%20male%20null%20modem%20adapter%20-usb%20-female&amp;linkCode=ur2&amp;rh=n%3A172282%2Ck%3Adb9%20male%20null%20modem%20adapter%20-usb%20-female&amp;tag=ivane-20&amp;url=search-alias%3Delectronics "DE-9 male-to-male null modem adapter"
[86]: https://www.ultimateapple2.com/forums/ "Ultimate Apple 2 forums"
[87]: http://appleii.ivanx.com/a2cloud/setup/setup.txt "A2CLOUD setup script"
[88]: http://twitter.com/AJRossNZ
[89]: http://pastebin.com/Mawvd2pZ
[90]: https://groups.google.com/forum/#!msg/comp.sys.apple2/VGvddYfn_wk/eFrQ-u3qBkUJ
[91]: http://appleii.ivanx.com/a2server/a2server_virtualbox.html
[92]: https://github.com/dschmenk/apple2pi "Apple II Pi source code"

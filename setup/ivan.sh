#! /bin/bash
# vim: set tabstop=4 shiftwidth=4 noexpandtab filetype=sh:

version="2.9.0"
adtProVersion="2.0.1"
a2cBinaryURL="http://blocksfree.com/downloads"

# Find the path of our source directory
a2cSource="$( dirname "${BASH_SOURCE[0]}" )/.."
pushd $a2cSource >/dev/null
a2cSource="$PWD"
popd >/dev/null
if [[ ! -f "$a2cSource/.a2cloud_source" ]]; then
	printf "\na2cloud: cannot find a2cloud source directory in $a2cSource.\n\n"
	exit 1
fi

useExternalURL=1
[[ $A2CLOUD_NO_EXTERNAL ]] && useExternalURL=

# Make sure ras2_{os,arch} get set
. "$a2cSource/scripts/system_ident" -q

isRpi=
if [[ $ras2_os == rpi-* ]]; then
	isRpi=1
	me="Pi"
	fullme="Raspberry Pi"
else
	me="computer"
	fullme="computer"
fi

isSystemd=
isSysVInit=
# If you really want something else, *you* maintain it!
if command -v systemctl > /dev/null && systemctl | grep -q '\-\.mount'; then
	isSystemd=1
elif [[ -f /etc/inittab ]]; then
	isSysVInit=1
fi

if [[ -f /usr/local/etc/A2CLOUD-version ]]; then
	installedVersion="$(cat /usr/local/etc/A2CLOUD-version)"
	if [[ $installedVersion != *.*.* ]]; then
		installedVersion="${installedVersion:0:1}.${installedVersion:1:1}.${installedVersion:2}"
	fi
fi
echo "A2CLOUD version available: $version"
echo "A2CLOUD version installed: ${installedVersion:-None}"

### A2CLOUD: Process command line args
buildA2CloudDisk=
noPicoPkg=
skipRepoUpdate=
restartPrompt=
autoAnswerYes=
updateRasppleII=
slot6=
noSetGroups=
while [[ $1 ]]; do
	if [[ $1 == "-b" ]]; then
		shift
		buildA2CloudDisk=1
	elif [[ $1 == "-c" ]]; then
		shift
		noPicoPkg=1
	elif [[ $1 == "-r" ]]; then
		shift
		skipRepoUpdate="-r"
	elif [[ $1 == "-s" ]]; then
		shift
		restartPrompt=1
	elif [[ $1 == "-y" ]]; then
		shift
		autoAnswerYes="-y"
	elif [[ $1 == "-6" ]]; then
		shift
		slot6=1
	elif [[ $1 == "-v" ]]; then
		shift
		# Version was already printed
		[[ $0 == "-bash" ]] && return 1 || exit 1
	elif [[ $1 == "noSetGroups" ]]; then
		shift
		noSetGroups=1
	elif [[ $1 ]]; then
		echo "options:"
		echo "-v: display installed and available versions, then exit"
		echo "-y: auto-answer yes to all prompts"
		echo "-r: don't update package lists"
		echo "-s: prompt for restart after installation"
		echo "-6: put blank 140K disk images in GSport slot 6"
		echo "-b: build A2CLOUD disks, rather than downloading premade images"
		echo "-c: compile non-package items, rather than downloading picopkg files"
		[[ $0 == "-bash" ]] && return 1 || exit 1
	fi
done

echo
echo "Your $fullme will be set up for A2CLOUD, providing you"
echo "  with mass storage and online access for your Apple II!"
echo
echo "If you already have A2CLOUD installed, you will be updated to the"
echo "  latest version. Check out http://ivanx.com/a2cloud for details."
echo
echo "Full installation may take an hour or longer. Updates are usually"
echo "  much quicker. Type 'a2cloud-setup -h' for installation options."
echo
echo "Some actions will be performed as the root user."
if [[ ! $autoAnswerYes ]]; then
	echo
	echo -n "Continue? "
	read
	if [[ ${REPLY:0:1} != "Y" && ${REPLY:0:1} != "y" ]]; then
		[[ $0 == "-bash" ]] && return 2 || exit 2
	fi
fi

installAllFeatures=1 # as of 1.9.0

if [[ $installAllFeatures ]]; then
	installADTPro=1
	createBootDisk=1
	setupSerialPortLogin=1
	installEmulators=1
else
	### Q: Install ADTPro?
	installADTPro=
	echo
	echo -n "Install ADTPro server, for virtual drives and floppy disk transfers"
	if ! hash X 2> /dev/null; then
		echo
		echo -n "(the X Window System and LXDE desktop environment will be installed)"
	fi
	echo -n "? "
	read
	[[ ${REPLY:0:1} == "Y" || ${REPLY:0:1} == "y" ]] && installADTPro=1

	### Q: Create disk images?
	createBootDisk=
	newImageName=
	imageSize=
	if [[ $installADTPro ]]; then

		echo
		echo -n "Do you want to create A2CLOUD 140K and 800K boot disk images? "
		read
		if [[ ${REPLY:0:1} == "Y" || ${REPLY:0:1} == "y" ]]; then
			createBootDisk=1
		fi

		if [[ ! -f /usr/local/adtpro/disks/Virtual.po || ( -f /usr/local/adtpro/adtpro.sh && -f /usr/local/adtpro/disks/Virtual.po && $(sha1sum /usr/local/adtpro/disks/Virtual.po | cut -f 1 -d ' ') == "a209a8b3a485c95c57bc691a8a58867a6c0ec628" ) ]]; then
			while (( 1 )); do
				echo
				echo "The default blank disk in S2,D1 will be 800K. If you want a different size,"
				echo -n "  enter it in K (larger is slower when writing; max 8192): "
				read
				if (( ${REPLY}0 >= 1400 )); then
					imageSize=$REPLY
					echo -n "Enter new image file name: "
					read
					if [[ $REPLY ]]; then
						reply="$REPLY"
						[[ $(tr [:lower:] [:upper:] <<< ${reply:(-3)}) != ".PO" ]] && reply="$REPLY.PO"
						if [[ ! -f /usr/local/adtpro/disks/"$reply" ]]; then
							newImageName="$reply"
							prodosVolName='0'
							# test ProDOS name legality
							while [[ ${#prodosVolName} -gt 15 || ! $(grep ^[A-Z][0-9A-Z\.]*$ <<< $prodosVolName) ]]; do
								echo -n "Enter new image ProDOS volume name (or return for 'UNTITLED'): "
								read
								[[ $REPLY ]] && prodosVolName="$REPLY" || prodosVolName="UNTITLED"
								prodosVolName=$(tr [:lower:] [:upper:] <<< $prodosVolName)
							done
							break
						else
							echo "A2CLOUD: Disk image already exists. Not creating."
						fi
					fi
				else
					break
				fi
			done
		fi
	fi

	### Q: Install serial port login?
	setupSerialPortLogin=
	echo
	echo -n "Do you want to set up your $me for serial port login? "
	read
	[[ ${REPLY:0:1} == "Y" || ${REPLY:0:1} == "y" ]] && setupSerialPortLogin=1

	### Q: Install emulators?
	installEmulators=
	echo
	echo -n "Install Apple IIgs and IIe emulators? "
	read
	[[ ${REPLY:0:1} == "Y" || ${REPLY:0:1} == "y" ]] && installEmulators=1

fi

echo
userPw=$(sudo grep "^$USER" /etc/shadow | cut -f 2 -d ':')
[[ $userPw == "$(echo 'apple2' | perl -e '$_ = <STDIN>; chomp; print crypt($_, $ARGV[0])' "${userPw%"${userPw#\$*\$*\$}"}")" ]] && isApple2Pw=1 || isApple2Pw=
[[ $userPw == "$(echo 'raspberry' | perl -e '$_ = <STDIN>; chomp; print crypt($_, $ARGV[0])' "${userPw%"${userPw#\$*\$*\$}"}")" ]] && isRaspberryPw=1 || isRaspberryPw=

if [[ ! $isApple2Pw && ! -f /usr/local/etc/A2CLOUD-version ]]; then
	if [[ ! $autoAnswerYes ]]; then
		echo "To make A2CLOUD work smoothly, you are recommended"
		echo "to change your password to 'apple2'."
		echo
		echo -n "Do you want to change the password for user '$USER' to 'apple2' now? "
		read
	fi
	if [[ $autoAnswerYes || ${REPLY:0:1} == "Y" || ${REPLY:0:1} == "y" ]]; then
		echo "A2CLOUD: changing password for user '$USER' to 'apple2'..."
		echo "$USER:apple2" | sudo chpasswd
		isApple2Pw=1
	fi
fi
thePassword="your password"
[[ $isApple2Pw ]] && thePassword="'apple2'"
[[ $isRaspberryPw ]] && thePassword="'raspberry'"


echo
echo "During this installation, enter ${thePassword}"
echo "if prompted for passwords."
echo
if [[ ! $autoAnswerYes ]]; then
	echo -n "Press return to continue..."
	read
fi


origDir="$PWD"
rm -rf /tmp/a2cloud-install &> /dev/null
mkdir -p /tmp/a2cloud-install
cd /tmp/a2cloud-install

### A2CLOUD: Update apt package lists
echo
if [[ ! $skipRepoUpdate ]]; then
	echo "A2CLOUD: Updating package lists..."
	sudo apt-get -y update > /dev/null
else
	echo "A2CLOUD: Not updating package lists..."
fi


# general commands and configuration

### A2CLOUD: Install udev trigger
echo "A2CLOUD: Adding udev trigger to /etc/rc.local..."
grep udevadm /etc/rc.local > /dev/null || sudo sed -i 's/^exit 0$/[ -e \/dev\/ttyUSBupper ] \&\& ! [ -f \/tmp\/udev-ttyUSBupper-added ] \&\& udevadm trigger --action=change\n[ -e \/dev\/ttyUSBlower ] \&\& ! [ -f \/tmp\/udev-ttyUSBlower-added ] \&\& udevadm trigger --action=change\n\nexit 0/' /etc/rc.local

a2cTools="dopo cppo"
a2cHelp="a2cloud-help.txt"
a2cConfScripts="a2cloud-aliases a2cloudrc"
a2cToolDir="$a2cSource/setup"

for _tool in $a2cTools; do
	sudo install -m 755 "$a2cToolDir/$_tool" "/usr/local/bin/$_tool"
done
for _help in $a2cHelp; do
	sudo install -m 644 "$a2cToolDir/$_help" "/usr/local/etc/$_help"
done
for _confscript in $a2cConfScripts; do
	sudo install -m 755 "$a2cToolDir/$_confscript" "/usr/local/etc/$_confscript"
done

### A2CLOUD: Install aliases and make bash use them by default
echo "A2CLOUD: Setting up login script..."
sudo sed -i "s/a2cloud-aliases/a2cloudrc/" /etc/bash.bashrc
sudo sed -i '/ttyUSB/d' /etc/bash.bashrc
if ! grep a2cloudrc /etc/bash.bashrc &>/dev/null; then
	echo "source /usr/local/etc/a2cloudrc" | sudo tee -a /etc/bash.bashrc >/dev/null
fi
source /usr/local/etc/a2cloudrc

### A2CLOUD: Install MOTD
# FIXME: We have *three* MOTD files in the A2CLOUD tree.  We should clean
# this up at some point.
echo "A2CLOUD: Setting up motd..."
if [[ $(grep Raspple /etc/motd) ]]; then
	sudo install -o root -g root -m 644 "$a2cSource/setup/motd-rasppleii.txt" /etc/motd
elif [[ $(grep A2SERVER /etc/motd) ]]; then
	sudo install -o root -g root -m 644 "$a2cSource/setup/motd-vm.txt" /etc/motd
else
	sudo install -o root -g root -m 644 "$a2cSource/setup/motd.txt" /etc/motd
fi

if lspci 2> /dev/null | grep -q VirtualBox; then
	### A2CLOUD: Disable screen blanking on vbox
	echo "A2CLOUD: Disabling VirtualBox console screen blanking..."
	sudo sed -i 's/^BLANK_DPMS=off/BLANK_DPMS=on/' /etc/kbd/config
	sudo sed -i 's/^BLANK_TIME=[^0].$/BLANK_TIME=0/' /etc/kbd/config
	sudo /etc/init.d/kbd restart &> /dev/null
	sudo /etc/init.d/console-setup restart &> /dev/null
fi

### A2CLOUD: Record the version we're installing
echo "A2CLOUD: Saving installer version..."
echo "$version" | sudo tee /usr/local/etc/A2CLOUD-version &> /dev/null

### A2CLOUD: Install avahi (Bonjour)
if ! dpkg-query -l avahi-daemon &> /dev/null || ! dpkg-query -l libnss-mdns &> /dev/null; then
	echo "A2CLOUD: Installing avahi-daemon (mDNS)..."
	sudo apt-get -y install avahi-daemon &> /dev/null
	sudo apt-get -y clean
	sudo sed -i 's/^\(hosts.*\)$/\1 mdns/' /etc/nsswitch.conf
else
	echo "A2CLOUD: avahi-daemon (mDNS) is already installed."
fi

### A2CLOUD: Install "at"
if ! hash at 2> /dev/null; then
	echo 'A2CLOUD: Installing "at"...'
	sudo apt-get -y install at
	sudo apt-get clean
else
	echo 'A2CLOUD: "at" is already installed.'
fi

### A2CLOUD: Install xdg-utils (FreeDesktop menus/icon tools)
if ! hash xdg-desktop-menu 2> /dev/null; then
	echo "A2CLOUD: Installing xdg-utils..."
	sudo apt-get -y install xdg-utils
	sudo apt-get clean
else
	echo "A2CLOUD: xdg-utils are already installed."
fi

if [[ $installADTPro ]]; then

	### ADTPro: Make sure we have enough free space
	freeSpace=$(df / | tail -1 | awk '{ print $4 }')
	java -version &> /dev/null
	if (( $? == 127 && $freeSpace < 350000 )); then
		echo "You do not have enough free space to install"
		echo "Java, which is needed for ADTPro server."
		if [[ $isRpi ]]; then
			echo "If you haven't"
			echo "yet expanded the file system to use the full capacity"
			echo "of your SD card, type \"sudo raspi-config\" and do that."
		else
			echo "Free up some space."
		fi
		echo "Then try this installer again."
		echo
		[[ $0 == "-bash" ]] && return 3 || exit 3
	fi

	### ADTPro: Install X and LXDE
	###      Well, you need _something_ for ADTPro, and LXDE is the default on Raspbian
	if ! hash X 2> /dev/null; then
		echo "A2CLOUD: Installing X Window System and LXDE..."
		sudo apt-get -y install xorg lxde
		sudo apt-get -y clean
	else
		echo "A2CLOUD: X Window System and LXDE are already installed."
	fi

	### A2CLOUD: prevent automatically running LXDE at startup
	if [[ -n "$isSystemd" ]]; then
		sudo systemctl set-default multi-user.target &> /dev/null
	elif [[ -n "$isSysVInit" ]]; then
		sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*$/GRUB_CMDLINE_LINUX_DEFAULT="text"/' /etc/default/grub
		sudo update-grub
	else
		echo "A2CLOUD: can't disable GUI at startup: unrecognized init system."
	fi

	# install or update java
	javaVersion=$(java -version 2>&1)
	if [[ ( $? -eq 127 ) || ( $(head -1 <<< "$javaVersion" | cut -f 2 -d '.') -lt 8 ) ]]; then
		echo "A2CLOUD: Installing Java (takes a while)..."
		if [[ $isRpi ]]; then
			if [[ $(apt-cache search '^oracle-java8-jdk$') ]]; then
				sudo apt-get -y install oracle-java8-jdk
			else
				sudo apt-get -y install oracle-java7-jdk
			fi
			sudo apt-get -y clean
		else
			# from http://www.webupd8.org/2012/06/how-to-install-oracle-java-7-in-debian.html
			if ! grep -q webupd8team /etc/apt/sources.list; then
				{
					echo;
					echo "# Oracle Java JDK";
					echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu precise main";
					echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu precise main";
				} | sudo tee -a /etc/apt/sources.list > /dev/null
			fi
			sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
			sudo apt-get -y update
			echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
			sudo apt-get -y install oracle-java8-installer
			sudo apt-get -y clean
		fi
		source /usr/local/etc/a2cloudrc
	else
		echo "A2CLOUD: Java is already installed."
	fi

	updateADTPro=
	# check if update needed
	if [ -f /usr/local/adtpro/lib/ADTPro-* ]; then
		if [[ $(ls -1 /usr/local/adtpro/lib/ADTPro-*.jar | cut -f 6 -d '/') != "ADTPro-$adtProVersion.jar" ]]; then
			echo
			echo "ADTPro server should be updated. If you have made any customizations"
			echo "  to any of the files in /usr/local/adtpro, other than the 'disks' folder,"
			echo "  they will be lost. If you don't know what this means, then you don't"
			echo -n "  need to worry. Update now? "
			read
			if [[ ${REPLY:0:1} == "Y" || ${REPLY:0:1} == "y" ]]; then
				updateADTPro=1
				echo "A2CLOUD: removing old version of ADTPro server..."
				sudo pkill -f ADTPro
				sudo rm /usr/local/adtpro/disks/ADTPRO*.DSK &> /dev/null
				sudo rm /usr/local/adtpro/disks/ADTPRO*.PO &> /dev/null
				sudo rm /usr/local/adtpro/disks/VDRIVE*.DSK &> /dev/null
				sudo rm -r /tmp/a2cloud-install/disks &> /dev/null
				sudo mv /usr/local/adtpro/disks /tmp/a2cloud-install
				sudo rm -rf /usr/local/adtpro/ac.bat \
					/usr/local/adtpro/ac.sh \
					/usr/local/adtpro/adtpro.bat \
					/usr/local/adtpro/adtpro.cmd \
					/usr/local/adtpro/ADTPro.html \
					/usr/local/adtpro/adtpro.sh \
					/usr/local/adtpro/lib \
					/usr/local/adtpro/LICENSE \
					/usr/local/adtpro/README \
					&>/dev/null
			fi
		else
			echo "A2CLOUD: ADTPro server does not need updating."
		fi
	fi

	### ADTPro: Install ADTPro
	if [[ ! -f /usr/local/adtpro/adtpro.sh || ! -f /usr/local/adtpro/ADTPro.html ]]; then
		echo "A2CLOUD: installing ADTPro server..."
		sudo pkill -f ADTPro
		wget -qO /tmp/a2cloud-install/adtpro.tar.gz downloads.sourceforge.net/project/adtpro/adtpro/ADTPro-$adtProVersion/ADTPro-$adtProVersion.tar.gz
		sudo mkdir -p /usr/local/adtpro
		sudo tar --strip-components=1 -C /usr/local/adtpro -zxf /tmp/a2cloud-install/adtpro.tar.gz
		sudo chmod -R ugo+w /usr/local/adtpro
		sudo ln -s /usr/local/adtpro/lib/ADTPro*jar /usr/local/adtpro/lib/ADTPro.jar
		sudo ln -s /usr/local/adtpro/lib/AppleCommander/AppleCommander*ac.jar /usr/local/adtpro/lib/AppleCommander/AppleCommander-ac.jar
		echo "sudo /usr/local/adtpro/adtpro.sh \$@" | sudo tee /usr/local/bin/adtpro.sh > /dev/null
		sudo chmod ugo+x /usr/local/bin/adtpro.sh
		sudo usermod -a -G uucp $USER
		sudo usermod -a -G uucp root
	else
		echo "A2CLOUD: ADTPro server is already installed."
	fi

	### ADTPro: Install AppleCommander
	if [[ ! -f /usr/local/adtpro/lib/AppleCommander/AppleCommander-1.3.5.13id-ac.jar ]]; then
		echo "A2CLOUD: Installing AppleCommander-1.3.5.13id..."
		sudo mkdir -p /usr/local/adtpro/lib/AppleCommander
		sudo wget -qO /usr/local/adtpro/lib/AppleCommander/AppleCommander-1.3.5.13id-ac.jar http://downloads.sourceforge.net/project/applecommander/AppleCommander%20-%20Interim/testcase/AppleCommander-1.3.5.13id-ac.jar
		rm /usr/local/adtpro/lib/AppleCommander/AppleCommander-ac.jar &> /dev/null
		ln -s AppleCommander-1.3.5.13id-ac.jar /usr/local/adtpro/lib/AppleCommander/AppleCommander-ac.jar
	else
		echo "A2CLOUD: AppleCommander-1.3.5.13id is already installed."
	fi

	### ADTPro: Install our modified adtpro.sh
	echo "A2CLOUD: Setting up customized adtpro.sh..."
	sudo install -o root -g root -m 755 ${a2cSource}/setup/adtpro.sh /usr/local/bin/adtpro.sh

	### ADTPro: Replace A2CLOUD's disks with the ones ...
	###     FIXME: where are these created/downloaded to move?
	if [[ $updateADTPro ]]; then
		echo "A2CLOUD: Replacing disks folder..."
		sudo mv /tmp/a2cloud-install/disks/* /usr/local/adtpro/disks
		sudo rmdir /tmp/a2cloud-install/disks
	fi

	### ADTPro: Install rxtx
	if [[ ! -f /usr/lib/jni/librxtxSerial.so ]]; then
		echo "A2CLOUD: Installing serial port libraries..."
		sudo apt-get -y install librxtx-java
		sudo apt-get -y clean
	else
		echo "A2CLOUD: Serial port libraries are already installed."
	fi
	[[ ! -f /usr/lib/RXTXcomm.jar ]] && sudo ln -s /usr/share/java/RXTXcomm.jar /usr/lib &> /dev/null
	[[ ! -d /usr/local/adtpro/lib/rxtx/rxtx-2.2pre2-local/arm ]] && ln -s /usr/lib/jni /usr/local/adtpro/lib/rxtx/rxtx-2.2pre2-local/arm &> /dev/null

	if ! hash xvfb-run 2> /dev/null; then
		echo "A2CLOUD: Installing xvfb for headless operation..."
		sudo apt-get -y install xvfb
		sudo apt-get -y clean
	else
		echo "A2CLOUD: xvfb is already installed."
	fi

	### A2CLOUD: Enable netatalk sharing for A2CLOUD if it's installed
	if hash afpd 2> /dev/null; then # A2SERVER/netatalk installed
		if [[ -d /srv/A2SERVER ]]; then
			sharePath=/srv/A2SERVER
		else
			sharePath=/media/A2SHARED
		fi

		if [[ ! -d ${sharePath}/ADTDISKS || ! $(grep ADTDISKS /usr/local/etc/netatalk/AppleVolumes.default) ]]; then
			echo "A2CLOUD: Setting up /usr/local/adtpro/disks for Apple file sharing..."
			if [[ ! -d ${sharePath}/ADTDISKS ]]; then
				ln -s /usr/local/adtpro/disks ${sharePath}/ADTDISKS 2> /dev/null
			fi
			if [[ $sharePath == "/srv/A2SERVER" ]] && grep '/media/A2SHARED/ADTDISKS' /usr/local/etc/netatalk/AppleVolumes.default; then
				sudo sed -i 's@/media/A2SHARED/ADTDISKS@/srv/A2SERVER/ADTDISKS@' /usr/local/etc/netatalk/AppleVolumes.default
			fi
			if [[ ! $(grep ADTDISKS /usr/local/etc/netatalk/AppleVolumes.default) ]]; then
				sudo sed -i 's@^# End of File@${sharePath}/ADTDISKS ADTDISKS ea:ad\n\n# End of File@' /usr/local/etc/netatalk/AppleVolumes.default
			fi
			sudo /etc/init.d/netatalk restart
		else
			echo "A2CLOUD: /usr/local/adtpro/disks is already set up for Apple file sharing."
		fi

		### A2CLOUD: Enable samba sharing for A2CLOUD, if A2SERVER installed it
		if [[ $sharePath == "/srv/A2SERVER" ]] && grep '/media/A2SHARED/ADTDISKS' /etc/samba/smb.conf; then
			sudo sed -i 's@/media/A2SHARED/ADTDISKS@/srv/A2SERVER/ADTDISKS@' /etc/samba/smb.conf
		fi
		if grep -q "$sharePath" /etc/samba/smb.conf 2> /dev/null; then
			# SMB already enabled by A2SERVER
			if grep -q ADTDISKS /etc/samba/smb.conf 2> /dev/null; then
				echo "A2CLOUD: /usr/local/adtpro/disks is already set up for Windows file sharing."
			else
				echo "A2CLOUD: Setting up /usr/local/adtpro/disks for Windows file sharing..."
				echo "[ADTDISKS]" | sudo tee -a /etc/samba/smb.conf > /dev/null
				echo "    path = ${sharePath}/ADTDISKS" | sudo tee -a /etc/samba/smb.conf > /dev/null
				echo "    browsable = yes" | sudo tee -a /etc/samba/smb.conf > /dev/null
				echo "    guest ok = yes" | sudo tee -a /etc/samba/smb.conf > /dev/null
				echo "    read only = no" | sudo tee -a /etc/samba/smb.conf > /dev/null
				echo "    create mask = 0666" | sudo tee -a /etc/samba/smb.conf > /dev/null
				echo "    force user = $(whoami)" | sudo tee -a /etc/samba/smb.conf > /dev/null
			fi
		else
			echo "A2CLOUD: Windows file sharing not in use."
		fi
	fi

	### A2CLOUD: Install various shell scripts
	echo "A2CLOUD: Setting up adtpro-start command..."
	sudo install -o root -g root -m 755 "$a2cSource/setup/adtpro-start" /usr/local/bin/adtpro-start

	echo "A2CLOUD: Setting up vsd1/vsd2 commands..."
	sudo install -o root -g root -m 755 "$a2cSource/setup/vsd" /usr/local/bin/vsd

	echo "A2CLOUD: Setting up acmd command..."
	sudo install -o root -g root -m 755 "$a2cSource/setup/acmd" /usr/local/bin/acmd

	echo "A2CLOUD: Setting up mkpo command..."
	sudo install -o root -g root -m 755 "$a2cSource/setup/mkpo" /usr/local/bin/mkpo

	echo "A2CLOUD: Setting up dos2pro command..."
	sudo install -o root -g root -m 755 "$a2cSource/setup/dos2pro" /usr/local/bin/dos2pro

fi

### ADTPro: Install xrdp
if hash X 2> /dev/null; then
	if ! dpkg-query -l xrdp &> /dev/null; then
		echo "A2CLOUD: Installing xrdp/tightvncserver..."
		sudo apt-get -y install xrdp
		sudo apt-get -y clean
	else
		echo "A2CLOUD: xrdp/tightvncserver is already installed."
	fi
else
	echo "A2CLOUD: X11 not found; not installing xrdp/tightvncserver."
fi

### A2CLOUD: Install serial port rules/scripts
echo "A2CLOUD: Setting up USB port serial adapter handler..."
sudo install -o root -g root -m 755 "$a2cSource/setup/ttyusbhandler" /usr/local/sbin/ttyusbhandler

if [[ ! -f /etc/udev/rules.d/50-usb.rules ]]; then
	echo "A2CLOUD: Creating device rules for USB ports..."
	udevLines=
	if [[ $isRpi ]]; then
		# assign ttyUSBupper, or ttyUSBupper_hubXX, for shell usb-to-serial adapter
		# assign ttyUSBlower, or ttyUSBlower_hubXX, for ADTPro usb-to-serial adapter
		# (A/A+ direct attach is always ttyUSBlower;
		#   hub attached to A/A+ will be ttyUSBupper on port 2, and ttyUSBlower on port 3)
		udevLines+='KERNEL=="ttyUSB*", KERNELS=="1-1:1.0", SYMLINK+="ttyUSBlower", RUN+="/usr/local/sbin/ttyusbhandler add ttyUSBlower"\n'
		udevLines+='ACTION=="remove",  ENV{DEVPATH}=="*1-1:1.0*", RUN+="/usr/local/sbin/ttyusbhandler remove ttyUSBlower"\n'
		udevLines+='KERNEL=="ttyUSB*", KERNELS=="1-1.2:1.0", SYMLINK+="ttyUSBupper", RUN+="/usr/local/sbin/ttyusbhandler add ttyUSBupper"\n'
		udevLines+='ACTION=="remove",  ENV{DEVPATH}=="*1-1.2:1.0*", RUN+="/usr/local/sbin/ttyusbhandler remove ttyUSBupper"\n'
		udevLines+='KERNEL=="ttyUSB*", KERNELS=="1-1.3:1.0", SYMLINK+="ttyUSBlower", RUN+="/usr/local/sbin/ttyusbhandler add ttyUSBlower"\n'
		udevLines+='ACTION=="remove",  ENV{DEVPATH}=="*1-1.3:1.0*", RUN+="/usr/local/sbin/ttyusbhandler remove ttyUSBlower"\n'
		for i in {1..25}; do
			ii=$(printf %02d $i)
			udevLines+='KERNEL=="ttyUSB*", KERNELS=="1-1.2.'$i':1.0", SYMLINK+="ttyUSBupper_hub'$ii'", RUN+="/usr/local/sbin/ttyusbhandler add ttyUSBupper_hub'$ii'"\n'
			udevLines+='ACTION=="remove",  ENV{DEVPATH}=="*1-1.2.'$i':1.0*", RUN+="/usr/local/sbin/ttyusbhandler remove ttyUSBupper_hub'$ii'"\n'
			udevLines+='KERNEL=="ttyUSB*", KERNELS=="1-1.3.'$i':1.0", SYMLINK+="ttyUSBlower_hub'$ii'", RUN+="/usr/local/sbin/ttyusbhandler add ttyUSBlower_hub'$ii'"\n'
			udevLines+='ACTION=="remove",  ENV{DEVPATH}=="*1-1.3.'$i':1.0*", RUN+="/usr/local/sbin/ttyusbhandler remove ttyUSBlower_hub'$ii'"\n'
		done
	else
		# on non-Pi installations, assign ttyUSBupper to ttyUSB0 and ttyUSBlower to ttyUSB1
		udevLines+='KERNEL=="ttyUSB0", SYMLINK+="ttyUSBupper", RUN+="/usr/local/sbin/ttyusbhandler add ttyUSBupper"\n'
		udevLines+='ACTION=="remove",  ENV{DEVPATH}=="*ttyUSB0*", RUN+="/usr/local/sbin/ttyusbhandler remove ttyUSBupper"\n'
		udevLines+='KERNEL=="ttyUSB1", SYMLINK+="ttyUSBlower", RUN+="/usr/local/sbin/ttyusbhandler add ttyUSBlower"\n'
		udevLines+='ACTION=="remove",  ENV{DEVPATH}=="*ttyUSB1*", RUN+="/usr/local/sbin/ttyusbhandler remove ttyUSBlower"\n'
	fi
	echo -e "$udevLines" | sudo tee /etc/udev/rules.d/50-usb.rules > /dev/null
	sudo udevadm control --reload-rules
else
	echo "A2CLOUD: Device rules for USB ports already exist."
fi

if [[ $setupSerialPortLogin ]]; then

	### SerialCon: Begin setting up serial console
	echo "A2CLOUD: Setting GPIO serial login to 4800 bps, and disabling..."
	# set console port login to 4800 bps (using RPi console cable) and comment it out
	if [[ -n "$isSystemd" ]]; then
		sudo sed -i 's/ttyAMA0,[0-9]*/ttyAMA0,4800/g' /boot/cmdline.txt 2> /dev/null
	elif [[ -n "$isSysVInit" ]]; then
		sudo sed -i 's/^\(T.*\)ttyAMA0 .* /#\1ttyAMA0 4800 /' /etc/inittab
		sudo sed -i 's/ttyAMA0,[0-9]*/ttyAMA0,4800/g' /boot/cmdline.txt 2> /dev/null
	else
		echo "A2CLOUD: Cannot set console baud rate: Unrecognized init system"
	fi

	if ! hash screen 2> /dev/null; then
		echo "A2CLOUD: Installing Screen for multiple terminals..."
		sudo apt-get -y install screen
		sudo apt-get -y clean
	else
		echo "A2CLOUD: Screen is already installed."
	fi
	echo "A2CLOUD: Disabling Screen welcome message..."
	sudo sed -i 's/^#startup_message/startup_message/' /etc/screenrc

	### SerialCon: Set up a single byte character set locale
	###      TODO: Figure out how to make this ASCII or CP437.
	# use 8-bit (non-Unicode) character set for proper emulation in Apple II term programs
	IFS='' defaultLang=$(grep ^LANG= /etc/default/locale | cut -f 2 -d '=')
	langLatin1=${defaultLang%%.*}
	if [[ ! $(grep "^$langLatin1.ISO" /usr/share/i18n/SUPPORTED) ]]; then
		langLatin1="en_US"
	fi
	if [[ $(cat /usr/local/etc/a2cloud-lang 2> /dev/null) != $langLatin1 ]]; then
		echo "A2CLOUD: Setting serial port login to use 8-bit character set..."
		locISO=$(grep "$langLatin1.ISO" /usr/share/i18n/SUPPORTED | sort | head -1)
		if [[ ! $(grep "^$langLatin1.ISO" /etc/locale.gen) ]]; then
			echo "A2CLOUD: Generating locales..."
			locs=$(IFS='' grep "^[^#]" /etc/locale.gen | while read -r thisLoc; do echo -n "$thisLoc, " ; done)
			echo "locales locales/locales_to_be_generated multiselect $locs$locISO" | sudo debconf-set-selections
			sudo rm /etc/locale.gen &> /dev/null
			sudo dpkg-reconfigure -f noninteractive locales
		else
			echo "A2CLOUD: Locales have already been generated."
		fi
		# set LANG to ISO-8859 (8-bit) character set on TTY login
		echo "${locISO%% *}" | sudo tee /usr/local/etc/a2cloud-lang > /dev/null
		source /usr/local/etc/a2cloudrc
	else
		echo "A2CLOUD: Serial port login is already using 8-bit character set."
	fi

	### SerialCon: Install serial login command scripts
	echo "A2CLOUD: Setting up baud command..."
	sudo install -o root -g root -m 755 "$a2cSource/setup/baud" /usr/local/bin/baud

	echo "A2CLOUD: Setting up term command..."
	sudo install -o root -g root -m 755 "$a2cSource/setup/term" /usr/local/bin/term

	### SerialCon: Install USB serial port login
	echo "A2CLOUD: Setting up USB shell login..."
	sudo install -o root -g root -m 755 "$a2cSource/setup/usbgetty" /usr/local/sbin/usbgetty
	if [[ -n "$isSystemd" ]]; then
		# FIXME: Okay, the way we need to fix this is that we need to do the
		# -scanttyUSB behavior and create a symlink in udev here.  If we have
		# a /dev/ttySerialConsole link, it's real easy to do this here with
		# systemd, and it actually makes the script below not necessary.<F10><F12><F12>

		# ID: I bandaided this by simply calling /usr/local/sbin/usbgetty from a getty
		# service, just as it used to be called from /etc/inittab. However,
		# the service doesn't automatically respawn when it dies, so ttyusbhandler
		# (called by udev, as before) now restarts the service upon adapter insertion.
		# This might not be the best way to do it, but it works for now,
		# apart from a 30 second delay before the getty becomes available.
		sudo install -o root -g root -m 644 "$a2cSource/setup/usbgetty-systemd.service" /etc/systemd/system/getty.target.wants/usbgetty@.service
		pwd=$PWD
		cd /etc/systemd/system/getty.target.wants
		grep -o 'SYMLINK+="ttyUSB.*,' /etc/udev/rules.d/50-usb.rules | cut -d '"' -f 2 | \
			while read ttyUSB; do
				sudo rm usbgetty@${ttyUSB}.service 2> /dev/null
				sudo ln -s usbgetty@.service usbgetty@${ttyUSB}.service
			done
		cd "$pwd"
		sudo systemctl daemon-reload
	elif [[ -n "$isSysVInit" ]]; then
		echo "A2CLOUD: Removing ttyUSB0 shell login..."
		sudo sed -i "s/^\([^#].*ttyUSB0.*\)$//" /etc/inittab

		if [[ ! $(grep -e '-scanttyUSB' /etc/inittab) ]]; then
			echo "A2CLOUD: Adding USB port shell login at 4800 bps..."
			echo -e "\n\n#for USB-to-serial adapter\nT1:23:respawn:/usr/local/sbin/usbgetty -h -L -scanttyUSB 4800 vt100" | sudo tee -a /etc/inittab > /dev/null
			sudo init q
			sudo pkill -f "getty.*ttyUSB"
		else
			echo "A2CLOUD: USB port shell login already added."
		fi
	else
		echo "A2CLOUD: Cannot set up USB shell login: Unrecognized init system"
	fi
fi


# Install Comm Tools
# FIXME: Interim refactoring
. "$a2cSource/scripts/install_comm_tools"

if [[ $installEmulators ]]; then

	### Emulators: GSport
	if ! hash gsport 2> /dev/null || ! hash gsportx 2> /dev/null || ! hash gsportfb 2> /dev/null; then
		# FIXME: This is a _TERRIBLE_ name/place for this...
		gsportConfigFile='/usr/local/lib/config.txt'

		echo "A2CLOUD: Installing GSport..."
		cd /tmp/a2cloud-install
		if [[ ! $noPicoPkg ]]; then
			### Emulators: GSport: Install pre-built binaries
			sudo apt-get -y install libpcap0.8 &> /dev/null
			sudo apt-get -y clean
			wget -qO- "${a2cBinaryURL}/picopkg/gsport-${ras2_os}_${ras2_arch}.tgz" | sudo tar Pzx 2> /dev/null
		fi
		if ! hash gsport 2> /dev/null || ! hash gsportx 2> /dev/null || ! hash gsportfb 2> /dev/null; then
			### Emulators: GSport: Install from source
			echo "A2CLOUD: Building GSport from source..."
			sudo apt-get -y install build-essential &> /dev/null
			sudo apt-get -y install libx11-dev libxext-dev xfonts-base libpcap0.8-dev &> /dev/null
			sudo apt-get -y clean > /dev/null

			mkdir -p /tmp/a2cloud-install/gsport
			cd /tmp/a2cloud-install/gsport
			wget -q -O gsport.tgz http://downloads.sourceforge.net/project/gsport/GSport-0.31/gsport_0.31.tar.gz
			tar zxf gsport.tgz
			cd gsport*/src
			rm vars 2> /dev/null

			buildGSport=1
			cp vars_fbrpilinux vars_fb
			if [[ -n $isRpi ]]; then
				cp vars_pi vars_x
			else
				cp vars_x86linux vars_x
				case "$ras2_arch" in
					x86_64)
						sed -i 's/-march=i686/-march=x86-64/' vars_x
						sed -i 's/-march=armv6/-march=x86-64/' vars_fb
						;;
					i686)
						sed -i 's/-march=armv6/-march=i686/' vars_fb
						;;
					*)
						buildGSport=
						echo "A2CLOUD: cannot build GSport; unknown machine architecture."
						;;
				esac
			fi
			sed -i 's/^LDFLAGS =.*$/LDFLAGS = -ldl/' vars_x
			sed -i 's/^LDFLAGS =.*$/LDFLAGS = -ldl/' vars_fb
			if [[ -n $buildGSport ]]; then
				for varsFile in vars_x vars_fb; do
					rm vars 2> /dev/null
					cp $varsFile vars
					make clean &> /dev/null
					make &> /dev/null
					sudo cp -P ../gsport${varsFile:5:2} /usr/local/bin
				done
				gcc -o ../to_pro to_pro.c &> /dev/null
				gcc -o ../partls partls.c &> /dev/null
				sudo cp -P ../to_pro ../partls /usr/local/bin
				sudo cp ../config.txt "$gsportConfigFile"
				sudo chmod ugo+w "$gsportConfigFile"
				cd "${gsportConfigFile%/*}"
				sudo ln -s "${gsportConfigFile##*/}" gsport_config.txt 2> /dev/null
			fi
			cd /tmp/a2cloud-install 2> /dev/null
			rm -rf gsport 2> /dev/null
		fi

		if [[ $slot6 ]]; then
			### Emulators: GSport: Place blank disk images in slot 6
			echo "A2CLOUD: Putting blank disks in GSport slot 6..."
			sudo sed -i 's@^s6d1.*$@s6d1 = /usr/local/share/gsdisks/slot6drive1.po@' "$gsportConfigFile"
			sudo sed -i 's@^s6d2.*$@s6d2 = /usr/local/share/gsdisks/slot6drive2.po@' "$gsportConfigFile"
			if [[ ! -f /usr/local/share/gsdisks/slot6drive1.po || ! -f /usr/local/share/gsdisks/slot6drive2.po ]]; then
				wget -qO- "${a2BinaryURL}/gsport/slot6.tgz" | sudo tar Pzx 2> /dev/null
			fi
		fi

		if ! grep -q '^g_appletalk_turbo' "$gsportConfigFile"; then
			### Emulators: GSport: Enable AppleTalk Turbo support
			if grep -q 'bram1[00]' "$gsportConfigFile"; then
				sudo sed -i 's/^\(bram1\[00\]\)/g_appletalk_turbo = 1\n\n\1/' "$gsportConfigFile"
			else
				echo -e '\ng_appletalk_turbo = 1' | sudo tee -a "$gsportConfigFile" > /dev/null
			fi
		fi
		sudo sed -i 's/^g_appletalk_turbo = 0/g_appletalk_turbo = 1/' "$gsportConfigFile"

		if ! grep -q 'g_ethernet[^_]' "$gsportConfigFile"; then
			### Emulators: GSport: Enable Uthernet emulation
			if grep -q 'bram1[00]' "$gsportConfigFile"; then
				sudo sed -i 's/^\(bram1\[00\]\)/g_ethernet = 1\n\n\1/' "$gsportConfigFile"
			else
				echo -e '\ng_ethernet = 1' | sudo tee -a "$gsportConfigFile" > /dev/null
			fi
		fi
		sudo sed -i 's/g_ethernet = 0/g_ethernet = 1/' "$gsportConfigFile"

		### Emulators: GSport: Setup groups and wrapper scripts
		echo "A2CLOUD: Updating GSport launch and setup files..."

		sudo addgroup gsport &> /dev/null
		sudo chgrp gsport /usr/local/bin/gsportfb
		sudo chmod u+s /usr/local/bin/gsportfb
		sudo chgrp gsport /usr/local/bin/gsportx
		sudo chmod u+s /usr/local/bin/gsportx

		sudo install -o root -g root -m 755 "$a2cSource/setup/gsport" /usr/local/bin/gsport
		sudo install -o root -g root -m 755 "$a2cSource/setup/gsport-setup" /usr/local/bin/gsport-setup

	else
		echo "A2CLOUD: GSport is already installed."
	fi

	### Emulators: LinApple
	if ! hash linapple 2> /dev/null; then
		echo "A2CLOUD: Installing LinApple..."
		cd /tmp/a2cloud-install
		if [[ ! $noPicoPkg ]]; then
			### Emulators: LinApple: Install pre-built binaries
			wget -qO- "${a2cBinaryURL}/picopkg/linapple-${ras2_os}_${ras2_arch}.tgz" | sudo tar Pzx
		fi
		if ! hash linapple 2> /dev/null; then
			### Emulators: LinApple: Install from source
			echo "A2CLOUD: Building LinApple from source..."
			sudo apt-get -y install build-essential
			sudo apt-get -y install libsdl1.2-dev libcurl4-openssl-dev zlib1g-dev libzip-dev
			sudo apt-get -y clean
			rm -rf /tmp/a2cloud-install/linapple* &> /dev/null
			mkdir -p /tmp/a2cloud-install/linapple
			cd /tmp/a2cloud-install/linapple
			wget -q -O linapple_src-2b.tar.bz2 http://downloads.sourceforge.net/project/linapple/linapple/linapple_2b/linapple_src-2b.tar.bz2
			tar jxf linapple_src-2b.tar.bz2
			cd linapple_src-2b/src
			make
			sudo make install
			cd /tmp/a2cloud-install
			rm -rf linapple
		fi
	else
		echo "A2CLOUD: LinApple is already installed."
	fi
	echo "A2CLOUD: Updating LinApple launch file..."
	sudo install -o root -g root -m 755 "$a2cSource/setup/linapple" /usr/local/bin/linapple

	### Emulators: Set Groups
	sudo addgroup gsport &> /dev/null
	sudo usermod -a -G audio,video,netdev,gsport,plugdev $USER &> /dev/null

fi

# Install Archive Tools
# FIXME: Interim refactoring
. "$a2cSource/scripts/install_archive_tools" ${noPicoPkg:+-c}

# add shortcuts to LXDE desktop
if [[ -f /usr/bin/X ]]; then

	[[ -d /etc/xdg/lxsession/LXDE-pi ]] && lxde="lxde-pi" || lxde="lxde"
	echo "A2CLOUD: Creating LXDE desktop and menu shortcuts..."

	# remove auto-open Terminal window from pre-1.8.0
	echo "A2CLOUD: removing auto-open LXDE terminal window (if present)..."
	sudo rm /etc/xdg/autostart/lxterminal.desktop 2> /dev/null

	mkdir -p ~/Desktop
	# GSport:
	if [[ -f /usr/bin/gsport ]]; then
		echo -e "[Desktop Entry]\nName=GSport\nComment=Apple IIgs Emulator\nExec=lxterminal -e /usr/bin/gsport\nIcon=/usr/local/share/gsport32.ico\nTerminal=false\nType=Application\nCategories=AppleII\n" | sudo tee /usr/share/raspi-ui-overrides/gsport.desktop > ~/Desktop/gsport.desktop
	elif [[ -f /usr/local/bin/gsport ]]; then
		echo -e "[Desktop Entry]\nName=GSport\nComment=Apple IIgs Emulator\nExec=lxterminal -e /usr/local/bin/gsport\nIcon=/usr/local/share/gsport32.ico\nTerminal=false\nType=Application\nCategories=AppleII\n" | sudo tee /usr/share/raspi-ui-overrides/gsport.desktop > ~/Desktop/gsport.desktop
	fi
	if [[ ! -f /usr/local/share/gsport32.ico ]]; then
		sudo wget -qO /usr/local/share/gsport32.ico "${a2cBinaryURL}/gsport/gsport32.ico"
	fi
	# LinApple:
	if [[ -f /usr/local/bin/linapple ]]; then
		echo -e "[Desktop Entry]\nName=LinApple\nComment=Apple IIe Emulator\nExec=lxterminal -e /usr/local/bin/linapple\nIcon=/usr/local/linapple/icon.bmp\nTerminal=false\nType=Application\nCategories=AppleII\n" | sudo tee /usr/share/raspi-ui-overrides/linapple.desktop > ~/Desktop/linapple.desktop
	fi
	# ADTPro Server:
	if [[ -f /usr/local/bin/adtpro.sh ]]; then
		echo -e "[Desktop Entry]\nName=ADTPro Server\nComment=Floppy Transfer Utility\nExec=/usr/local/bin/adtpro.sh\nIcon=/usr/local/adtpro/lib/ADTPro.ico\nTerminal=false\nType=Application\nCategories=AppleII\n" | sudo tee /usr/share/raspi-ui-overrides/adtproserver.desktop > ~/Desktop/adtproserver.desktop
	fi
	# LXTerminal:
	if [[ ! $(grep lxterminal.desktop /etc/xdg/lxpanel/profile/LXDE-pi/panels/panel 2> /dev/null) && ! -f ~/Desktop/lxterminal.desktop ]]; then
		cp $(grep -o '/.*lxterminal.desktop.*$' panel) ~/Desktop/lxterminal.desktop
	fi

fi


### DiskImage: Make/update A2CLOUD disks

if [[ $updateADTPro || $createBootDisk ]] && hash acmd 2> /dev/null; then
	a2CloudDisk=/usr/local/adtpro/disks/A2CLOUD.PO
else
	a2CloudDisk=
fi

if [[ $a2CloudDisk ]]; then
	echo
	echo "A2CLOUD: Preparing A2CLOUD disk images..."
	cd /tmp/a2cloud-install
	a2CloudDisk140=${a2CloudDisk%%.*}.DSK
	if [[ ! -f $a2CloudDisk && ! -f $a2CloudDisk140 ]]; then
		makeA2CloudDisk=1
	else
		[[ -f $a2CloudDisk ]] && echo "A2CLOUD: $a2CloudDisk already exists."
		[[ -f $a2CloudDisk140 ]] && echo "A2CLOUD: $a2CloudDisk140 already exists."
		echo "  If you want a fresh copy, please move or delete as needed."
		makeA2CloudDisk=
	fi

	if [[ ! $makeA2CloudDisk ]]; then
		### DiskImage: Use existing A2CLOUD disks

		a2CloudDiskUpdated=
		if [[ $updateADTPro && -f "$a2CloudDisk" ]]; then
			### DiskImage: Update ADTPro on 800k image
			sudo pkill -f ADTPro
			echo "A2CLOUD: Updating ADTPro and VDrive on 800K A2CLOUD disk..."
			acmd -g /usr/local/adtpro/disks/VDRIVE-*DSK VEDRIVE -        | acmd -p "$a2CloudDisk" VEDRIVE SYS
			acmd -g /usr/local/adtpro/disks/ADTPRO-*DSK ADTPROAUD -      | acmd -p "$a2CloudDisk" ADTPROAUD SYS
			acmd -g /usr/local/adtpro/disks/ADTPRO-*DSK ADTPROETH -      | acmd -p "$a2CloudDisk" ADTPROETH SYS
			acmd -g /usr/local/adtpro/disks/ADTPRO-*DSK ADTPRO.BIN -     | acmd -p "$a2CloudDisk" ADTPRO.BIN BIN \$0800
			acmd -g /usr/local/adtpro/disks/ADTPRO-*DSK ADTPROAUD.BIN -  | acmd -p "$a2CloudDisk" ADTPROAUD.BIN SYS \$0800
			acmd -g /usr/local/adtpro/disks/ADTPRO-*DSK ADTPROETH.BIN -  | acmd -p "$a2CloudDisk" ADTPROETH.BIN SYS \$0800
			acmd -g /usr/local/adtpro/disks/VDRIVE-*DSK VEDRIVE.CONFIG - | acmd -p "$a2CloudDisk" VEDRIVE.CONFIG BAS
			acmd -g /usr/local/adtpro/disks/ADTPRO-*DSK ADTPRO -         | acmd -p "$a2CloudDisk" ADTPRO SYS
			acmd -g /usr/local/adtpro/disks/VDRIVE-*DSK VSDRIVE -        | acmd -p "$a2CloudDisk" VSDRIVE SYS
			acmd -g /usr/local/adtpro/disks/VDRIVE-*DSK VSDRIVE.LOW -    | acmd -p "$a2CloudDisk" VSDRIVE.LOW SYS
			a2CloudDiskUpdated=1
		fi
		if [[ $updateADTPro && -f "$a2CloudDisk140" ]]; then
			### DiskImage: Update ADTPro on 140k image
			sudo pkill -f ADTPro
			echo "A2CLOUD: Updating ADTPro and VDrive on 140K A2CLOUD disk..."
			acmd -g /usr/local/adtpro/disks/ADTPRO-*DSK ADTPRO.BIN -     | acmd -p "$a2CloudDisk140" ADTPRO.BIN BIN \$0800
			acmd -g /usr/local/adtpro/disks/ADTPRO-*DSK ADTPRO -         | acmd -p "$a2CloudDisk140" ADTPRO SYS
			acmd -g /usr/local/adtpro/disks/VDRIVE-*DSK VSDRIVE -        | acmd -p "$a2CloudDisk140" VSDRIVE SYS
			acmd -g /usr/local/adtpro/disks/VDRIVE-*DSK VSDRIVE.LOW -    | acmd -p "$a2CloudDisk140" VSDRIVE.LOW SYS
			a2CloudDiskUpdated=1
		fi
		if [[ $a2CloudDiskUpdated ]]; then
			echo
			echo "Your A2CLOUD boot disk images have been updated. You may want"
			echo "  to update your boot floppy with their current contents using ADTPro."
		fi
	echo
	else
		### DiskImage: Building images from scratch
		sudo pkill -f ADTPro
		if [[ ! $buildA2CloudDisk ]]; then
			echo "A2CLOUD: Downloading 800K disk image..."
			wget -qO $a2CloudDisk "${a2cBinaryURL}/a2cloud/A2CLOUD.PO"
			echo "A2CLOUD: Downloading 140K disk image..."
			wget -qO $a2CloudDisk140 "${a2cBinaryURL}/a2cloud/A2CLOUD.DSK"
		fi

		# build if we don't have a disk image
		# (because download failed or -b argument was used)
		if [[ ! -f $a2CloudDisk || ( $(wc -c $a2CloudDisk | cut -f 1 -d ' ') != "819200" ) ]]; then

			# start with a disk image
			echo "A2CLOUD: Creating 800K disk image..."
			cp /usr/local/adtpro/disks/ADTPRO-*PO $a2CloudDisk
			acmd -n $a2CloudDisk A2CLOUD

			### DiskImage: Begin by modifying ADTPro image
			echo "A2CLOUD: Preparing ADTPro..."

			acmd -d "$a2CloudDisk" BASIC
			acmd -d "$a2CloudDisk" STARTUP.SYSTEM
			acmd -d "$a2CloudDisk" ADTPRO

			gsosURL="http://download.info.apple.com/Apple_Support_Area/Apple_Software_Updates/English-North_American/Apple_II/Apple_IIGS_System_6.0.1/"
			gsosBackupURL="http://archive.org/download/download.info.apple.com.2012.11/download.info.apple.com.2012.11.zip/download.info.apple.com%2FApple_Support_Area%2FApple_Software_Updates%2FEnglish-North_American%2FApple_II%2FApple_IIGS_System_6.0.1%2F"

			# start from ADTPro distribution image and replace BASIC.SYSTEM 1.4.1 with 1.5
			wget --max-redirect 0 -qO Disk_3_of_7-SystemTools1.sea.bin ${gsosURL}Disk_3_of_7-SystemTools1.sea.bin
			if (( $? != 0 )); then
				wget -qO Disk_3_of_7-SystemTools1.sea.bin ${gsosBackupURL}Disk_3_of_7-SystemTools1.sea.bin
			fi
			unar -k skip Disk_3_of_7-SystemTools1.sea.bin &> /dev/null
			mv 'Disk 3 of 7-SystemTools1.sea' SystemTools1.dc42
			acmd -g SystemTools1.dc42 BASIC.SYSTEM - | acmd -p "$a2CloudDisk" BASIC.SYSTEM SYS
			# use our startup program
			wget -qO- "${a2cBinaryURL}/a2cloud/STARTUP.BAS" | acmd -p "$a2CloudDisk" STARTUP BAS

			### DiskImage: Add VEDRIVE to A2CLOUD disk
			echo "A2CLOUD: Copying VEDRIVE..."
			acmd -g /usr/local/adtpro/disks/VDRIVE-*DSK VEDRIVE -        | acmd -p "$a2CloudDisk" VEDRIVE SYS
			acmd -g /usr/local/adtpro/disks/VDRIVE-*DSK VEDRIVE.CONFIG - | acmd -p "$a2CloudDisk" VEDRIVE.CONFIG BAS

			sysutilsURL="http://download.info.apple.com/Apple_Support_Area/Apple_Software_Updates/English-North_American/Apple_II/Apple_II_Supplemental/"
			sysutilsBackupURL="http://archive.org/download/download.info.apple.com.2012.11/download.info.apple.com.2012.11.zip/download.info.apple.com%2FApple_Support_Area%2FApple_Software_Updates%2FEnglish-North_American%2FApple_II%2FApple_II_Supplemental%2F"

			### DiskImage: Add Apple System Utilities 3.1 support files to A2CLOUD disk
			if hash unar 2> /dev/null; then
				echo "A2CLOUD: Downloading and copying System Utilities support files..."
				cd /tmp/a2cloud-install
				wget --max-redirect 0 -qO Apple_II_System_Disk_3.2.sea.bin ${sysutilsURL}Apple_II_System_Disk_3.2.sea.bin
				if (( $? != 0 )); then
					wget -qO Apple_II_System_Disk_3.2.sea.bin ${sysutilsBackupURL}Apple_II_System_Disk_3.2.sea.bin
				fi
				unar -k skip Apple_II_System_Disk_3.2.sea.bin &> /dev/null
				dd if='Apple II System Disk 3.2.sea' of=A2SYSDISK32.PO bs=1 skip=84 count=819200 2> /dev/null
				acmd -g A2SYSDISK32.PO UTIL.0 - | acmd -p "$a2CloudDisk" UTIL.0 BIN \$0900
				acmd -g A2SYSDISK32.PO UTIL.1 - | acmd -p "$a2CloudDisk" UTIL.1 BIN \$0E00
				acmd -g A2SYSDISK32.PO UTIL.2 - | acmd -p "$a2CloudDisk" UTIL.2 BIN \$B400
			else
				echo "A2CLOUD: unar is not available; not installing System Utilities support files."
			fi

			### DiskImage: Add ProTERM 3.1 to A2CLOUD disk
			echo "A2CLOUD: Downloading ProTERM..."
			wget --user-agent="Mozilla/5.0 (wget_A2CLOUD; rv:1.13.4) Gecko/20100101 Firefox/4.0.1" -qO /tmp/a2cloud-install/pt31.shk http://lostclassics.apple2.info/download/InTrec/PT31A2GM2K9.SHK
			mkdir -p /tmp/a2cloud-install/pt31
			cd /tmp/a2cloud-install/pt31
			nulib2 -xse ../pt31.shk > /dev/null
			# IIc slot 1 patch for ProTERM from Hugh Hood
			echo "A2CLOUD: Patching ProTERM for IIc printer port use..."
			echo -n -e "\x41\x70\x70\x6C\x65\x20\x49\x49\x63\x2F\x49\x49\x63\x2B\x20\x50\x72\x69\x6E\x74\x65\x72\x20\x50\x6F\x72\x74\x20\x20\x20\x20\x20\x06\x07\x10\x41\x70\x70\x6C\x65\x20\x49\x49\x63\x2F\x49\x49\x63\x2B\x20\x4D\x6F\x64\x65\x6D\x20\x50\x6F\x72\x74\x20\x20\x20\x20\x20\x20\x20\x06\x07\x20" | \
				dd of="PT3.CODE0#060000" seek=1638 bs=1 conv=notrunc 2> /dev/null
			echo "A2CLOUD: Copying ProTERM..."
			for thisFile in /tmp/a2cloud-install/pt31/*; do
				filenameUnix="${thisFile##*/}"
				filename="${filenameUnix%%#*}"
				filetype="${filenameUnix##*#}"
				if [[ $filename != "PT3.DIAL" && $filename != "ProDOS" && $filename != "PT3.BACKUP" && $filename != "PT3.SYSTEM" ]]; then
					acmd -p "$a2CloudDisk" $filename \$${filetype:0:2} \$${filetype:2:4} < $thisFile
				fi
			done
			acmd -p "$a2CloudDisk" PT3.DIAL/PTD.SPACEBAR COM \$8002 < /tmp/a2cloud-install/pt31/PT3.DIAL/"PTD.SPACEBAR#598002"
			echo "A2CLOUD: Adding 115200 baud macros for ProTERM..."
			wget -qO PT3.IIC.MACRO "${a2cBinaryURL}/a2cloud/PT3.IIC.MACRO.txt"
			cat "PT3.GLOBAL#040000" | tr '\r' '\n' | sed ':a;N;$!ba;s/\n\*\nOPTION-f : Unused & available.\n\*/~~~/' | sed -e '/~~~/r PT3.IIC.MACRO' -e 's///' | tr '\n' '\r' | acmd -p "$a2CloudDisk" PT3.IIC.GLOBAL TXT
			wget -qO PT3.IIE.MACRO "${a2cBinaryURL}/a2cloud/PT3.IIE.MACRO.txt"
			cat "PT3.GLOBAL#040000" | tr '\r' '\n' | sed ':a;N;$!ba;s/\n\*\nOPTION-f : Unused & available.\n\*/~~~/' | sed -e '/~~~/r PT3.IIE.MACRO' -e 's///' | tr '\n' '\r' | acmd -p "$a2CloudDisk" PT3.IIE.GLOBAL TXT
			wget -qO PT3.IIGS.MACRO "${a2cBinaryURL}/a2cloud/PT3.IIGS.MACRO.txt"
			cat "PT3.GLOBAL#040000" | tr '\r' '\n' | sed ':a;N;$!ba;s/\n\*\nOPTION-h : Unused & available.\n\*\n\n\*\nOPTION-H : Unused & available.\n\*/~~~/' | sed -e '/~~~/r PT3.IIGS.MACRO' -e 's///' | tr '\n' '\r' | acmd -p "$a2CloudDisk" PT3.IIGS.GLOBAL TXT
			acmd -p "$a2CloudDisk" PROTERM SYS < /tmp/a2cloud-install/pt31/"PT3.SYSTEM#ff2000"
			cd /tmp/a2cloud-install
			rm -rf /tmp/a2cloud-install/pt31

			### DiskImage: Add Z-Link to A2CLOUD disk
			echo "A2CLOUD: Downloading and copying Z-Link..."
			cd /tmp/a2cloud-install
			wget -qO /tmp/a2cloud-install/zlink.shk "ftp://ftp.gno.org/pub/apple2/prodos/comm/term/zLink91.shk"
			nulib2 -p zlink.shk z.link.system | acmd -p "$a2CloudDisk" Z.LINK SYS

			### DiskImage: Add ShrinkIt to A2CLOUD disk
			echo "A2CLOUD: Downloading and copying ShrinkIt..."
			cd /tmp/a2cloud-install
			wget -qO shrinkit.sdk http://web.archive.org/web/20131031160750/http://www.nulib.com/library/shrinkit.sdk
			[[ ! -f shrinkit.sdk ]] && wget -qO shrinkit.sdk "${a2cBinaryURL}/a2cloud/shrinkit.sdk"
			nulib2 -xs shrinkit.sdk > /dev/null
			acmd -g /tmp/a2cloud-install/SHRINKIT SHRINKIT -        | acmd -p "$a2CloudDisk" SHRINKIT SYS
			acmd -g /tmp/a2cloud-install/SHRINKIT SHRINKIT.SYSTEM - | acmd -p "$a2CloudDisk" SHRINKIT.SYS SYS
			acmd -g /tmp/a2cloud-install/SHRINKIT IIPLUS.SHRINKIT - | acmd -p "$a2CloudDisk" IIPLUS.SHRINKIT SYS
			acmd -g /tmp/a2cloud-install/SHRINKIT IIPLUS.UNSHRINK - | acmd -p "$a2CloudDisk" IIPLUS.UNSHRINK SYS

			### DiskImage: Add DSK2FILE to A2CLOUD disk
			echo "A2CLOUD: Downloading and copying DSK2FILE..."
			cd /tmp/a2cloud-install
			wget -q -O dsk2file.shk http://www.dwheeler.com/6502/oneelkruns/dsk2file.zip
			nulib2 -p dsk2file.shk dsk2file58 | acmd -p "$a2CloudDisk" DSK2FILE SYS

			### DiskImage: Add Apple System Utilities 3.1 to A2CLOUD disk
			###      Required unar to unpack above (see ## ArchiveTools: Install unar package)
			###      Apple_II_System_Disk_3.2.sea.bin
			if hash unar 2> /dev/null; then
				echo "A2CLOUD: Copying System Utilities launch file..."
				acmd -g A2SYSDISK32.PO SYSUTIL.SYSTEM - | acmd -p "$a2CloudDisk" SYSUTIL SYS
			else
				echo "A2CLOUD: unar is not available; not installing System Utilities."
			fi

			### DiskImage: Add Filer to A2CLOUD disk
			echo "A2CLOUD: Downloading and copying Filer..."
			wget -qO /tmp/a2cloud-install/mmgr.prutil.sdk ftp://ftp.gno.org/pub/apple2/prodos/comm/term/modem.mgr/mmgr.prutil.sdk
			cd /tmp/a2cloud-install
			nulib2 -xs mmgr.prutil.sdk > /dev/null
			acmd -g /tmp/a2cloud-install/MMGR FILER - | acmd -p "$a2CloudDisk" FILER SYS

			### DiskImage: Add ADTPro client to A2CLOUD disk
			echo "A2CLOUD: Copying ADTPro launch file..."
			acmd -g /usr/local/adtpro/disks/ADTPRO-*DSK ADTPRO - | acmd -p "$a2CloudDisk" ADTPRO SYS

			### DiskImage: Add VSDRIVE to A2CLOUD disk
			if [[ ! $(acmd -ls "$a2CloudDisk" | grep '^VSDRIVE BIN') ]]; then
				echo "A2CLOUD: Copying VSDRIVE..."
				acmd -g /usr/local/adtpro/disks/VDRIVE-*DSK VSDRIVE - | acmd -p "$a2CloudDisk" VSDRIVE SYS
				acmd -g /usr/local/adtpro/disks/VDRIVE-*DSK VSDRIVE.LOW - | acmd -p "$a2CloudDisk" VSDRIVE.LOW BIN \$2000
			else
				echo "A2CLOUD: VSDRIVE is already on the target disk image."
			fi

		fi

		if [[ ! -f $a2CloudDisk140 || ( $(wc -c $a2CloudDisk140 | cut -f 1 -d ' ') != "143360" ) ]]; then

			### DiskImage: Create 140k disk image
			echo "A2CLOUD: Creating 140K disk image..."
			mkpo "$a2CloudDisk140" A2CLOUD
			dd bs=256 count=1 of="$a2CloudDisk140" conv=notrunc 2> /dev/null < /usr/local/adtpro/disks/ADTPRO-*DSK
			dd bs=256 count=1 of="$a2CloudDisk140" skip=14 seek=14 conv=notrunc 2> /dev/null < /usr/local/adtpro/disks/ADTPRO-*DSK

			acmd -g $a2CloudDisk BASIC.SYSTEM    - | acmd -p $a2CloudDisk140 BASIC.SYSTEM SYS
			acmd -g $a2CloudDisk PRODOS          - | acmd -p $a2CloudDisk140 PRODOS SYS
			acmd -g $a2CloudDisk STARTUP         - | acmd -p $a2CloudDisk140 STARTUP BAS
			acmd -g $a2CloudDisk ADTPRO.BIN      - | acmd -p $a2CloudDisk140 ADTPRO.BIN BIN \$0800
			acmd -g $a2CloudDisk Z.LINK          - | acmd -p $a2CloudDisk140 Z.LINK SYS
			acmd -g $a2CloudDisk IIPLUS.SHRINKIT - | acmd -p $a2CloudDisk140 IIPLUS.SHRINKIT SYS
			acmd -g $a2CloudDisk IIPLUS.UNSHRINK - | acmd -p $a2CloudDisk140 IIPLUS.UNSHRINK SYS
			acmd -g $a2CloudDisk FILER           - | acmd -p $a2CloudDisk140 FILER SYS
			acmd -g $a2CloudDisk ADTPRO          - | acmd -p $a2CloudDisk140 ADTPRO SYS
			acmd -g $a2CloudDisk VSDRIVE         - | acmd -p $a2CloudDisk140 VSDRIVE SYS
			acmd -g $a2CloudDisk VSDRIVE.LOW     - | acmd -p $a2CloudDisk140 VSDRIVE.LOW BIN \$2000

		fi

		if [[ -f /usr/local/adtpro/disks/Virtual.po && ! -L /usr/local/adtpro/disks/Virtual.po ]]; then
			### DiskImage: Virtual.po exists and is not a symlink
			###      Move it and link it back into place
			mv /usr/local/adtpro/disks/Virtual.po /usr/local/adtpro/disks/defaultVirtual.po &> /dev/null
			vsd1 -f /usr/local/adtpro/disks/defaultVirtual.po
		fi
		if [[ -f /usr/local/adtpro/disks/Virtual2.po && ! -L /usr/local/adtpro/disks/Virtual2.po ]]; then
			### DiskImage: Virtual2.po exists and is not a symlink
			if [[ $(sha1sum /usr/local/adtpro/disks/Virtual2.po | cut -d ' ' -f 1) == "41c178f9f596f94ea7607624672552137dccade2" ]]; then
				### DiskImage: We recognize it, just delete
				rm /usr/local/adtpro/disks/Virtual2.po
			else
				### DiskImage: We do NOT recognize this Virtual2.po file
				###      ...just move it out of the way
				mv /usr/local/adtpro/disks/Virtual2.po /usr/local/adtpro/disks/defaultVirtual2.po &> /dev/null
			fi
		fi
		vsd2 -f $a2CloudDisk

		### DiskImage: Create pre 1.6.7 A2CLOUD.HDV compatibility symlink
		###      Do we still need this? ID sez: not sure, but I think so
		# for compatibility with pre-1.6.7
		ln -s /usr/local/adtpro/disks/A2CLOUD.PO /usr/local/adtpro/disks/A2CLOUD.HDV

		echo
		echo "Your A2CLOUD disk images are ready. They are called"
		echo "A2CLOUD.DSK (140K) and A2CLOUD.PO (800K), and are stored in"
		echo "/usr/local/adtpro/disks"
		echo
		echo "You can transfer to a floppy with ADTPro, or access"
		echo "the 800K image with VSDRIVE at S2,D2."
		echo
		echo "See http://ivanx.com/a2cloud for more info."
		echo
	fi
fi


if [[ $newImageName ]]; then
	### DiskImage: This is where the new Virtual.po gets made (search newImageName)
	# make new blank disk of specified size
	echo "A2CLOUD: Creating new ${imageSize}K image for virtual drive 1 at"
	echo "  /usr/local/adtpro/disks/$newImageName..."
	sudo pkill -f ADTPro
	rm /usr/local/adtpro/disks/Virtual.po &> /dev/null
	mkpo -b $(( $imageSize * 2 )) /usr/local/adtpro/disks/"$newImageName" $prodosVolName
	vsd1 -f /usr/local/adtpro/disks/"$newImageName"
fi

### A2CLOUD: Setup the a2cloud-setup command
echo 'wget -q -O /tmp/a2cloud-setup ${A2CLOUD_SCRIPT_URL:-https://raw.githubusercontent.com/RasppleII/a2cloud/current/}setup/setup.txt || { echo "Can'"'"'t download A2CLOUD setup scripts. Do you has internet?"; false; } && source /tmp/a2cloud-setup' | sudo tee /usr/local/bin/a2cloud-setup > /dev/null
sudo chmod ugo+x /usr/local/bin/a2cloud-setup


if [[ ! $restartPrompt ]]; then
	### A2CLOUD: Start ADTPro
	###     If we're not going to just reboot the system, ADTPro
	###      should not be running yet.  We'll start it here.
	adtpro-start 2> /dev/null #start ADTPro if not running and USB adapter attached
fi

echo
echo "A2CLOUD is now ready!"
echo "See http://ivanx.com/a2cloud for instructions."

### A2CLOUD: Clean up any downloaded packages to save limited filesystem space
sudo apt-get -y clean

if [[ $restartPrompt ]]; then
	### A2CLOUD: Ask about restarting your system
	echo
	echo -n "Restart your $me now (not required, but recommended)? "
	read
	if [[ ${REPLY:0:1} == "Y" || ${REPLY:0:1} == "y" ]]; then
		doRestart=1
	fi
fi

### A2CLOUD: Clean up temp files
cd "$origDir"
rm -rf /tmp/a2cloud-install &> /dev/null

### A2CLOUD: in case not restarting, make groups take effect immediately
if hash gsport 2> /dev/null; then
	if [[ ! $noSetGroups ]]; then
		if ! groups | grep -q 'gsport'; then
			touch /tmp/no-gsport
			exec sudo su -l $USER;
		fi
	fi
fi

### A2CLOUD: If restarting, restart
[[ $doRestart ]] && sudo shutdown -r now

#!/bin/shi

echo "================================\nDownloading gentoo .iso\n================================";
#wget -i ./links.txt;
echo "================================\nShowing .CONTENTS file\n================================";
gzip -dk ./*.gz;
cat ./install-amd64-minimal-20211101T222649Z.iso.CONTENTS;
echo "================================\nDownloading the right set of keys\n================================";
gpg --keyserver hkps://keys.gentoo.org --recv-keys 0xBB572E0E2D182910;
echo "================================\nVerifying the cryptographic signature of the .DIGESTS.asc file\n================================";
gpg --verify ./*.asc;
echo "================================\nVerify the fingerprint shown with the fingerprint on the Gentoo signatures page\n================================";
sleep 16;
links https://www.gentoo.org/downloads/signatures;
echo "================================\nVerifying the checksum\n================================";
grep -A 1 -i sha512 ./*.DIGESTS.asc;
sha512sum ./*.iso;
sha512sum ./*.iso.CONTENTS.gz;
echo "\n================================\nWhat's next?\n================================\n";
echo "\t::Find out the name of your USB drive with lsblk. Make sure that it is not mounted. Burning a disk\n";
echo "\tcat ./*.iso > /dev/sdx\n";
echo "\t::Booting the instalation media\n";
echo "\tgentoo-nofb acpi=on doscsi nokeymap dolvm debug nox\n";
echo "\t----------------------------------------------------------------\n";
echo "\t::Test the network with ping, if there was no automatic network detection use net-setup\n";
echo "\t::Configure proxies\n";
echo "\t::Manual network configuration\n";
echo "Loading the appropriate network modules";
echo "\tls /lib/modules/`uname -r`/kernel/drivers/net # kernel modules provided for networking";
echo "\tmodprobe modules # load the kernel module";
echo "\tls /sys/class/net # list available network interface names on the system";
echo "\tifconfig interface # check if the network card is now detected\n"
echo "Using DHCP";
echo "\tdhcpcd interface\n";
echo "Preparing for wireless access";
echo "\tip link # determine the correct device name";
echo "\tiw dev interface info # See the current wireless settings on the card";
echo "\tiw dev interface link # Check the current connection";
echo "\tiw link set dev interface up # Ensure the interface is active";
echo "\t----------------------------------------------------------------\n";
echo "\t::Designing a partition scheme\n";
echo "\tUSB Stick:\n 
\t-> 2M;BIOS partition;
\t-> 256M;EFI partition;fat32
\t-> 2G;/mnt/usb/Windows;fat32
\t-> n;/mnt/usb;f2fs\n
";
echo "\tSSD:\n 
\t-> n;/;XFS
\t-> 48G;swap;swap
\t-> 4G;/home/guest/;ext4
\t-> 256GB/home/{marado,torres,}
\t-> 4G;/mnt/Windows/;ntfs\n
";
echo "\t::Mounting the root partition\n";
echo "\tmount /dev/ROOT /mnt/gentoo\n";
echo "\t::Setting the date and time\n";
echo "\tdate";
echo "\tdate MMDDhhmmCCYY.ss	#time.is UTC time";
echo "\thwclock -w"\n;
echo "\t::Choosing a stage tarball\n";
echo "\tcd /mnt/gentoo";
echo "\tlinks https://www.gentoo.org/downloads/mirrors\n";
echo "\t::Verifying and validating\n";
echo "\topenssl dgst -r -sha512 stage3*";
echo "\tsha512sum stage3*";
echo "\topenssl dgst -r -whirlpool stage3*";
echo "\tgrep -A 1 -i sha512 *.DIGESTS.asc";
echo "\tgpg --verify *.DIGESTS.asc";
echo "\tlinks https://www.gentoo.org/downloads/signatures;\n";
echo "\t::Unpacking the stage tarball\n";
echo "\ttar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner\n";
echo "\t::Configuring compile options\n";
echo "\twget make.conf\n";
echo "\t::Gentoo ebuild repository\n";
echo "\tmkdir --parents /mnt/gentoo/etc/portage/repos.conf";
echo "\tcp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf\n";
echo "\t::Copy DNS info\n";
echo "\tcp --dereference /etc/resolv.conf /mnt/gentoo/etc\n";
echo "\t::Mounting the necessary filesystems\n";
echo "\tmount --types proc /proc /mnt/gentoo/proc";
echo "\tmount --rbind /sys /mnt/gentoo/sys";
echo "\tmount --make-rslave /mnt/gentoo/sys";
echo "\tmount --rbind /dev /mnt/gentoo/dev";
echo "\tmount --make-rslave /mnt/gentoo/dev";
echo "\tmount --bind /run /mnt/gentoo/run";
echo "\tmount --make-slave /mnt/gentoo/run\n";
echo "\t::Entering the new environment\n";
echo "\tchroot /mnt/gentoo /bin/bash";
echo "\tsource /etc/profile\n";
echo "\t::Mounting the boot partition\n";
echo "\tmount /dev/<EFI_boot_partition> /boot\n";
echo "\t::Installing a Gentoo ebuild repository snapshot from the web\n";
echo "\temerge-webrsync";
echo "\temerge --sync";
echo "\teselect news list";
echo "\teselect news read x";
echo "\teselect news purge";
echo "\tman news.eselect\n";
echo "\t::Choosing the right profile\n";
echo "\teselect profile list";
echo "\teselect profile set x\n";
echo "\tUpdating the @world set\n";
echo "\temerge --ask --verbose --update --deep --newuse @world";
echo "\t::Timezone\n";
echo "\techo \"Atlantic/Madeira\" > /etc/timezone";
echo "\temerge --config sys-libs/timezone-data\n";
echo "\t::Locale generation\n";
echo "\tvim /usr/share/i18n/SUPPORTED";
echo "\tls /usr/share/i18n/locales";
echo "\tvim /etc/locale.gen # C and POSIX included";
echo "\tlocale-gen";
echo "\tlocale -a # To verify";
echo "\teselect locale list";
echo "\teselect locale set x";
echo "\tvim /etc/env.d/02locale # see Localization guide";
echo "\tenv-update && source /etc/profile\n";

#Wireless networking chapter
#LVM
#GCC optimization
#Safe CFLAGS
#Sync article
#chroot

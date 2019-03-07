#!/bin/bash
SCRIPT=$(realpath $0)
ORIG=$(dirname $SCRIPT)
DEST=$ORIG

if [ -d "$DEST/grub" ]; then
    rm -rf $DEST/grub
fi

rm -f /boot/grub/i386-pc/*msr.mod
cat /boot/grub/i386-pc/command.lst | grep -v msr > /boot/grub/i386-pc/command.lst2
cat /boot/grub/i386-pc/command.lst2 > /boot/grub/i386-pc/command.lst
rm -f /boot/grub/i386-pc/command.lst2

if [ -d "/usr/lib/grub/i386-pc" ]; then
    rm -f /usr/lib/grub/i386-pc/*msr.mod
    cat /usr/lib/grub/i386-pc/command.lst | grep -v msr > /usr/lib/grub/i386-pc/command.lst2
    cat /usr/lib/grub/i386-pc/command.lst2 > /usr/lib/grub/i386-pc/command.lst
    rm -f /usr/lib/grub/i386-pc/command.lst2
fi

cat /etc/grub.d/40_custom | grep -v msr > /etc/grub.d/40_custom2
cat /etc/grub.d/40_custom2 > /etc/grub.d/40_custom
rm -f /etc/grub.d/40_custom2

# Just to be sure, reinstall the packages...
apt-get install -y --reinstall grub-pc grub-pc-bin grub2-common

echo "Module uninstalled."

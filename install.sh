#!/bin/bash
SCRIPT=$(realpath $0)
ORIG=$(dirname $SCRIPT)
DEST=$ORIG

if [ -f "$DEST/grub/grub-core/rdmsr.mod" ]; then
    cp $DEST/grub/grub-core/*msr.mod /boot/grub/i386-pc/
    if [ "$(cat /boot/grub/i386-pc/command.lst | grep msr | wc -l)" -eq "0" ]; then
        echo "*rdmsr: rdmsr" >> /boot/grub/i386-pc/command.lst
        echo "wrmsr: wrmsr" >> /boot/grub/i386-pc/command.lst
    fi
    if [ -d "/usr/lib/grub/i386-pc" ]; then
        cp $DEST/grub/grub-core/*msr.mod /usr/lib/grub/i386-pc/
        if [ "$(cat /usr/lib/grub/i386-pc/command.lst | grep msr | wc -l)" -eq "0" ]; then
            echo "*rdmsr: rdmsr" >> /usr/lib/grub/i386-pc/command.lst
            echo "wrmsr: wrmsr" >> /usr/lib/grub/i386-pc/command.lst
        fi
    fi
    if [ "$(cat /etc/grub.d/40_custom | grep msr | wc -l)" -eq "0" ]; then
        echo -e "\ninsmod wrmsr\nrmmod wrmsr" >> /etc/grub.d/40_custom
    fi
    update-grub
    echo "Module installed."
else
    echo "You need to build the module first. Run the script build.sh."
fi

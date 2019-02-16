#!/bin/bash
SCRIPT=$(realpath $0)
ORIG=$(dirname $SCRIPT)

if [ -f "/usr/src/grub/grub-core/msr.mod" ]; then
    cp /usr/src/grub/grub-core/msr.mod /boot/grub/i386-pc/
    if [ "$(cat /boot/grub/i386-pc/command.lst | grep msr | wc -l)" -eq "0" ]; then
        echo "msr: msr" >> /boot/grub/i386-pc/command.lst
    fi
    if [ "$(cat /etc/grub.d/40_custom | grep msr | wc -l)" -eq "0" ]; then
        echo -e "\ninsmod msr" >> /etc/grub.d/40_custom
    fi
    update-grub
    echo "Module installed."
else
    echo "You need to build the module first. Run the script build.sh."
fi

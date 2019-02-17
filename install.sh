#!/bin/bash
SCRIPT=$(realpath $0)
ORIG=$(dirname $SCRIPT)

if [ -f "/usr/src/grub/grub-core/msr.mod" ]; then
    if [ ! -f "/boot/grub/i386-pc/msr.mod" ]; then
        cp /usr/src/grub/grub-core/msr.mod /boot/grub/i386-pc/
    fi
    if [ "$(cat /boot/grub/i386-pc/command.lst | grep msr | wc -l)" -eq "0" ]; then
        echo "*rdmsr: msr" >> /boot/grub/i386-pc/command.lst
        echo "wrmsr: msr" >> /boot/grub/i386-pc/command.lst
    fi
    if [ -d "/usr/lib/grub/i386-pc" ]; then
        if [ ! -f "/usr/lib/grub/i386-pc/msr.mod" ]; then
            cp /usr/src/grub/grub-core/msr.mod /usr/lib/grub/i386-pc/
        fi
        if [ "$(cat /usr/lib/grub/i386-pc/command.lst | grep msr | wc -l)" -eq "0" ]; then
            echo "*rdmsr: msr" >> /usr/lib/grub/i386-pc/command.lst
            echo "wrmsr: msr" >> /usr/lib/grub/i386-pc/command.lst
        fi
    fi
    if [ "$(cat /etc/grub.d/40_custom | grep msr | wc -l)" -eq "0" ]; then
        echo -e "\ninsmod msr\nrmmod msr" >> /etc/grub.d/40_custom
    fi
    update-grub
    echo "Module installed."
else
    echo "You need to build the module first. Run the script build.sh."
fi

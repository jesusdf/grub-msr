# grub-msr
grub2 msr module to read or write model-specific registers.

Installation
------------

    1. Use the script build.sh to download the latest version of grub, include the module source and build everything. 
    2. Copy the file /usr/src/grub/grub-core/msr.mod to /boot/grub/i386-pc/
    3. Add the following line to the end of /boot/grub/i386-pc/command.lst:

        msr: msr

    4. Edit the file /etc/grub.d/40_custom loading the module and making the tweaks that you want to apply, for example:

        \#!/bin/sh
        exec tail -n +3 $0
        \# This file provides an easy way to add custom menu entries.  Simply type the
        \# menu entries you want to add after this comment.  Be careful not to change
        \# the 'exec tail' line above.
         
        insmod msr
        wrmsr 0x19A 0x1

    5. Update the grub configuration using:

        update-grub

Usage
-----

    Once the msr module is loaded, two new commands are availiable for reading and writing to the MSR:

        rdmsr 0xADDRESS
        wrmsr 0xADDRESS 0xVALUE



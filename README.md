# grub-msr
grub2 msr modules to read (rdmsr) or write (wrmsr) from/to model-specific registers.

It allows you to make changes to the MSR before any OS boots:

![CPU-Z comparison](https://github.com/jesusdf/grub-msr/blob/master/cpuz.jpg?raw=true "CPU-Z comparison")

In this example a Core 2 Extreme CPU is tweaked to allow a higher multiplier than stock.

Main structure inspired by memrw.c and cpuid.c (since it's an i386 module only), assembly code adapted from:

   [osdev.org wiki RDMSR](https://wiki.osdev.org/Inline_Assembly/Examples#RDMSR)
   
   [osdev.org wiki WRMSR](https://wiki.osdev.org/Inline_Assembly/Examples#WRMSR)

Files
-----

    grub-core/commands/i386/rdmsr.c	- Registration of the rdmsr command.
    include/grub/i386/rdmsr.h		- Assembly functions to read from the MSR.
    grub-core/commands/i386/rdmsr.c	- Registration of the wrmsr command.
    include/grub/i386/wrmsr.h		- Assembly functions to write to the MSR.

Installation
------------

    * Use the script build.sh to download the latest version of grub, include the module source 
      and build everything.
      
    * Use the script install.sh to install the module to the system.
      It will perform the following operations:
    
        1. Copy the file rdmsr.mod and wrmsr.mod from /usr/src/grub/grub-core/ to /boot/grub/i386-pc/
        2. Add the following lines to the end of /boot/grub/i386-pc/command.lst:
    
            *rdmsr: rdmsr
            wrmsr: wrmsr
        
        3. Do the previous operations under the /usr/lib/grub/i386-pc folder if it exists.
        4. Edit the file /etc/grub.d/40_custom loading the module and anything else that you need:
        
            #!/bin/sh
            exec tail -n +3 $0
            # This file provides an easy way to add custom menu entries.  Simply type the
            # menu entries you want to add after this comment.  Be careful not to change
            # the 'exec tail' line above.
            
            insmod wrmsr
            wrmsr 0x19A 0x12
            rmmod wrmsr
        
        4. Update the grub configuration using:
    
            update-grub

    * Use the script uninstall.sh in order to remove the modules from the system.

Usage
-----

    Once the rdmsr/wrmsr modules are loaded, two new commands are availiable for reading and writing to the MSR:

        rdmsr 0xADDRESS
        wrmsr 0xADDRESS 0xVALUE



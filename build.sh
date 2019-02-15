#!/bin/bash
SCRIPT=$(realpath $0)
ORIG=$(dirname $SCRIPT)
cd /usr/src
echo "Downloading grub source code..."
#apt-get source grub-pc
if [ ! -d /usr/src/grub ]; then
    git clone git://git.savannah.gnu.org/grub.git
fi
cd grub
echo "Adding msr module..."
cp $ORIG/*.c ./grub-core/commands/i386/
cp $ORIG/*.h ./include/grub/i386/
if [ "$(cat ./grub-core/Makefile.core.def | grep msr | wc -l)" -eq "0" ]; then
    cat $ORIG/Makefile.core.def >> ./grub-core/Makefile.core.def
fi
echo "Building..."
./linguas.sh
./autogen.sh
# http://www.linuxfromscratch.org/lfs/view/development/chapter06/grub.html
./configure --prefix=/usr --sbindir=/sbin --sysconfdir=/etc --disable-efiemu --disable-werror && make && ls --color ./grub-core/msr.*


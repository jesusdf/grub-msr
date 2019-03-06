#!/bin/bash
SCRIPT=$(realpath $0)
ORIG=$(dirname $SCRIPT)
cd /usr/src
#apt-get source grub-pc
if [ -d /usr/src/grub ]; then
    rm -rf /usr/src/grub
fi
echo "Downloading grub source code..."
git clone git://git.savannah.gnu.org/grub.git
cd grub
echo "Patching __asm__ and __volatile__..."
#find ./ -type f -name \*.[ch] -exec sed -i 's/__asm__(/__asm__ (/g;' {} \;
#find ./ -type f -name \*.[ch] -exec sed -i 's/__asm__/    asm/g;s/__volatile__/    volatile/g;' {} \;
#find ./ -type f -name \*.[ch] -exec sed -i 's/    asm     volatile/asm volatile/g;' {} \;
find ./ -type f -name \*.[ch] -exec sed -i 's/__asm__ __volatile__/asm volatile/g;' {} \;
echo "Press enter key to continue..."
read
echo "Including the wrmsr module in the EFI disabled module list..."
sed -i "s/\"memrw\", NULL/\"memrw\", \"wrmsr\", NULL/g" /usr/src/grub/grub-core/commands/efi/shim_lock.c
echo "Adding new rdmsr and wrmsr modules..."
cp $ORIG/*.c ./grub-core/commands/i386/
cp $ORIG/*.h ./include/grub/i386/
if [ "$(cat ./grub-core/Makefile.core.def | grep msr | wc -l)" -eq "0" ]; then
    cat $ORIG/Makefile.core.def >> ./grub-core/Makefile.core.def
fi
echo "Press enter key to continue..."
read
echo "Patching documentation..."
cd docs
patch < $ORIG/doc.patch
cd ..
echo "Press enter key to continue..."
read
echo "Building..."
./bootstrap
./linguas.sh
echo "es" > po/LINGUAS
./autogen.sh
# http://www.linuxfromscratch.org/lfs/view/development/chapter06/grub.html
./configure --prefix=/usr --sbindir=/sbin --sysconfdir=/etc --disable-efiemu --disable-werror && make && ls --color ./grub-core/*msr.*


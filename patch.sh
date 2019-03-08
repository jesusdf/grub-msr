#!/bin/bash
SCRIPT=$(realpath $0)
ORIG=$(dirname $SCRIPT)
DEST=$ORIG

if [ -d $DEST/grub ]; then
    cd $DEST/grub
    git format-patch --cover-letter -M origin/master -o ../outgoing/
    echo "Now you can run: git send-email outgoing/*"
fi


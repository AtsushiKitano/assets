#!/bin/sh

FILEPATH=$1
OUTPUTFILE=$2

mv $FILEPATH ~/.config/aws/credentials/$OUTPUTFILE
sed -i -e 's/ //g' ~/.config/aws/credentials/$OUTPUTFILE
rm -f ~/.config/aws/credentials/$OUTPUTFILE-e

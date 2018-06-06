#!/bin/sh
#
# This script is responsible for generating the setEnv.sh script
# based on the information inside env.properties

# run this file after updating env.properties

if [ ! -f $1 ] ; then
    echo "usage: "
    echo "    $0 [property file]"
    echo "\nExiting."
    exit 1
fi

TMPFILE=~/tmpfile
TMPFILE2=~/tmpfile2

echo "#!/bin/sh"

grep -v "^#" $1 | sed -e '/^$/d' > $TMPFILE

# escape the keys and values so they are shell friendly.

while read curline; do
echo $curline | awk -F = '{print $1;}' | tr '.' '_' | tr '\n' '=' >> $TMPFILE2
echo $curline | awk -F = '{print $2;}' | sed "s/'/'\"'\"'/g" | sed "s/^/\'/" | sed "s/$/\'/" >> $TMPFILE2
done < $TMPFILE

while read curline; do
echo export $curline
done < $TMPFILE2

rm -f $TMPFILE $TMPFILE2

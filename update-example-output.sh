#!/bin/bash

#
#
# Update the example-output directory using Metapolator and
# MutatorMath to generate instances at 50% between Light and ExtraBold
# for the Khula font.
#
#
#
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ "y$(pwd)" != "y$SCRIPTDIR" ]; then
    echo "You must run this script from the base directory of the repository."
    echo "Please run it as ./update-example-output.sh"
    exit 1
fi

#
#
#####################################
#####################################
#####################################
#
# Generate output using Metapolator 
#
#

rm -rf "$SCRIPTDIR/example-output/metapolator-Khula-090x-456.ufo"
rm -rf "$SCRIPTDIR/example-output/metapolator-Khula.ufo"

echo "Performing metapolation on 3 devanagari glyphs"
./metapolator-interpolate.js        \
     -a Khula-Light-090x-456.ufo     \
     -b Khula-ExtraBold-090x-456.ufo \
     -o "$SCRIPTDIR/example-output/metapolator-Khula-090x-456.ufo"

echo "Performing metapolation on full Khila font"
./metapolator-interpolate.js        \
     -a Khula-Light.ufo     \
     -b Khula-ExtraBold.ufo \
     -o "$SCRIPTDIR/example-output/metapolator-Khula.ufo"

#
#
#####################################
#####################################
#####################################
#
# Generate output using MutatorMath 
#
#

# patch the nasty output so that FontForge knows the size
ensureFontForgeFriendlyFontInfo() {
    ufopath=$1

    echo "patching $ufopath/fontinfo.plist"
    sed -i "s|<string>styleName</string>|<string>styleName</string><key>unitsPerEm</key><integer>2048</integer>|g" $ufopath/fontinfo.plist
}

rm -rf "$SCRIPTDIR/example-output/mutatormath-Khula-090x-456.ufo"
rm -rf "$SCRIPTDIR/example-output/mutatormath-Khula.ufo"

./simpleblend.py \
    `pwd`/fonts/Khula-Light-090x-456.ufo \
    `pwd`/fonts/Khula-ExtraBold-090x-456.ufo \
    weight 0.5 \
    "$SCRIPTDIR/example-output/mutatormath-Khula-090x-456.ufo"

./simpleblend.py \
    `pwd`/fonts/Khula-Light.ufo \
    `pwd`/fonts/Khula-ExtraBold.ufo \
    weight 0.5 \
    "$SCRIPTDIR/example-output/mutatormath-Khula.ufo"

ensureFontForgeFriendlyFontInfo "$SCRIPTDIR/example-output/mutatormath-Khula-090x-456.ufo"
ensureFontForgeFriendlyFontInfo "$SCRIPTDIR/example-output/mutatormath-Khula.ufo"



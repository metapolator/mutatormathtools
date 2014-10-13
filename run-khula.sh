#!/bin/bash

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
rm -rf "$SCRIPTDIR/out.ufo"

./simpleblend.py \
    `pwd`/fonts/Khula-Light-090x-456.ufo \
    `pwd`/fonts/Khula-ExtraBold-090x-456.ufo \
    weight 0.5 \
&& xmllint --format simpleblend.designspace

# patch the nasty output so that FontForge knows the size
sed -i "s|<string>styleName</string>|<string>styleName</string><key>unitsPerEm</key><integer>2048</integer>|g" out.ufo/fontinfo.plist


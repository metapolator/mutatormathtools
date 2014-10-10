#!/bin/bash

./simpleblend.py \
    `pwd`/fonts/Merriweather-Bold-Subset-nop.ufo \
    `pwd`/fonts/Merriweather-Regular-Subset-nop.ufo  \
    weight 0.5 \
&& xmllint --format simpleblend.designspace

# patch the nasty output so that FontForge knows the size
sed -i "s|<string>styleName</string>|<string>styleName</string><key>unitsPerEm</key><integer>2048</integer>|g" out.ufo/fontinfo.plist


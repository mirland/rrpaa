#!/bin/bash

REPOSITORY_PATH="https://github.com/matir91/rrpaa"
REPOSITORY_PATCH_PATH='src'
REPOSITORY_CONFIG_FILE_FOLDER='01a95dfb90d4908549108f42239ad281'
REPOSITORY_CONFIG_FILE="https://gist.github.com/$REPOSITORY_CONFIG_FILE_FOLDER.git"

sudo apt-get update
sudo apt-get install subversion build-essential libncurses5-dev zlib1g-dev gawk git ccache gettext libssl-dev xsltproc wget unzip ---yes

git clone -b chaos_calmer git://github.com/openwrt/openwrt.git
cd openwrt/
git checkout 2052672 # Used version

git submodule add $REPOSITORY_PATH
cp $REPOSITORY_PATCH_PATH/* package/kernel/mac80211/patches/

sed -i -e '1452i\\tMAC80211_RC_RRPAA \\' package/kernel/mac80211/Makefile
sed -i -e '1452i\\tMAC80211_RC_DEFAULT_RRPAA \\' package/kernel/mac80211/Makefile


# The following lines could be removed and the `make menuconfig` command could be applied
# in order to customise the OpenWRT installation.
# More info in https://wiki.openwrt.org/es/doc/howto/build
git submodule add $REPOSITORY_CONFIG_FILE
cp $REPOSITORY_CONFIG_FILE_FOLDER/.config .

make defconfig
make -j3


#!/bin/bash
PATCH_DIR="patch_file"
KERNEL_VER=6.5
sudo apt install build-essential libncurses5-dev fakeroot xz-utils libelf-dev liblz4-tool \
  unzip flex bison bc debhelper rsync libssl-dev:native
wget -N https://github.com/torvalds/linux/archive/refs/tags/v$KERNEL_VER.zip
unzip -o v$KERNEL_VER.zip

cd linux-$KERNEL_VER
scripts/config --disable SYSTEM_TRUSTED_KEYS
cp ../.config .
patch -p1 < ../patch_file/acso.patch
sudo make olddefconfig -j $(nproc) bindeb-pkg LOCALVERSION=-acso KDEB_PKGVERSION=$(make kernelversion)-1

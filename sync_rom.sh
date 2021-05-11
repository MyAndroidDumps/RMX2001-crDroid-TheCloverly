#!/bin/bash

set -exv

# sync rom
repo init -u git://github.com/crdroidandroid/android.git -b 11.0
git clone https://github.com/Realme-G90T-Series/local_manifest.git .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)

# patches
cd /tmp/rom
cd external/selinux 
curl -L http://ix.io/2FhM > sasta.patch 
git am sasta.patch 
cd /tmp/rom
cd frameworks/av 
wget https://github.com/phhusson/platform_frameworks_av/commit/624cfc90b8bedb024f289772960f3cd7072fa940.patch 
patch -p1 < *.patch
cd -

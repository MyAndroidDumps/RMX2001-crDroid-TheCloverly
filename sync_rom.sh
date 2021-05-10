#!/bin/bash

set -exv

# sync rom
repo init -u git://github.com/crdroidandroid/android.git -b 11.0
git clone https://github.com/Realme-G90T-Series/local_manifest.git .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)

#!/bin/bash
set -e
set -x

# sync rom
repo init -u git://github.com/crdroidandroid/android.git -b 11.0
git clone https://github.com/Apon77Lab/android_.repo_local_manifests.git --depth 1 -b aex .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)

#build rom
cd /tmp/rom
rm -rf .repo
cd external/selinux 
curl -L http://ix.io/2FhM > sasta.patch 
git am sasta.patch 
cd /tmp/rom
cd frameworks/av 
wget https://github.com/phhusson/platform_frameworks_av/commit/624cfc90b8bedb024f289772960f3cd7072fa940.patch 
patch -p1 < *.patch
cd /tmp/rom
source build/envsetup.sh
lunch lineage_RMX2001-userdebug
export ALLOW_MISSING_DEPENDENCIES=true
export SKIP_API_CHECKS=true
export SKIP_ABI_CHECKS=true
cd /tmp/rom
export CCACHE_DIR=/tmp/ccache  ##use additional flags if you need(optional)
export CCACHE_EXEC=$(which ccache)
export USE_CCACHE=1

ccache -M 20G
ccache -o compression=true
ccache -z
ccache -c

up(){
	curl --upload-file $1 https://transfer.sh/
}

make_metalava(){
	mka api-stubs-docs
	mka system-api-stubs-docs
	mka test-api-stubs-docs
}

make_rom(){
	mka bacon -j8
	zip=$(up out/target/product/RMX2001/*zip)
	echo " "
	echo "$zip"
}

make_metalava
make_rom 

# upload rom
up(){
	curl --upload-file $1 https://transfer.sh/$(basename $1); echo
	# 14 days, 10 GB limit
}

up out/target/product/RMX2001/*.zip

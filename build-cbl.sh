#!/bin/bash
set -euo pipefail

echo "deb http://archive.ubuntu.com/ubuntu eoan main" | sudo tee /etc/apt/sources.list 
sudo apt-get update
sudo apt-get -y --no-install-recommends install bison flex libc6 libstdc++6

echo $GITHUB_WORKSPACE

echo $(ldd --version)


mkdir $GITHUB_WORKSPACE/TC
cd $GITHUB_WORKSPACE/TC
wget 'https://dl.akr-developers.com/s/CBL/LiuNian_clang-20200415.tar.zst' -q
tar -I zstd -xf LiuNian_clang-20200415.tar.zst 
echo "unarchived!"

#export PATH=$GITHUB_WORKSPACE/TC/bin:$PATH

cd $GITHUB_WORKSPACE/kernel
args="-j$(nproc --all) \
    O=out \
    ARCH=arm64 \
    CLANG_TRIPLE=aarch64-linux-gnu- \
    CROSS_COMPILE=$GITHUB_WORKSPACE/TC/bin/aarch64-linux-gnu- \
    CC=$GITHUB_WORKSPACE/TC/bin/clang"

echo "Make defconfig"
make ${args} picasso_defconfig
echo "Make"
make ${args}
#!/bin/bash

#Anykernel3
ANYKERNEL3_DIR=$PWD/AnyKernel3/
# 内核工作目录
export KERNEL_DIR=$(pwd)
# 内核 defconfig 文件
export KERNEL_DEFCONFIG=lineage-msm8998-yoshino-maple_dsds_defconfig
# 编译临时目录，避免污染根目录
export OUT=out
# clang 绝对路径
export CLANG_PATH=/mnt/disk/tool/proton-clang
export PATH=${CLANG_PATH}/bin:${PATH}
export CLANG_TRIPLE=aarch64-linux-gnu-
# gcc 绝对路径
#export GCC_PATH=/mnt/disk/tool/gcc-aosp
#export PATH=${GCC_PATH}/bin:${PATH}
# arch平台，这里时arm64
export ARCH=arm64
export SUBARCH=arm64
# 只使用clang编译需要配置
export LLVM=1
export BUILD_INITRAMFS=1
#Kernel Name
FINAL_KERNEL_ZIP=whatwurst_KSU_A13_dibin.zip
# ./build.sh 4

TH_COUNT=16
if [[ "" != "$1" ]]; then
        TH_NUM=$1
fi

export DEF_ARGS="O=${OUT} \
                                CC=clang \
                                CXX=clang++ \
                                ARCH=${ARCH} \
                                CROSS_COMPILE=${CLANG_PATH}/bin/aarch64-linux-android- \
                                CROSS_COMPILE_ARM32=${CLANG_PATH}/bin/arm-linux-gnueabi- \
                                LD=ld.lld "

export BUILD_ARGS="-j${TH_COUNT} ${DEF_ARGS}"

# make defconfig
make ${DEF_ARGS} ${KERNEL_DEFCONFIG}

make ${BUILD_ARGS}

ls $PWD/out/arch/arm64/boot/Image.gz-dtb
ls $ANYKERNEL3_DIR
rm -rf $ANYKERNEL3_DIR/Image.gz-dtb
rm -rf $ANYKERNEL3_DIR/$FINAL_KERNEL_ZIP
cp $PWD/out/arch/arm64/boot/Image.gz-dtb $ANYKERNEL3_DIR/
cd $ANYKERNEL3_DIR/
zip -r9 $FINAL_KERNEL_ZIP * -x README $FINAL_KERNEL_ZIP
mv $ANYKERNEL3_DIR/$FINAL_KERNEL_ZIP /mnt/disk/kernelout


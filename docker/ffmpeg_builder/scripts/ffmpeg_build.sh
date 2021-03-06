#!/usr/bin/env bash

#https://github.com/Javernaut/ffmpeg-android-maker

FFMPEG_VERSION=4.1.4

# Assuming the script is used on macOS or Linux machine
case "$OSTYPE" in
  darwin*)  HOST_TAG="darwin-x86_64" ;;
  linux*)   HOST_TAG="linux-x86_64" ;;
esac

# Directories used by the script
BASE_DIR="$( cd "$( dirname "$0" )" && pwd )"
SOURCES_DIR=${BASE_DIR}/sources
#FFMPEG_SOURCES=${SOURCES_DIR}/ffmpeg-${FFMPEG_VERSION}
FFMPEG_SOURCES=/home/sources/ffmpeg
OUT="/home/deps/ffmpeg"
OUTPUT_DIR=${OUT}/output
BUILD_DIR=${OUT}/build
STATS_DIR=${OUT}/stats
ANDROID_NDK_HOME=$NDK

# No incremental compilation here. Just drop what was built previously
#rm -rf ${BUILD_DIR}
#rm -rf ${STATS_DIR}
#rm -rf ${OUTPUT_DIR}
mkdir -p ${STATS_DIR}
mkdir -p ${OUTPUT_DIR}

# Test if sources of the FFmpeg exist. If not - download them
function ensureSources() {
  if [[ ! -d "$FFMPEG_SOURCES" ]]; then
    TARGET_FILE_NAME=ffmpeg-${FFMPEG_VERSION}.tar.bz2
    TARGET_FILE_PATH=${SOURCES_DIR}/${TARGET_FILE_NAME}

    mkdir -p ${SOURCES_DIR}
    curl https://www.ffmpeg.org/releases/${TARGET_FILE_NAME} --output ${TARGET_FILE_PATH}
    tar xvjf ${TARGET_FILE_PATH} -C ${SOURCES_DIR}
    rm ${TARGET_FILE_PATH}
  fi
}

# Actual magic of configuring and compiling of FFmpeg for a certain architecture.
# Supported architectures are: armeabi-v7a, arm64-v8a, x86 and x86_64
function assemble() {
  cd ${FFMPEG_SOURCES}

  ARCH=$1
  API_LEVEL=$2
  TYPE=$3

  TOOLCHAIN_PATH=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/${HOST_TAG}
  SYSROOT=${TOOLCHAIN_PATH}/sysroot

  CC_ANDROID_POSTFIX=
  EXTRA_CFLAGS=
  EXTRA_CONFIGURE_FLAGS=

  case $ARCH in
  	armeabi-v7a)
      FFMPEG_ARCH_FLAG=arm
      if [ "$TYPE" == android ]; then
          CROSS_PREFIX=arm-linux-androideabi-
      elif [ "$TYPE" == desktop ]; then
        CROSS_PREFIX=arm-linux-gnu-
      fi
      CC_PREFIX=armv7a
      CC_ANDROID_POSTFIX=eabi
  		;;
  	arm64-v8a)
      FFMPEG_ARCH_FLAG=aarch64
      if [ "$TYPE" == android ]; then
          CROSS_PREFIX=aarch64-linux-android-
      elif [ "$TYPE" == desktop ]; then
        CROSS_PREFIX=aarch64-linux-gnu-
      fi
      CC_PREFIX=aarch64
  		;;
    x86)
      FFMPEG_ARCH_FLAG=x86
      CROSS_PREFIX=i686-linux-android-
      CC_PREFIX=i686
      EXTRA_CFLAGS=-mno-stackrealign
      EXTRA_CONFIGURE_FLAGS=--disable-asm
  		;;
    x86_64)
      FFMPEG_ARCH_FLAG=x86_64
      CROSS_PREFIX=x86_64-linux-android-
      CC_PREFIX=x86_64
      EXTRA_CONFIGURE_FLAGS=--x86asmexe=${TOOLCHAIN_PATH}/bin/yasm
  		;;
  esac

  #if [ "$TYPE" == android ]; then
CC=${TOOLCHAIN_PATH}/bin/${CC_PREFIX}-linux-android${CC_ANDROID_POSTFIX}${API_LEVEL}-clang
 # elif [ "$TYPE" == desktop ]; then 
 #   if [ "$FFMPEG_ARCH_FLAG" == arm ]; then
#		CC=arm-linux-gnueabi-gcc
#  	elif [ "$FFMPEG_ARCH_FLAG" == aarch64 ]; then
#		CC=aarch64-linux-gnueabi-gcc
#	fi
#  fi


  DECODERS_TO_ENABLE=
  while IFS= read -r line; do DECODERS_TO_ENABLE="${DECODERS_TO_ENABLE} --enable-decoder=$line"; done < ${BASE_DIR}/video_decoders_list.txt
  
  if [ "$TYPE" == android ]; then
    echo "Configuring $TYPE of arch $ARCH..."
    ./configure \
    --prefix=${BUILD_DIR}/android/${ARCH} \
    --disable-doc \
    --enable-cross-compile \
    --cross-prefix=${TOOLCHAIN_PATH}/bin/${CROSS_PREFIX} \
    --target-os=android \
    --cc=${CC} \
    --arch=${FFMPEG_ARCH_FLAG} \
    --extra-cflags="-O3 -fPIC $EXTRA_CFLAGS" \
    --sysroot=${SYSROOT} \
    --enable-shared \
    --disable-static \
    --disable-debug \
    --disable-runtime-cpudetect \
    --disable-programs \
    --disable-muxers \
    --disable-encoders \
    --disable-decoders \
    ${DECODERS_TO_ENABLE} \
    --disable-bsfs \
    --disable-pthreads \
    --disable-avdevice \
    --disable-network \
    --disable-postproc \
    #--disable-swresample \
    #--disable-avfilter \
    ${EXTRA_CONFIGURE_FLAGS}

    make clean
    make -j8
    make install

    # Saving stats about text relocation presence.
    # If the result file doesn't have 'TEXTREL' at all, then we are good.
    ${TOOLCHAIN_PATH}/bin/${CROSS_PREFIX}readelf --dynamic ${BUILD_DIR}/${ARCH}/lib/*.so | grep 'TEXTREL\|File' >> ${STATS_DIR}/text-relocations.txt

    cd ${BASE_DIR}

  elif [ "$TYPE" == desktop ]; then
     if [ "$ARCH" == x86 ] || [ "$ARCH" == x86_64 ]; then 
      #https://gist.github.com/Brainiarc7/4f831867f8e55d35cbcb527e15f9f116
      #TODO: add intel media sink
      #TODO: make x_86 and x_86_64 versions of this
      #TODO: enable vaapi support!
      echo "Configuring $TYPE of arch $ARCH (or ${FFMPEG_ARCH_FLAG})..."
      PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig:/opt/intel/mediasdk/lib/pkgconfig"
        #--extra-cflags="-I/opt/intel/mediasdk/include" \
        #--extra-ldflags="-L/opt/intel/mediasdk/lib" \
        #--extra-ldflags="-L/opt/intel/mediasdk/plugins" \
        #--enable-libx265 \
        #--enable-libfdk-aac \
        #--enable-libx264 \
        #--enable-libdrm \
        #--enable-libvpx \
        #--enable-opencl \
        #--extra-libs="-lpthread -lm -lz -ldl" \

      ./configure \
        --prefix=${BUILD_DIR}/desktop/${FFMPEG_ARCH_FLAG} \
        --extra-cflags="-I$HOME/ffmpeg_build/include" \
        --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
        --arch=${ARCH} \
        --enable-static \
        --enable-vaapi \
        --disable-vaapi \
        --disable-debug \
        --enable-nvenc \
        --enable-cuda \
        --enable-cuvid \
        --enable-gpl \
        --enable-runtime-cpudetect \
        --enable-openssl \
        --enable-pic \
        --disable-shared \
        --extra-libs="-lpthread -lm -lz -ldl" \
        --enable-nonfree \
        --pkg-config-flags="--static"

      PATH="$HOME/bin:$PATH" 
      make clean
      make -j$(nproc)
      make -j$(nproc) install 
      make -j$(nproc) distclean 
      hash -r

    elif [ "$ARCH" == arm64-v8a ] || [ "$ARCH" == armeabi-v7a ]; then
        echo "Configuring $TYPE of arch $ARCH, specifically ${FFMPEG_ARCH_FLAG}..."
        ./configure \
        --prefix=${BUILD_DIR}/desktop/${FFMPEG_ARCH_FLAG} \
        --disable-doc \
        --enable-cross-compile \
        --cross-prefix=${CROSS_PREFIX} \
        --target-os=linux \
        --arch=${FFMPEG_ARCH_FLAG} \
        --extra-cflags="-O3 -fPIC $EXTRA_CFLAGS" \
        --enable-shared \
        --disable-debug \
        --disable-runtime-cpudetect \
        --disable-programs \
        --disable-muxers \
        --disable-encoders \
        --disable-decoders \
        ${DECODERS_TO_ENABLE} \
        --disable-bsfs \
        --disable-pthreads \
        --disable-avdevice \
        --disable-network \
        --disable-postproc 
        ${EXTRA_CONFIGURE_FLAGS}
        make clean
        make -j$(nproc)
        make install
	  fi

  else
      echo target $TYPE not supported
  fi  
}

# Placing build *.so files into the /bin directory
function installLibs() {
  BUILD_SUBDIR=$1
  TYPE=$2

  OUTPUT_SUBDIR=${OUTPUT_DIR}/${TYPE}/lib/${BUILD_SUBDIR}
  CP_DIR=${BUILD_DIR}/${BUILD_SUBDIR}

  mkdir -p ${OUTPUT_SUBDIR}
  cp ${CP_DIR}/lib/*.so ${OUTPUT_SUBDIR}
}

#Android Studio's build.gradle file expects the following file structure:
#${BUILD_DIR}/${TYPE}/${ARCH}/lib1.so
#${BUILD_DIR}/${TYPE}/${ARCH}/lib2.so
#...
#But ffmpeg compiles into ${BUILD_DIR}/${TYPE}/${ARCH}/lib
function copyToOutterDirectory() {
  ARCH=$1
  ANDROID_API=$2
  TYPE=$3
  if [ "$TYPE" == android ]; then
    cp ${BUILD_DIR}/${TYPE}/${ARCH}/lib/*.so ${BUILD_DIR}/${TYPE}/${ARCH}
    cp ${BUILD_DIR}/${TYPE}/${ARCH}/lib/*.a ${BUILD_DIR}/${TYPE}/${ARCH}
  fi
}

function build() {
  ARCH=$1
  ANDROID_API=$2
  TYPE=$3

  assemble ${ARCH} ${ANDROID_API} ${TYPE}
  copyToOutterDirectory ${ARCH} ${ANDROID_API} ${TYPE}
  #installLibs ${ARCH} ${TYPE}
}

# Placing build header files into the /bin directory
# Note, there is a only one such a folder since this headers are the same for all architectures
# May not be true for different configurations though
function installHeaders() {

  echo "cd ${BUILD_DIR}
  cd "$(ls -1 | head -n1)"
  cp -r include ${OUTPUT_DIR}
  cd ${BASE_DIR}"

  cd ${BUILD_DIR}
  cd "$(ls -1 | head -n1)"
  cp -r include ${OUTPUT_DIR}
  cd ${BASE_DIR}
}

# Actual work

#ensureSources

build armeabi-v7a 16 android
build arm64-v8a 21 android
build x86 16 android
build x86_64 21 android
build x86_64 _ desktop
build arm64-v8a _ desktop #jetson nano and raspberry pi 4

#installHeaders

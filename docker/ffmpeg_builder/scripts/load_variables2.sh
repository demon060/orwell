TOOLCHAIN=$NDK/toolchains/$TOOLCHAIN_FOLDER-4.9/prebuilt/$HOST/bin
CC=$LLVM_TOOLCHAIN/clang
CXX=$LLVM_TOOLCHAIN/clang++
AS=$CC
AR=$TOOLCHAIN/$TARGET-ar
LD=$TOOLCHAIN/$TARGET-ld
STRIP=$TOOLCHAIN/$TARGET-strip
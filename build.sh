# Linux 交叉编译 Android 库脚本
if [[ -z $ANDROID_NDK ]]; then
    echo 'Error: Can not find ANDROID_NDK path.'
    exit 1
fi

echo "ANDROID_NDK path: ${ANDROID_NDK}"

OUTPUT_DIR="_output_"

mkdir ${OUTPUT_DIR}
cd ${OUTPUT_DIR}

OUTPUT_PATH=`pwd`

API=21
TOOLCHAIN=$ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64
# 编译出的x264库地址
FFMPEG_ANDROID_DIR=/home/dreamgyf/compile/FFmpeg/_output_/product

EXTRA_ATTRS="-DWITH_CUDA=OFF \
    -DWITH_GTK=OFF \
    -DWITH_1394=OFF \
    -DWITH_GSTREAMER=OFF \
    -DWITH_LIBV4L=OFF \
    -DWITH_TIFF=OFF \
    -DBUILD_OPENEXR=OFF \
    -DWITH_OPENEXR=OFF \
    -DBUILD_opencv_ocl=OFF \
    -DWITH_OPENCL=OFF"

function build {
    ABI=$1

    if [[ $ABI == "armeabi-v7a" ]]; then
        ARCH="arm"
        TRIPLE="armv7a-linux-androideabi"
        CROSS_PREFIX="arm-linux-androideabi"
    elif [[ $ABI == "arm64-v8a" ]]; then
        ARCH="arm64"
        TRIPLE="aarch64-linux-android"
        CROSS_PREFIX="aarch64-linux-android"
    elif [[ $ABI == "x86" ]]; then
        ARCH="x86"
        TRIPLE="i686-linux-android"
        CROSS_PREFIX="i686-linux-android"
    elif [[ $ABI == "x86-64" ]]; then
        ARCH="x86_64"
        TRIPLE="x86_64-linux-android"
        CROSS_PREFIX="x86_64-linux-android"
    else
        echo "Unsupported ABI ${ABI}!"
        exit 1
    fi

    echo "Build ABI ${ABI}..."

    rm -rf ${ABI}
    mkdir ${ABI} && cd ${ABI}

    PREFIX=${OUTPUT_PATH}/product/$ABI

    cmake ../.. \
        -DCMAKE_INSTALL_PREFIX=$PREFIX \
        -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake \
        -DANDROID_ABI=$ABI \
        -DANDROID_NDK=$ANDROID_NDK \
        -DANDROID_PLATFORM="android-${API}" \
        -DANDROID_LINKER_FLAGS="-Wl,-rpath-link=$TOOLCHAIN/sysroot/usr/lib/$CROSS_PREFIX/$API" \
        -DBUILD_ANDROID_PROJECTS=OFF \
        -DBUILD_ANDROID_EXAMPLES=OFF \
        -DBUILD_SHARED_LIBS=$BUILD_SHARED_LIBS \
        -DWITH_FFMPEG=ON \
        -DOPENCV_GENERATE_PKGCONFIG=ON \
        -DOPENCV_FFMPEG_USE_FIND_PACKAGE=ON \
        -DFFMPEG_DIR=${FFMPEG_ANDROID_DIR}/${ABI} \
        $EXTRA_ATTRS

    make clean && make -j`nproc` && make install

    cd ..
}

echo "Select arch:"
select arch in "armeabi-v7a" "arm64-v8a" "x86" "x86-64"
do
    echo "Select build static or shared libs:"
    select type in "static" "shared"
    do
        if [[ $type == "static" ]]; then
            BUILD_SHARED_LIBS=OFF
        elif [[ $type == "shared" ]]; then
            BUILD_SHARED_LIBS=ON
        else
            BUILD_SHARED_LIBS=OFF
        fi
        break
    done
    build $arch
    break
done
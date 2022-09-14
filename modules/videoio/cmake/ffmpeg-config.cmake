set(FFMPEG_PATH "${CMAKE_CURRENT_LIST_DIR}")

set(FFMPEG_EXEC_DIR "${FFMPEG_PATH}/bin")
set(FFMPEG_LIBDIR "${FFMPEG_PATH}/lib")
set(FFMPEG_INCLUDE_DIRS "${FFMPEG_PATH}/include")

# library names
set(FFMPEG_LIBRARIES
    ${FFMPEG_LIBDIR}/libavformat.a
    ${FFMPEG_LIBDIR}/libavdevice.a
    ${FFMPEG_LIBDIR}/libavcodec.a
    ${FFMPEG_LIBDIR}/libavutil.a
    ${FFMPEG_LIBDIR}/libswscale.a
    ${FFMPEG_LIBDIR}/libswresample.a
    ${FFMPEG_LIBDIR}/libavfilter.a
    pthread
)

# found status
set(FFMPEG_libavformat_FOUND TRUE)
set(FFMPEG_libavdevice_FOUND TRUE)
set(FFMPEG_libavcodec_FOUND TRUE)
set(FFMPEG_libavutil_FOUND TRUE)
set(FFMPEG_libswscale_FOUND TRUE)
set(FFMPEG_libswresample_FOUND TRUE)
set(FFMPEG_libavfilter_FOUND TRUE)

# library versions
set(FFMPEG_libavformat_VERSION 59.27.100)
set(FFMPEG_libavdevice_VERSION 57.7.100)
set(FFMPEG_libavcodec_VERSION 59.37.100)
set(FFMPEG_libavutil_VERSION 57.28.100)
set(FFMPEG_libswscale_VERSION 6.7.100)
set(FFMPEG_libswresample_VERSION 4.7.100)
set(FFMPEG_libavfilter_VERSION 8.44.100)

set(FFMPEG_FOUND TRUE)
set(FFMPEG_LIBS ${FFMPEG_LIBRARIES})

status("    FFMPEG:"       FFMPEG_FOUND         THEN "YES (find_package)"                       ELSE "NO (find_package)")
status("    avcodec:"      FFMPEG_libavcodec_VERSION    THEN "YES (${FFMPEG_libavcodec_VERSION})"    ELSE NO)
status("    avformat:"     FFMPEG_libavformat_VERSION   THEN "YES (${FFMPEG_libavformat_VERSION})"   ELSE NO)
status("    avutil:"       FFMPEG_libavutil_VERSION     THEN "YES (${FFMPEG_libavutil_VERSION})"     ELSE NO)
status("    swscale:"      FFMPEG_libswscale_VERSION    THEN "YES (${FFMPEG_libswscale_VERSION})"    ELSE NO)
status("    avresample:"   FFMPEG_libavresample_VERSION THEN "YES (${FFMPEG_libavresample_VERSION})" ELSE NO)
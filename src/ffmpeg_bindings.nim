import futhark, os

# Tell futhark where to find the FFmpeg headers
# On Ubuntu, they are usually in /usr/include/x86_64-linux-gnu/
# or just /usr/include/

importc:
  path "/usr/include"
  # Add specific include paths if needed
  # path "/usr/include/x86_64-linux-gnu"
  
  # Libraries to wrap
  "libavcodec/avcodec.h"
  "libavformat/avformat.h"
  "libavutil/avutil.nim"
  "libavutil/imgutils.h"
  "libswscale/swscale.h"
  "libavfilter/avfilter.h"
  "libavdevice/avdevice.h"

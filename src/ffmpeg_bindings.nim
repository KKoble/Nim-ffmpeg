import futhark, os

# Tell futhark where to find the FFmpeg headers
# On Ubuntu, they are usually in /usr/include/x86_64-linux-gnu/
# or just /usr/include/

import futhark, os

# Tell futhark where to find the FFmpeg headers
importc:
  path "/usr/include/x86_64-linux-gnu"
  path "/usr/include"
  
  # Libraries to wrap
  "libavcodec/avcodec.h"
  "libavformat/avformat.h"
  "libavutil/avutil.h"
  "libavutil/imgutils.h"
  "libswscale/swscale.h"
  "libavfilter/avfilter.h"
  "libavdevice/avdevice.h"

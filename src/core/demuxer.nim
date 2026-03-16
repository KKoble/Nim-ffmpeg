import ../ffmpeg_bindings
import os

type
  Demuxer* = ref object
    fmt_ctx: ptr AVFormatContext
    filename: string

proc newDemuxer*(filename: string): Demuxer =
  new(result)
  result.filename = filename
  result.fmt_ctx = nil

proc open*(self: Demuxer): int =
  ## Opens the input file and reads the format information.
  let ret = avformat_open_input(addr self.fmt_ctx, self.filename.cstring, nil, nil)
  if ret < 0:
    return ret
  
  return avformat_find_stream_info(self.fmt_ctx, nil)

proc close*(self: Demuxer) =
  ## Closes the demuxer and frees resources.
  if self.fmt_ctx != nil:
    avformat_close_input(addr self.fmt_ctx)

proc dumpFormat*(self: Demuxer) =
  ## Dumps format information to stderr.
  av_dump_format(self.fmt_ctx, 0, self.filename.cstring, 0)

proc getStreamCount*(self: Demuxer): uint =
  ## Returns the number of streams in the input file.
  if self.fmt_ctx == nil: return 0
  return self.fmt_ctx.nb_streams

proc readPacket*(self: Demuxer, pkt: ptr AVPacket): int =
  ## Reads the next packet from the demuxer.
  return av_read_frame(self.fmt_ctx, pkt)

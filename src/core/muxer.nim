import ../ffmpeg_bindings
import os

type
  Muxer* = ref object
    fmt_ctx: ptr AVFormatContext
    filename: string

proc newMuxer*(filename: string): Muxer =
  new(result)
  result.filename = filename
  result.fmt_ctx = nil
  discard avformat_alloc_output_context2(addr result.fmt_ctx, nil, nil, filename.cstring)

proc open*(self: Muxer): int =
  ## Opens the output file for writing.
  if self.fmt_ctx == nil: return -1
  
  # Open the output file if it's not a special format
  if (self.fmt_ctx.oformat.flags and AVFMT_NOFILE) == 0:
    let ret = avio_open(addr self.fmt_ctx.pb, self.filename.cstring, AVIO_FLAG_WRITE)
    if ret < 0:
      return ret
  
  return avformat_write_header(self.fmt_ctx, nil)

proc close*(self: Muxer) =
  ## Closes the muxer and frees resources.
  if self.fmt_ctx != nil:
    discard av_write_trailer(self.fmt_ctx)
    if (self.fmt_ctx.oformat.flags and AVFMT_NOFILE) == 0:
      discard avio_closep(addr self.fmt_ctx.pb)
    avformat_free_context(self.fmt_ctx)

proc writePacket*(self: Muxer, pkt: ptr AVPacket): int =
  ## Writes a packet to the output file.
  return av_interleaved_write_frame(self.fmt_ctx, pkt)

proc addStream*(self: Muxer, codec: ptr AVCodec): ptr AVStream =
  ## Adds a new stream to the output file.
  return avformat_new_stream(self.fmt_ctx, codec)

import ../ffmpeg_bindings

type
  Decoder* = ref object
    codec_ctx: ptr AVCodecContext
    codec: ptr AVCodec
    stream_index: int

proc newDecoder*(codec_id: AVCodecID, stream_index: int): Decoder =
  new(result)
  result.stream_index = stream_index
  result.codec = avcodec_find_decoder(codec_id)
  if result.codec != nil:
    result.codec_ctx = avcodec_alloc_context3(result.codec)

proc open*(self: Decoder): int =
  ## Opens the decoder.
  if self.codec_ctx == nil: return -1
  return avcodec_open2(self.codec_ctx, self.codec, nil)

proc close*(self: Decoder) =
  ## Closes the decoder and frees resources.
  if self.codec_ctx != nil:
    avcodec_free_context(addr self.codec_ctx)

proc sendPacket*(self: Decoder, pkt: ptr AVPacket): int =
  ## Sends a packet to the decoder.
  return avcodec_send_packet(self.codec_ctx, pkt)

proc receiveFrame*(self: Decoder, frame: ptr AVFrame): int =
  ## Receives a decoded frame from the decoder.
  return avcodec_receive_frame(self.codec_ctx, frame)

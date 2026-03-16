import ../ffmpeg_bindings

type
  Encoder* = ref object
    codec_ctx: ptr AVCodecContext
    codec: ptr AVCodec
    stream_index: int

proc newEncoder*(codec_id: AVCodecID, stream_index: int): Encoder =
  new(result)
  result.stream_index = stream_index
  result.codec = avcodec_find_encoder(codec_id)
  if result.codec != nil:
    result.codec_ctx = avcodec_alloc_context3(result.codec)

proc open*(self: Encoder): int =
  ## Opens the encoder.
  if self.codec_ctx == nil: return -1
  return avcodec_open2(self.codec_ctx, self.codec, nil)

proc close*(self: Encoder) =
  ## Closes the encoder and frees resources.
  if self.codec_ctx != nil:
    avcodec_free_context(addr self.codec_ctx)

proc sendFrame*(self: Encoder, frame: ptr AVFrame): int =
  ## Sends a frame to the encoder.
  return avcodec_send_frame(self.codec_ctx, frame)

proc receivePacket*(self: Encoder, pkt: ptr AVPacket): int =
  ## Receives an encoded packet from the encoder.
  return avcodec_receive_packet(self.codec_ctx, pkt)

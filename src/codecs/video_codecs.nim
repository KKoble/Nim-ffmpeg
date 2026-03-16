import ../ffmpeg_bindings

type
  CodecSupport* = object
    name*: string
    long_name*: string
    id*: AVCodecID
    is_encoder*: bool
    is_decoder*: bool

proc getSupportedVideoCodecs*(): seq[CodecSupport] =
  ## Returns a list of all supported video codecs.
  var codec = av_codec_next(nil)
  while codec != nil:
    if av_codec_is_video(codec) != 0:
      result.add(CodecSupport(
        name: $codec.name,
        long_name: $codec.long_name,
        id: codec.id,
        is_encoder: av_codec_is_encoder(codec) != 0,
        is_decoder: av_codec_is_decoder(codec) != 0
      ))
    codec = av_codec_next(codec)

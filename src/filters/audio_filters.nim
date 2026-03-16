import ../ffmpeg_bindings

type
  AudioResampler* = ref object
    swr_ctx: ptr SwrContext

proc newAudioResampler*(): AudioResampler =
  new(result)
  result.swr_ctx = swr_alloc()

proc init*(self: AudioResampler, out_ch_layout, in_ch_layout: int64, out_sample_rate, in_sample_rate: int, out_sample_fmt, in_sample_fmt: AVSampleFormat): int =
  ## Initializes the audio resampler.
  self.swr_ctx = swr_alloc_set_opts(nil,
    out_ch_layout, out_sample_fmt, out_sample_rate.int32,
    in_ch_layout, in_sample_fmt, in_sample_rate.int32,
    0, nil)
  return swr_init(self.swr_ctx)

proc close*(self: AudioResampler) =
  ## Frees the resampler.
  if self.swr_ctx != nil:
    swr_free(addr self.swr_ctx)

proc convert*(self: AudioResampler, out_data: ptr ptr uint8, out_count: int, in_data: ptr ptr uint8, in_count: int): int =
  ## Converts audio samples.
  return swr_convert(self.swr_ctx, out_data, out_count.int32, in_data, in_count.int32)

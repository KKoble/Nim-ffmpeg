import ../ffmpeg_bindings

type
  FormatSupport* = object
    name*: string
    long_name*: string
    extensions*: seq[string]
    can_demux*: bool
    can_mux*: bool

proc getSupportedFormats*(): seq[FormatSupport] =
  ## Returns a list of all supported container formats.
  var ifmt = av_iformat_next(nil)
  while ifmt != nil:
    result.add(FormatSupport(
      name: $ifmt.name,
      long_name: $ifmt.long_name,
      extensions: if ifmt.extensions != nil: ($ifmt.extensions).split(",") else: @[],
      can_demux: true,
      can_mux: false
    ))
    ifmt = av_iformat_next(ifmt)
  
  var ofmt = av_oformat_next(nil)
  while ofmt != nil:
    result.add(FormatSupport(
      name: $ofmt.name,
      long_name: $ofmt.long_name,
      extensions: if ofmt.extensions != nil: ($ofmt.extensions).split(",") else: @[],
      can_demux: false,
      can_mux: true
    ))
    ofmt = av_oformat_next(ofmt)

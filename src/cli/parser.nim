import os
import strutils
import tables

type
  Options* = object
    inputs*: seq[string]
    outputs*: seq[string]
    video_codec*: string
    audio_codec*: string
    video_filters*: string
    audio_filters*: string
    overwrite*: bool
    verbosity*: int

proc parseArgs*(args: seq[string]): Options =
  ## Parses command-line arguments into an Options object.
  result.inputs = @[]
  result.outputs = @[]
  result.video_codec = "copy"
  result.audio_codec = "copy"
  result.overwrite = false
  result.verbosity = 32 # AV_LOG_INFO
  
  var i = 0
  while i < args.len:
    let arg = args[i]
    case arg
    of "-i":
      if i + 1 < args.len:
        result.inputs.add(args[i+1])
        i += 1
    of "-c:v", "-vcodec":
      if i + 1 < args.len:
        result.video_codec = args[i+1]
        i += 1
    of "-c:a", "-acodec":
      if i + 1 < args.len:
        result.audio_codec = args[i+1]
        i += 1
    of "-vf":
      if i + 1 < args.len:
        result.video_filters = args[i+1]
        i += 1
    of "-af":
      if i + 1 < args.len:
        result.audio_filters = args[i+1]
        i += 1
    of "-y":
      result.overwrite = true
    of "-n":
      result.overwrite = false
    of "-v":
      if i + 1 < args.len:
        result.verbosity = args[i+1].parseInt()
        i += 1
    else:
      if not arg.startsWith("-"):
        result.outputs.add(arg)
    i += 1

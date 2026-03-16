import unittest
import ../src/nimffmpeg
import ../src/cli/parser
import ../src/core/demuxer
import ../src/core/muxer

suite "Nim-ffmpeg Integration Tests":
  test "CLI Argument Parsing":
    let args = @["-i", "input.mp4", "-c:v", "libx264", "-c:a", "aac", "output.mp4"]
    let opts = parseArgs(args)
    check(opts.inputs == @["input.mp4"])
    check(opts.outputs == @["output.mp4"])
    check(opts.video_codec == "libx264")
    check(opts.audio_codec == "aac")

  test "Demuxer Initialization":
    # This test requires a real file, so we just check the object creation
    let demuxer = newDemuxer("test.mp4")
    check(demuxer != nil)

  test "Muxer Initialization":
    let muxer = newMuxer("output.mp4")
    check(muxer != nil)

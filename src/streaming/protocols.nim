import ../ffmpeg_bindings

type
  ProtocolSupport* = object
    name*: string

proc getSupportedProtocols*(): seq[ProtocolSupport] =
  ## Returns a list of all supported network protocols.
  var opaque: pointer = nil
  var protocol_name = avio_enum_protocols(addr opaque, 0)
  while protocol_name != nil:
    result.add(ProtocolSupport(name: $protocol_name))
    protocol_name = avio_enum_protocols(addr opaque, 0)
  
  opaque = nil
  protocol_name = avio_enum_protocols(addr opaque, 1)
  while protocol_name != nil:
    result.add(ProtocolSupport(name: $protocol_name))
    protocol_name = avio_enum_protocols(addr opaque, 1)

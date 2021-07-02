import streams
import strutils

import error
import virtual_machine

type
  Parser = ref object
    stream: Stream
    operations*: seq[Operation]

const numSeparator = 'B'


proc newParser*(stream: Stream): Parser
proc parse*(self: Parser)

proc readOpcode(stream: Stream): OpCode
proc readNum(stream: Stream): int
proc skipWhiteSpace(stream: Stream)


proc newParser*(stream: Stream): Parser =
  new result
  result.stream = stream

proc parse*(self: Parser) =
  while not self.stream.atEnd:
    echo self.stream.atEnd
    let op = newOperation(self.stream.readOpcode)
    self.operations.add(op)
    self.stream.skipWhiteSpace

proc readOpcode(stream: Stream): OpCode =
  var rawCode = ""
  for i in 1..4:
    stream.skipWhiteSpace
    rawCode.add(stream.readChar)
  parseEnum[OpCode](rawCode)

proc readNum(stream: Stream): int =
  if stream.readChar != numSeparator:
    error("Invalid number")
  var rowNum = ""
  while stream.peekChar != numSeparator:
    case stream.readChar
    of 'b':
      rowNum &= $1
    of 'o':
      rowNum &= $0
    else:
      error("Invalid number")
    if stream.atEnd:
      error("Invalid number")
  discard stream.readChar
  fromBin[int](rowNum)

proc skipWhiteSpace(stream: Stream) =
  while stream.peekStr(1).isEmptyOrWhitespace and not stream.atEnd:
    discard stream.readChar

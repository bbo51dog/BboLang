import streams
import strutils

import error
import operation

type
  Parser = ref object
    stream: Stream
    operations*: seq[Operation]

const numSeparator = 'B'
const commentStart = '#'


proc newParser*(stream: Stream): Parser
proc parse*(self: Parser)

proc readOpcode(stream: Stream): OpCode
proc readNum(stream: Stream): int
proc skipWhiteSpace(stream: Stream)
proc skipComment(stream: Stream)


proc newParser*(stream: Stream): Parser =
  new result
  result.stream = stream

proc parse*(self: Parser) =
  while not self.stream.atEnd:
    let opcode = self.stream.readOpcode
    var op: Operation
    if opcode.needOpLand:
      op = newOperation(opcode, newOperand(self.stream.readNum))
    else:
      op = newOperation(opcode)
    self.operations.add(op)
    self.stream.skipComment
    self.stream.skipWhiteSpace

proc readOpcode(stream: Stream): OpCode =
  var rawCode = ""
  for i in 1..5:
    stream.skipComment
    stream.skipWhiteSpace
    rawCode.add(stream.readChar)
  parseEnum[OpCode](rawCode)

proc readNum(stream: Stream): int =
  stream.skipComment
  stream.skipWhiteSpace
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
    stream.skipWhiteSpace
  discard stream.readChar
  fromBin[int](rowNum)

proc skipWhiteSpace(stream: Stream) =
  while stream.peekStr(1).isEmptyOrWhitespace and not stream.atEnd:
    discard stream.readChar

proc skipComment(stream: Stream) =
  stream.skipWhiteSpace
  if stream.peekChar == commentStart:
    while stream.peekChar != '\n' and not stream.atEnd:
      discard stream.readChar
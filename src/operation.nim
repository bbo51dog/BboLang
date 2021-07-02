type
  Operation* = ref object
    opcode*: OpCode
    opland*: OpLand

  OpLand* = ref object
    value: int

  OpCode* {.pure.} = enum
    Add = "bbbb"
    Sub = "bbbo"
    Mul = "bbob"
    Div = "bboo"
    Push = "bobb"
    Pop = "bobo"
    EchoChar = "oobb"
    EchoInt = "oobo"

const needOpLandList = [
  OpCode.Push
]


proc newOperation*(opcode: OpCode, opland: OpLand = nil): Operation
proc newOpLand*(value: int): OpLand

proc needOpLand*(opcode: OpCode): bool

converter toInt*(x: OpLand): int


proc newOperation*(opcode: OpCode, opland: OpLand = nil): Operation =
  new result
  result.opcode = opcode
  result.opland = opland

proc newOpLand*(value: int): OpLand =
  new result
  result.value = value


proc needOpLand*(opcode: OpCode): bool =
  needOpLandList.contains(opcode)


converter toInt*(x: OpLand): int =
  result = x.value

type
  Operation* = ref object
    opcode*: OpCode
    operand*: Operand

  Operand* = ref object
    value: int

  OpCode* {.pure.} = enum
    Add = "bbooo"
    Sub = "bboob"
    Mul = "bbobo"
    Div = "bbobb"
    Mod = "bbboo"

    Push = "boooo"
    Pop = "booob"

    Label = "obooo"
    Jump = "oboob"
    JumpEq = "obobo"
    
    EchoChar = "ooooo"
    EchoInt = "oooob"

const needOpLandList = [
  OpCode.Push,
  OpCode.Label,
  OpCode.Jump,
  OpCode.JumpEq,
]


proc newOperation*(opcode: OpCode, operand: Operand = nil): Operation
proc newOperand*(value: int): Operand

proc needOpLand*(opcode: OpCode): bool

converter toInt*(x: Operand): int


proc newOperation*(opcode: OpCode, operand: Operand = nil): Operation =
  new result
  result.opcode = opcode
  result.operand = operand

proc newOperand*(value: int): Operand =
  new result
  result.value = value


proc needOpLand*(opcode: OpCode): bool =
  needOpLandList.contains(opcode)


converter toInt*(x: Operand): int =
  result = x.value

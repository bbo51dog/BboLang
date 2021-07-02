type
  Operation* = ref object
    opcode: OpCode
    opland: OpLand

  OpLand* = ref object

  OpCode* {.pure.} = enum
    Add = "bbbb"
    Sub = "bbbo"
    Mul = "bbob"
    Div = "bboo"
    Push = "bobb"
    Pop = "bobo"
    EchoChar = "oobb"
    EchoInt = "oobo"


proc newOperation*(opcode: OpCode): Operation
proc newOpLand*(): OpLand


proc newOperation*(opcode: OpCode): Operation =
  new result
  result.opcode = opcode

proc newOpLand*(): OpLand =
  new result

import streams

type
  Stack = ref object
    values: @[int]

  OpCode = enum
    Push
    Pop
    Add
    Sub
    Mul
    Div

  VirtualMachine = ref object
    stack: Stack
    stream: Stream

proc newVirtualMachine*(stream: Stream): VirtualMachine =
  new result
  result.stream = stream

proc exec*(vm: VirtualMachine) =
  while not stream.atEnd:
    echo stream.readChar

proc push(stack: Stack, value: int) =
  stack.values.add(value)

proc pop(stack: Stack): int =
  stack.values.pop

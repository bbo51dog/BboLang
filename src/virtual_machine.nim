import error

type
  Stack = ref object
    values: seq[int]

  Operation* = ref object
    opcode: OpCode

  OpCode* {.pure.} = enum
    Add = "bbbb"
    Sub = "bbbo"
    Mul = "bbob"
    Div = "bboo"
    Push = "bobb"
    Pop = "bobo"
    EchoChar = "oobb"
    EchoInt = "oobo"

  VirtualMachine = ref object
    stack: Stack


proc newVirtualMachine*(): VirtualMachine
proc run*(vm: VirtualMachine)

proc newOperation*(opcode: OpCode): Operation

proc exec(vm: VirtualMachine, op: OpCode)

proc pop(stack: Stack): int
proc push(stack: Stack, value: int)


proc newVirtualMachine*(): VirtualMachine =
  new result
  result.stack = Stack()

proc run*(vm: VirtualMachine) =
  #[
  while not vm.stream.atEnd:
    vm.exec(vm.readOpcode)
  ]#
  discard


proc newOperation*(opcode: OpCode): Operation =
  new result
  result.opcode = opcode


proc exec(vm: VirtualMachine, op: OpCode) =
  case op
  of OpCode.Add:
    let x = vm.stack.pop
    let y = vm.stack.pop
    vm.stack.push(x + y)
  of OpCode.Sub:
    let x = vm.stack.pop
    let y = vm.stack.pop
    vm.stack.push(x - y)
  of OpCode.Mul:
    let x = vm.stack.pop
    let y = vm.stack.pop
    vm.stack.push(x * y)
  of OpCode.Div:
    let x = vm.stack.pop
    let y = vm.stack.pop
    vm.stack.push(int(x / y))
  of OpCode.Push:
    #vm.stack.push(vm.readNum)
    discard
  of OpCode.Pop:
    discard vm.stack.pop
  of OpCode.EchoChar:
    stdout.write(char(vm.stack.pop))
  of OpCode.EchoInt:
    stdout.write($vm.stack.pop)


proc push(stack: Stack, value: int) =
  stack.values.add(value)

proc pop(stack: Stack): int =
  stack.values.pop

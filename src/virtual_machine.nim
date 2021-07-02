import operation

type
  Stack = ref object
    values: seq[int]

  VirtualMachine = ref object
    stack: Stack
    operations: seq[Operation]


proc newVirtualMachine*(operations: openArray[Operation]): VirtualMachine
proc run*(vm: VirtualMachine)

proc exec(vm: VirtualMachine, op: Operation)

proc pop(stack: Stack): int
proc push(stack: Stack, value: int)


proc newVirtualMachine*(operations: openArray[Operation]): VirtualMachine =
  new result
  result.stack = Stack()
  result.operations = @operations

proc run*(vm: VirtualMachine) =
  for op in vm.operations:
    vm.exec(op)


proc exec(vm: VirtualMachine, op: Operation) =
  case op.opcode
  of OpCode.Add:
    let x = vm.stack.pop
    let y = vm.stack.pop
    vm.stack.push(y + x)
  of OpCode.Sub:
    let x = vm.stack.pop
    let y = vm.stack.pop
    vm.stack.push(y - x)
  of OpCode.Mul:
    let x = vm.stack.pop
    let y = vm.stack.pop
    vm.stack.push(y * x)
  of OpCode.Div:
    let x = vm.stack.pop
    let y = vm.stack.pop
    vm.stack.push(int(y / x))
  of OpCode.Push:
    vm.stack.push(op.opland)
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

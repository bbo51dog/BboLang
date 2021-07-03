import streams

import operation

type
  Stack = ref object
    values: seq[int]

  VirtualMachine = ref object
    stack: Stack
    operations: seq[Operation]
    outputStream: Stream


proc newVirtualMachine*(operations: openArray[Operation], outputStream: Stream): VirtualMachine
proc run*(vm: VirtualMachine)

proc exec(vm: VirtualMachine, op: Operation)

proc pop(stack: Stack): int
proc push(stack: Stack, value: int)


proc newVirtualMachine*(operations: openArray[Operation], outputStream: Stream): VirtualMachine =
  new result
  result.stack = Stack()
  result.operations = @operations
  result.outputStream = outputStream

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
    vm.stack.push(op.operand)
  of OpCode.Pop:
    discard vm.stack.pop
  of OpCode.EchoChar:
    vm.outputStream.write(char(vm.stack.pop))
  of OpCode.EchoInt:
    vm.outputStream.write($vm.stack.pop)


proc push(stack: Stack, value: int) =
  stack.values.add(value)

proc pop(stack: Stack): int =
  stack.values.pop

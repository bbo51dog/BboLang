import streams
import tables

import operation

type
  Stack = ref object
    values: seq[int]

  VirtualMachine = ref object
    stack: Stack
    operations: seq[Operation]
    currentOpIndex: int
    outputStream: Stream
    labels: Table[int, int]


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
  for i, op in operations:
    if op.opcode == OpCode.Label:
      result.labels[op.operand] = i

proc run*(vm: VirtualMachine) =
  while vm.currentOpIndex < vm.operations.len:
    vm.exec(vm.operations[vm.currentOpIndex])
    vm.currentOpIndex += 1


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
  of OpCode.Mod:
    let x = vm.stack.pop
    let y = vm.stack.pop
    vm.stack.push(y mod x)
  of OpCode.Push:
    vm.stack.push(op.operand)
  of OpCode.Pop:
    discard vm.stack.pop
  of OpCode.Label:
    discard
  of OpCode.Jump:
    vm.currentOpIndex = vm.labels[op.operand]
  of OpCode.JumpEq:
    if vm.stack.pop == vm.stack.pop:
      vm.currentOpIndex = vm.labels[op.operand]
  of OpCode.EchoChar:
    vm.outputStream.write(char(vm.stack.pop))
  of OpCode.EchoInt:
    vm.outputStream.write($vm.stack.pop)


proc push(stack: Stack, value: int) =
  stack.values.add(value)

proc pop(stack: Stack): int =
  stack.values.pop

import streams
import tables

import operation

type
  Stack = ref object
    values: seq[int]

  Heap = ref object
    values: Table[int, int]

  VirtualMachine = ref object
    stack: Stack
    heap: Heap
    operations: seq[Operation]
    currentOpIndex: int
    outputStream: Stream
    labels: Table[int, int]


proc newVirtualMachine*(operations: openArray[Operation], outputStream: Stream): VirtualMachine
proc run*(vm: VirtualMachine)

proc exec(vm: VirtualMachine, op: Operation)

proc pop(stack: Stack): int
proc push(stack: Stack, value: int)

proc load(heap: Heap, address: int): int
proc store(heap: Heap, address: int, value: int)


proc newVirtualMachine*(operations: openArray[Operation], outputStream: Stream): VirtualMachine =
  new result
  result.stack = Stack()
  result.heap = Heap()
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
  of OpCode.Load:
    vm.stack.push(vm.heap.load(op.operand))
  of OpCode.Store:
    vm.heap.store(op.operand, vm.stack.pop)
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


proc load(heap: Heap, address: int): int =
  heap.values[address]

proc store(heap: Heap, address: int, value: int) =
  heap.values[address] = value

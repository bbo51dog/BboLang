import streams
import strutils

import error

type
  Stack = ref object
    values: seq[int]

  OpCode {.pure.} = enum
#    Pop = "bbb"
    Push = "bbo"
    Add = "bob"
    Sub = "obb"
    Mul = "boo"
#    Div = "obo"

  VirtualMachine = ref object
    stack: Stack
    stream: Stream

const numSeparator = 'B'


proc newVirtualMachine*(stream: Stream): VirtualMachine
proc run*(vm: VirtualMachine)

proc readOpcode(vm: VirtualMachine): OpCode
proc readNum(vm: VirtualMachine): int
proc exec(vm: VirtualMachine, op: OpCode)

proc pop(stack: Stack): int
proc push(stack: Stack, value: int)


proc newVirtualMachine*(stream: Stream): VirtualMachine =
  new result
  result.stack = Stack()
  result.stream = stream

proc run*(vm: VirtualMachine) =
  while not vm.stream.atEnd:
    vm.exec(vm.readOpcode)
  echo repr vm.stack.values

proc readOpcode(vm: VirtualMachine): OpCode =
  parseEnum[OpCode](vm.stream.readStr(3))

proc readNum(vm: VirtualMachine): int =
  if vm.stream.readChar != numSeparator:
    error("Invalid number")
  var rowNum = ""
  while vm.stream.peekChar != numSeparator:
    case vm.stream.readChar
    of 'b':
      rowNum &= $1
    of 'o':
      rowNum &= $0
    else:
      error("Invalid number")
    if vm.stream.atEnd:
      error("Invalid number")
  discard vm.stream.readChar
  fromBin[int](rowNum)

proc exec(vm: VirtualMachine, op: OpCode) =
  case op
  of OpCode.Push:
    vm.stack.push(vm.readNum)
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
  #[
  of OpCode.Div:
    let x = vm.stack.pop
    let y = vm.stack.pop
    vm.stack.push(x / y)
  ]#

proc push(stack: Stack, value: int) =
  stack.values.add(value)

proc pop(stack: Stack): int =
  stack.values.pop

import unittest

import streams
import strformat

import parser
import virtual_machine

proc stringInterpreter(path: string): string =
  let parser = newParser(newFileStream(path))
  parser.parse
  let outputStream = newStringStream("")
  let vm = newVirtualMachine(parser.operations, outputStream)
  vm.run
  outputStream.data

proc assertInterpreter(path: string, expect: string) =
  let result = stringInterpreter(path)
  assert result == expect, fmt"'{expect}' expected, '{result}' returned"

suite "Interpreter":
  test "Hello world":
    assertInterpreter("tests/code/HelloWorld.bbolang", "Hello, World!")

  test "Calculate":
    assertInterpreter("tests/code/Calculate.bbolang", $8)

  test "Jump":
    assertInterpreter("tests/code/Jump.bbolang", $5)

  test "JupIf":
    assertInterpreter("tests/code/JumpIf.bbolang", $4)

  test "Heap":
    assertInterpreter("tests/code/Heap.bbolang", $7)

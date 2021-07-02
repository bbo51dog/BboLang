import unittest

import streams

import parser
import virtual_machine

proc stringInterpreter(path: string): string =
  let parser = newParser(newFileStream(path))
  parser.parse
  let outputStream = newStringStream("")
  let vm = newVirtualMachine(parser.operations, outputStream)
  vm.run
  outputStream.data

suite "Interpreter":
  test "Hello world":
    assert stringInterpreter("tests/code/HelloWorld.bbolang") == "Hello, World!"

  test "Calculate":
    assert stringInterpreter("tests/code/Calculate.bbolang") == $8

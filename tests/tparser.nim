import unittest

import streams

import operation
import parser

suite "Parser":
  test "parse":
    let source = """
    oooob
    """
    let expect = [
      newOperation(OpCode.EchoInt)
    ]
    let parser = newParser(newStringStream(source))
    parser.parse
    for i, op in parser.operations:
      assert op[] == expect[i][]

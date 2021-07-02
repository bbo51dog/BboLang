import unittest

import streams

import parser

suite "Parser":
  test "parse":
    let source = """
    oobo
    """
    let parser = newParser(newStringStream(source))
    parser.parse
    echo repr parser

import os
import streams
import strformat

import error
import parser
import virtual_machine

if isMainModule:
  if paramCount() < 1:
    error("No source file passed")
  let sourceFile = commandLineParams()[0]
  if not fileExists(sourceFile):
    error(fmt"File '{sourceFile}' was not exists")
  let parser = newParser(newFileStream(sourceFile))
  parser.parse
  let vm = newVirtualMachine(parser.operations)
  vm.run

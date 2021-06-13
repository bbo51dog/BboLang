import os
import streams
import strformat
import terminal

import virtual_machine

proc error(message: string) =
  stdout.styledWrite(fgRed, "Error: ", resetStyle)
  stdout.writeLine(message)
  quit 1

if isMainModule:
  if paramCount() < 1:
    error("No source file passed")
  let sourceFile = commandLineParams()[0]
  if not fileExists(sourceFile):
    error(fmt"File '{sourceFile}' was not exists")
  let vm = newVirtualMachine(newFileStream(sourceFile))
  vm.exec

import os
import streams
import strformat
import terminal

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
  let stream = newFileStream(sourceFile)
  while not stream.atEnd:
    echo stream.readChar
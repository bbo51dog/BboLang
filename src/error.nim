import terminal

proc error*(message: string) =
  stdout.styledWrite(fgRed, "Error: ", resetStyle)
  stdout.writeLine(message)
  quit 1
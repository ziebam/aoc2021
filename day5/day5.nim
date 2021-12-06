import std/sequtils
import std/strutils

type
    Line = object
        startX: int
        startY: int
        endX: int
        endY: int

proc loadData(path: string): seq[Line] =
    let data: File = open(path)
    defer: data.close()

    var line: string

    while readLine(data, line):
        let coords = line.split(" -> ")
        let startCoords = map(coords[0].split(","), proc (coord: string): int = parseInt(coord))
        let endCoords = map(coords[1].split(","), proc (coord: string): int = parseInt(coord))

        result.add(Line(
            startX: startCoords[0],
            startY: startCoords[1],
            endX: endCoords[0],
            endY: endCoords[1]
        ))

proc findSize(lines: seq[Line]): array[0..1, int] =
    let maxX: int = max(map(lines, proc (line: Line): int = max(line.startX, line.endX)))
    let maxY: int = max(map(lines, proc (line: Line): int = max(line.startY, line.endY)))

    result = [maxX + 1, maxY + 1]

proc partOne(lines: seq[Line]): int =
    let straightLines = filter(lines, proc (line: Line): bool = line.startX == line.endX or line.startY == line.endY)
    
    let size = findSize(straightLines)
    let sizeX = size[0]
    let sizeY = size[1]

    var diagram: seq[seq[int]]
    for i in 0..sizeY - 1:
        diagram.add(newSeq[int](sizeX))

    for line in straightLines:
        let horizontal = line.startY == line.endY
        if horizontal:
            for x in min(line.startX, line.endX)..max(line.startX, line.endX):
                inc diagram[line.startY][x]
        else:
            for y in min(line.startY, line.endY)..max(line.startY, line.endY):
                inc diagram[y][line.startX]

    for row in diagram:
        for position in row:
            if position > 1:
                result += 1

let lines = loadData("day5/day5.txt")

echo "Part one: ", partOne(lines)
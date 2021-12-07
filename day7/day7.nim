import std/sequtils
import std/strutils

proc loadData(path: string): seq[int] =
    result = map(readFile(path).split(","), proc(position: string): int = parseInt(position))

proc partOne(positions: seq[int]): int =
    let lowestPosition = min(positions)
    let highestPosition = max(positions)

    var results: seq[int]
    for i in lowestPosition..highestPosition:
        var fuel: int = 0
        for position in positions:
            fuel += abs(position - i)
        results.add(fuel)
    result = min(results)

proc partTwo(positions: seq[int]): int =
    let lowestPosition = min(positions)
    let highestPosition = max(positions)

    var results: seq[int]
    for i in lowestPosition..highestPosition:
        var fuel: int = 0
        for position in positions:
            for j in 1..abs(position - i):
                fuel += j
        results.add(fuel)
    result = min(results)

let positions = loadData("day7/day7.txt")

echo "Part one: ", partOne(positions)
echo "Part two: ", partTwo(positions)
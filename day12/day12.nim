import std/strutils
import std/tables

type
    CaveGraph = Table[string, tuple[connections: seq[string], visits: int]]

proc loadData(path: string): CaveGraph =
    let connections: File = open(path)
    defer: connections.close()

    var connection: string
    while readLine(connections, connection):
        let nodes = connection.split("-")

        let caveA = nodes[0]
        let caveB = nodes[1]

        if result.hasKey(caveA):
            result[caveA].connections.add(caveB)
            result[caveA].visits = 0
        else:
            result[caveA] = (connections: @[caveB], visits: 0)

        if result.hasKey(caveB):
            result[caveB].connections.add(caveA)
            result[caveB].visits = 0
        else:
            result[caveB] = (connections: @[caveA], visits: 0)

proc findPaths(caves: CaveGraph, start: string, target: string, specialSmallCave: string = ""): int =
    var caves = caves

    if start == "start" or start.toLowerAscii() == start:
        inc caves[start].visits
    
    if start == target:
        return 1

    for cave in caves[start].connections:
        if specialSmallCave.len == 0 and caves[cave].visits == 0:
            result += findPaths(caves, cave, target)
        else:
            let isSpecialSmallCave = cave == specialSmallCave

            if isSpecialSmallCave and caves[cave].visits < 2:
                result += findPaths(caves, cave, target, specialSmallCave)
            elif caves[cave].visits == 0:
                result += findPaths(caves, cave, target, specialSmallCave)

proc partOneAndTwo(caves: CaveGraph, partOne: static bool = true): int =
    var caves = caves

    let partOneResult = findPaths(caves, "start", "end")

    when partOne:
        return partOneResult
    else:
        var smallCaves: seq[string] = @[]

        for cave in caves.keys:
            if cave.toLowerAscii() == cave and cave != "start" and cave != "end":
                smallCaves.add(cave)

        var partTwoResult = 0
        for smallCave in smallCaves:
            partTwoResult += findPaths(caves, "start", "end", smallCave)

        let duplicatesCount = smallCaves.len - 1
        return partTwoResult - duplicatesCount * partOneResult

let caves = loadData("day12/day12.txt")

echo "Part one: ", partOneAndTwo(caves)
echo "Part two: ", partOneAndTwo(caves, false)
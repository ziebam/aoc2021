import std/algorithm
import std/sequtils
import std/strutils
import std/tables

type
    Polymerization = object
        pTemplate: string
        rules: Table[string, char]

proc loadData(path: string): Polymerization =
    let manual: File = open(path)
    defer: manual.close()

    var line: string
    var pTemplate: bool = true
    while readLine(manual, line):
        if pTemplate:
            result.pTemplate = line
            pTemplate = false
        elif line.len > 0:
            let rule = line.split(" -> ")
            let pair = rule[0]
            let insert = rule[1]

            result.rules[pair] = insert[0]

proc getPairs(pTemplate: string): seq[string] =
    for idx, element in pTemplate[0..<pTemplate.len - 1]:
        result.add(join([element, pTemplate[idx + 1]]))

proc partOne(polymerization: Polymerization, steps: int): int =
    var polymerization = polymerization
    for i in 1..steps:
        let pairs = getPairs(polymerization.pTemplate)

        var toInsert: seq[tuple[idx: int, element: char]]
        for idx, pair in pairs:
            if polymerization.rules.hasKey(pair):
                toInsert.add((idx: idx + 1, element: polymerization.rules[pair]))

        for insertion in toInsert.reversed:
            polymerization.pTemplate.insert($insertion.element, insertion.idx)

    var characterCounts = toCountTable(polymerization.pTemplate)

    let largest = characterCounts.largest.key
    let smallest = characterCounts.smallest.key

    result = characterCounts[largest] - characterCounts[smallest]


let polymerization = loadData("day14/day14.txt")

echo "Part one: ", partOne(polymerization, 10)
            
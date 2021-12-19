import std/strformat
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


type
    Pair = object
        count: int
        identifier: string
        createsElement: char
        createsPairs: array[0..1, string]

proc getInitialPairs(rules: Table[string, char]): seq[Pair] =
    for pair, element in rules.pairs:
        result.add(Pair(count: 0, identifier: pair, createsElement: element, createsPairs: [fmt"{pair[0]}{element}", fmt"{element}{pair[1]}"]))

proc partOneAndTwo(polymerization: Polymerization, steps: int): int =
    var polymerization = polymerization

    var emptyPairObjects = getInitialPairs(polymerization.rules)
    var currentPairs = emptyPairObjects
    var elementCounts: Table[char, int]
    for element in polymerization.rules.values:
        if not elementCounts.hasKey(element):
            elementCounts[element] = 0
    for c in polymerization.pTemplate:
        inc elementCounts[c]
    for pair in getPairs(polymerization.pTemplate):
        for currentPair in currentPairs.mitems:
            if currentPair.identifier == pair:
                inc currentPair.count

    for i in 1..steps:
        var newPairs = emptyPairObjects

        for pair in currentPairs:
            elementCounts[pair.createsElement] += pair.count
            for createdPair in pair.createsPairs:
                for newPair in newPairs.mitems:
                    if newPair.identifier == createdPair:
                        newPair.count += pair.count
        
        currentPairs = newPairs

    var smallest = 0
    var largest = 0

    var idx = 0
    for element in elementCounts.values:
        if idx == 0:
            smallest = element

        if element > largest:
            largest = element
        
        if element < smallest:
            smallest = element

        inc idx

    result = largest - smallest


let polymerization = loadData("day14/day14.txt")

echo "Part one: ", partOneAndTwo(polymerization, 10)
echo "Part two: ", partOneAndTwo(polymerization, 40)
            
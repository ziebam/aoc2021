import std/sequtils
import std/strutils

type
    Octopus = object
        posY: int
        posX: int
        energy: int
        flashedThisStep: bool

proc loadData(path: string): seq[seq[Octopus]] =
    let octopuses: File = open(path)
    defer: octopuses.close()

    var idxY = 0
    var row: string
    while readLine(octopuses, row):
        var rowOfOctopuses: seq[Octopus] = @[]

        for idxX, octopus in row:
            rowOfOctopuses.add(Octopus(posY: idxY, posX: idxX, energy: parseInt($octopus), flashedThisStep: false))
        inc idxY

        result.add(rowOfOctopuses)

proc getNeighbors(octopus: Octopus, octopuses: seq[seq[Octopus]]): seq[Octopus] =
    # Top neighbors.
    if octopus.posY > 0:
        if octopus.posX > 0:
            result.add(octopuses[octopus.posY - 1][octopus.posX - 1])

        result.add(octopuses[octopus.posY - 1][octopus.posX])

        if octopus.posX < octopuses[0].len - 1:
            result.add(octopuses[octopus.posY - 1][octopus.posX + 1])

    # Left neighbor.
    if octopus.posX > 0:
        result.add(octopuses[octopus.posY][octopus.posX - 1])

    # Right neighbor.
    if octopus.posX < octopuses[0].len - 1:
        result.add(octopuses[octopus.posY][octopus.posX + 1])

    # Bottom neighbors.
    if octopus.posY < octopuses.len - 1:
        if octopus.posX > 0:
            result.add(octopuses[octopus.posY + 1][octopus.posX - 1])

        result.add(octopuses[octopus.posY + 1][octopus.posX])

        if octopus.posX < octopuses[0].len - 1:
            result.add(octopuses[octopus.posY + 1][octopus.posX + 1])

proc calculateStep(octopuses: var seq[seq[Octopus]]): int =
    for row in octopuses.mitems:
        for octopus in row.mitems:
            inc octopus.energy

    while any(concat(octopuses), proc (octopus: Octopus): bool = octopus.energy > 9):
        for row in octopuses.mitems:
            for octopus in row.mitems:
                if octopus.energy > 9 and not octopus.flashedThisStep:
                    octopus.energy = 0
                    octopus.flashedThisStep = true

                    var neighbors = getNeighbors(octopus, octopuses)
                    for neighbor in neighbors.mitems:
                        if not neighbor.flashedThisStep:
                            inc octopuses[neighbor.posY][neighbor.posX].energy


    for row in octopuses.mitems:
        for octopus in row.mitems:
            if octopus.flashedThisStep:
                inc result
                octopus.flashedThisStep = false

proc partOneAndTwo(octopuses: seq[seq[Octopus]], partOne: static bool = true): int =
    var octopuses = octopuses
    when partOne:
        for i in 1..100:
            result += calculateStep(octopuses)
    when not partOne:
        var stepNumber = 0
        while true:
            inc stepNumber

            let flashesThisStep = calculateStep(octopuses)
            if flashesThisStep == 100:
                return stepNumber


let octopuses = loadData("day11/day11.txt")

echo "Part one: ", partOneAndTwo(octopuses)
echo "Part two: ", partOneAndTwo(octopuses, false)

    
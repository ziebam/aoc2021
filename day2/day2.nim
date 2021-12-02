import std/strutils

type
    Command = object
        direction: string
        units: int

type
    Solution = object
        horizontalPos: int
        depth: int
        aim: int

proc loadData(path: string): seq[Command] =
    let data: File = open(path)
    defer: data.close()

    var line: string

    while readLine(data, line):
        let line: seq[string] = line.split(" ")
        let direction: string = line[0]
        let units: int = parseInt(line[1])

        result.add(Command(direction: direction, units: units))

proc partOneAndTwo(part: int): Solution =
    let commands: seq[Command] = loadData("day2/day2.txt")

    for command in commands:
        case command.direction
        of "forward":
            if part == 1: result.horizontalPos += command.units
            elif part == 2:
                result.horizontalPos += command.units
                result.depth += command.units * result.aim
        of "down":
            if part == 1: result.depth += command.units
            elif part == 2: result.aim += command.units
        of "up":
            if part == 1: result.depth -= command.units
            elif part == 2: result.aim -= command.units


let partOne: Solution = partOneAndTwo(1)
let partTwo: Solution = partOneAndTwo(2)

echo "Part one: ", partOne.horizontalPos * partOne.depth
echo "Part two: ", partTwo.horizontalPos * partTwo.depth
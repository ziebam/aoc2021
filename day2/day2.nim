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
        let line = line.split(" ")
        let direction = line[0]
        let units = parseInt(line[1])

        result.add(Command(direction: direction, units: units))

proc partOne(): Solution =
    let commands = loadData("day2/day2.txt")

    for command in commands:
        case command.direction
        of "forward":
            result.horizontalPos += command.units
        of "down":
            result.depth += command.units
        of "up":
            result.depth -= command.units

proc partTwo(): Solution =
    let commands = loadData("day2/day2.txt")

    for command in commands:
        case command.direction
        of "down":
            result.aim += command.units
        of "up":
            result.aim -= command.units
        of "forward":
            result.horizontalPos += command.units
            result.depth += command.units * result.aim


let solution = partOne()
echo solution.horizontalPos * solution.depth

let solution2 = partTwo()
echo solution2.horizontalPos * solution2.depth
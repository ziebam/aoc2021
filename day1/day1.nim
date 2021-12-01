from std/parseutils import parseInt
from std/math import sum

proc loadData(path: string): seq[int] =
    let data = open(path)
    defer: data.close()

    var measurements: seq[int] = @[]
    var line: string

    while readLine(data, line):
        var measurement: int
        discard parseInt(line, measurement, 0)
        measurements.add(measurement)

    return measurements

proc partOne(): int =
    let measurements: seq[int] = loadData("day1/day1.txt")

    var solution: int = 0
    for index, measurement in measurements:
        if index != 0 and measurements[index] - measurements[index - 1] > 0:
            solution += 1

    return solution

proc partTwo(): int =
    let measurements: seq[int] = loadData("day1/day1.txt")

    var solution: int = 0
    for index, measurement in measurements[0 .. ^4]:
        let firstWindowSum = sum(measurements[index .. index + 2])
        let secondWindowSum = sum(measurements[index + 1 .. index + 3])

        if secondWindowSum - firstWindowSum > 0:
            solution += 1

    return solution

echo "Part one: ", partOne()
echo "Part two: ", partTwo()
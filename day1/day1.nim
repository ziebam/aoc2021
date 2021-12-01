from std/parseutils import parseInt

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

echo partOne()
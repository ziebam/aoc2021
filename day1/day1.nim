import std/strutils

proc loadData(path: string): seq[int] =
    let data: File = open(path)
    defer: data.close()

    var line: string

    while readLine(data, line): result.add(parseInt(line))

proc partOneAndTwo(windowSize: int): int =
    let measurements: seq[int] = loadData("day1/day1.txt")

    let lastIndex: BackwardsIndex = ^(windowSize + 1)
    for index, measurement in measurements[0 .. lastIndex]:
        if measurements[index + windowSize] - measurements[index] > 0:
            inc result

echo "Part one: ", partOneAndTwo(1)
echo "Part two: ", partOneAndTwo(3)
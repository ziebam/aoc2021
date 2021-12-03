import std/strutils

proc loadData(path: string): seq[string] =
    let data: File = open(path)
    defer: data.close()

    var line: string

    while readLine(data, line): result.add(line)

proc partOne(): int =
    let binNumbers: seq[string] = loadData("day3/day3.txt")

    var bitCounts = newSeq[int](len(binNumbers[0]))
    for binNumber in binNumbers:
        for index, bit in binNumber:
            if bit == '1':
                inc bitCounts[index]

    var gammaRate, epsilonRate = ""
    for bit in bitCounts:
        if bit > (len(binNumbers) / 2).int:
            gammaRate.add('1')
            epsilonRate.add('0')
        else:
            gammaRate.add('0')
            epsilonRate.add('1')

    return parseBinInt(gammaRate) * parseBinInt(epsilonRate)

echo partOne()
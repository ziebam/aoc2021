import std/strutils
import std/tables

proc loadData(path: string): seq[string] =
    let data: File = open(path)
    defer: data.close()

    var line: string

    while readLine(data, line): result.add(line)

proc partOne(): int =
    let binNumbers: seq[string] = loadData("day3/day3.txt")

    var oneBits = initTable[int, int]()
    for binNumber in binNumbers:
        for index, bit in binNumber:
            if $bit == "1":
                if not oneBits.hasKey(index):
                    oneBits[index] = 0
                else:
                    oneBits[index] += 1

    var gammaRate = "000000000000"
    for key in oneBits.keys:
        if oneBits[key] > 500:
            gammaRate[key] = '1'

    var epsilonRate = ""
    for bit in gammaRate:
        if bit == '0':
            epsilonRate.add('1')
        else:
            epsilonRate.add('0')

    return parseBinInt(gammaRate) * parseBinInt(epsilonRate)

echo partOne()
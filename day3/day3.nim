import std/math
import std/sequtils
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

proc countBitsAtIndex(binNumbers: seq[string], index: int): int =
    for binNumber in binNumbers:
        if binNumber[index] == '1':
            inc result

proc partTwo(): int =
    var binNumbers: seq[string] = loadData("day3/day3.txt")

    var index = 0
    while len(binNumbers) > 1:
        let bitCount = countBitsAtIndex(binNumbers, index)
        var majorityBit: char
        if bitCount >= (round(len(binNumbers) / 2)).int:
            majorityBit = '1'
        else:
            majorityBit = '0'
        binNumbers = filter(binNumbers, proc(binNumber: string): bool = binNumber[index] == majorityBit)
        inc index
    let oxygenGeneratorRating = binNumbers[0]

    binNumbers = loadData("day3/day3.txt")
    index = 0
    while len(binNumbers) > 1:
        let bitCount = countBitsAtIndex(binNumbers, index)
        var minorityBit: char
        if bitCount < (round(len(binNumbers) / 2)).int:
            minorityBit = '1'
        else:
            minorityBit = '0'
        binNumbers = filter(binNumbers, proc(binNumber: string): bool = binNumber[index] == minorityBit)
        inc index
    let carbonDioxideScrubberRating = binNumbers[0]

    return parseBinInt(oxygenGeneratorRating) * parseBinInt(carbonDioxideScrubberRating)

echo "Part one: ", partOne()
echo "Part two: ", partTwo()
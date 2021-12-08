import std/setutils
import std/strutils

type
    Entry = object
        patterns: seq[string]
        output: seq[string]

proc loadData(path: string): seq[Entry] =
    let entries: File = open(path)
    defer: entries.close()

    var entry: string
    while readLine(entries, entry):
        let splitEntry = entry.split(" | ")
        let patterns = splitEntry[0].split(" ")
        let output = splitEntry[1].split(" ")

        result.add(Entry(patterns: patterns, output: output))

proc ordSum(pattern: string): int =
    for c in pattern:
        result += ord(c)

proc partOne(entries: seq[Entry]): int =
    for entry in entries:
        for digit in entry.output:
            if digit.len == 2 or digit.len == 4 or digit.len == 3 or digit.len == 7:
                inc result

type
    Display = object
        digits: seq[string]
        zero: string
        one: string
        two: string
        three: string
        four: string
        five: string
        six: string
        seven: string
        eight: string
        nine: string
        top: char
        middle: char
        bottom: char
        topLeft: char
        topRight: char
        bottomLeft: char
        bottomRight: char

proc partTwo(entries: seq[Entry]): int =
    for entry in entries:
        var display = Display()
        
        # Get numbers with a unique number of segments.
        for digit in entry.patterns:
            if digit.len == 2:
                display.one = digit
            elif digit.len == 4:
                display.four = digit
            elif digit.len == 3:
                display.seven = digit
            elif digit.len == 7:
                display.eight = digit

        # Get the top segment, the only segment not shared between seven and one.
        for c in display.seven:
            if not display.one.contains(c):
                display.top = c
        
        # Get zero.
        for digit in entry.patterns:
            if digit.len == 6:
                var digitsInCommonWithOne = 0
                var digitsInCommonWithFour = 0
                for c in digit:
                    if display.one.contains(c):
                        inc digitsInCommonWithOne
                    if display.four.contains(c):
                        inc digitsInCommonWithFour
                
                # Zero is the only digit that shares 2 segments with one and 3 segments with four.
                if digitsInCommonWithOne == 2 and digitsInCommonWithFour == 3:
                    display.zero = digit
                    break

        # Get the middle segment, the only segment not shared between four and zero.
        for c in display.four:
            if not display.zero.contains(c):
                display.middle = c
                break

        # Get three, the only 5-segment number that shares two segments with one.
        for digit in entry.patterns:
            if digit.len == 5:
                var digitsInCommonWithOne = 0
                for c in display.one:
                    if digit.contains(c):
                        inc digitsInCommonWithOne
                
                if digitsInCommonWithOne == 2:
                    display.three = digit

        # Get the bottom segment. We found top and middle already, so the segment not shared
        # between three and one is the bottom.
        for c in display.three:
            if not display.one.contains(c) and c != display.top and c != display.middle:
                display.bottom = c

        # Get nine, the only 6-segment number other than zero that shares two segments
        # with one.
        for digit in entry.patterns:
            if digit == display.zero:
                continue

            if digit.len == 6:
                var digitsInCommonWithOne = 0
                for c in digit:
                    if display.one.contains(c):
                        inc digitsInCommonWithOne

                if digitsInCommonWithOne == 2:
                    display.nine = digit
                    break

        # Get the top left segment. We found top, middle and bottom alread, so the segment
        # not shared between nine and one is the top left.
        for c in display.nine:
            if not display.one.contains(c) and c != display.top and c != display.middle and c != display.bottom:
                display.topLeft = c

        # Get five, the only remaining 5-segment digit that shares all its segments with nine.
        for digit in entry.patterns:
            if digit == display.three:
                continue

            if digit.len == 5:
                var digitsInCommonWithNine = 0
                for c in digit:
                    if display.nine.contains(c):
                        inc digitsInCommonWithNine

                if digitsInCommonWithNine == 5:
                    display.five = digit
        
        # Get the bottom right segment, the only segment of five that hasn't already been
        # deducted.
        for c in display.five:
            if c != display.top and c != display.middle and c != display.bottom and c != display.topLeft:
                display.bottomRight = c
                break

        # Get the top right segment, the only segment of one that hasn't already been deducted.
        for c in display.one:
            if c != display.bottomRight:
                display.topRight = c
                break

        # Get the last segment.
        for c in display.eight:
            if c != display.top and c != display.middle and c != display.bottom and c != display.topLeft and c != display.topRight and c != display.bottomRight:
                display.bottomLeft = c
                break

        # Get the remaining digits.
        for digit in entry.patterns:
            if digit.len == 5:
                if digit == display.three or digit == display.five:
                    continue
                display.two = digit
            if digit.len == 6:
                if digit == display.zero or digit == display.nine:
                    continue
                display.six = digit

        display.digits = @[display.zero, display.one, display.two, display.three, display.four, display.five, display.six, display.seven, display.eight, display.nine]
        
        var output = ""
        for digit in entry.output:
            for index, deductedDigit in display.digits:
                if digit.len != deductedDigit.len:
                    continue
                
                if allCharsInSet(digit, toSet(deductedDigit)):
                    output.add(intToStr(index))
                    break

        result += parseInt(output)  

let entries = loadData("day8/day8.txt")

echo "Part one: ", partOne(entries)
echo "Part two: ", partTwo(entries)
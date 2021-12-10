import std/algorithm
import std/tables

proc loadData(path: string): seq[string] =
    let lines: File = open(path)
    defer: lines.close()

    var line: string
    while readLine(lines, line):
        result.add(line)

const ScoresPartOne = {')': 3, ']': 57, '}': 1197, '>': 25137}.toTable
const ScoresPartTwo = {')': 1, ']': 2, '}': 3, '>': 4}.toTable
const BracketPairs = {'(': ')', '[': ']', '{': '}', '<': '>'}.toTable

proc dropCorrupted(lines: seq[string]): seq[string] =
    var incompleteLines: seq[string] = lines

    var indicesToRemove: seq[int] = @[]
    for idx, line in lines:
        var openedBlocks: seq[char] = @[]
        for c in line:
            if BracketPairs.hasKey(c):
                openedBlocks.add(c)
            else:
                if c != BracketPairs[openedBlocks[^1]]:
                    indicesToRemove.add(idx)
                    break
                else:
                    discard openedBlocks.pop()
    
    for idx in countdown(indicesToRemove.len - 1, 0, 1):
        incompleteLines.delete(indicesToRemove[idx])

    return incompleteLines

proc partOneAndTwo(lines: seq[string], partOne: static bool = true): int =
    when not partOne:
        var scores: seq[int] = @[]

    for line in lines:
        var openedBlocks: seq[char] = @[]
        for c in line:
            if BracketPairs.hasKey(c):
                openedBlocks.add(c)
            else:
                when partOne:
                    if c != BracketPairs[openedBlocks[^1]]:
                        result += ScoresPartOne[c]
                        break
                
                discard openedBlocks.pop()

        when not partOne:
            var score = 0
            for openingChar in reversed(openedBlocks):
                score = score * 5 + ScoresPartTwo[BracketPairs[openingChar]]
            scores.add(score)

    when not partOne:
        result = sorted(scores)[scores.len div 2]

let lines = loadData("day10/day10.txt")
let incompleteLines = dropCorrupted(lines)

echo "Part one: ", partOneAndTwo(lines)
echo "Part two: ", partOneAndTwo(incompleteLines, false)
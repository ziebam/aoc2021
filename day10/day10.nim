import std/tables

proc loadData(path: string): seq[string] =
    let lines: File = open(path)
    defer: lines.close()

    var line: string
    while readLine(lines, line):
        result.add(line)

const Scores = {')': 3, ']': 57, '}': 1197, '>': 25137}.toTable
const BracketPairs = {'(': ')', '[': ']', '{': '}', '<': '>'}.toTable

proc partOne(lines: seq[string]): int =
    for line in lines:
        var openedBlocks: seq[char] = @[]
        for c in line:
            if BracketPairs.hasKey(c):
                openedBlocks.add(c)
            else:
                if c != BracketPairs[openedBlocks[^1]]:
                    result += Scores[c]
                    break
                else:
                    discard openedBlocks.pop()

let lines = loadData("day10/day10.txt")

echo partOne(lines)
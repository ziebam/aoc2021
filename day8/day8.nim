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

proc partOne(entries: seq[Entry]): int =
    for entry in entries:
        for digit in entry.output:
            if digit.len == 2 or digit.len == 4 or digit.len == 3 or digit.len == 7:
                inc result

let entries = loadData("day8/day8.txt")

echo "Part one: ", partOne(entries)
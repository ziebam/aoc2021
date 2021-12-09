import std/sequtils
import std/strutils  

proc loadData(path: string): seq[seq[int]] =
    let heightMap: File = open(path)
    defer: heightMap.close()

    var row: string
    while readLine(heightMap, row):
        result.add(map(toSeq(row), proc(height: char): int = parseInt($height)))

proc partOne(heightMap: seq[seq[int]]): int =
    for yIdx, row in heightMap:
        for xIdx, height in row:
            var lowPoint = true

            # Check the left neighbor.
            if xIdx > 0:
                if height >= heightMap[yIdx][xIdx - 1]:
                    lowPoint = false
            
            # Check the top neighbor.
            if yIdx > 0:
                if height >= heightMap[yIdx - 1][xIdx]:
                    lowPoint = false
            
            # Check the right neighbor.
            if xIdx < row.len - 1:
                if height >= heightMap[yIdx][xIdX + 1]:
                    lowPoint = false

            # Check the bottom neighbor.
            if yIdx < heightMap.len - 1:
                if height >= heightMap[yIdx + 1][xIdx]:
                    lowPoint = false
            
            if lowPoint:
                result += height + 1

let heightMap = loadData("day9/day9.txt")

echo "Part one: ", partOne(heightMap)
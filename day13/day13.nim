import std/strutils

type
    Sheet = object
        width: int
        height: int
        dots: seq[tuple[x: int, y: int]]
        folds: seq[tuple[axis: string, coordinate: int]]


proc loadData(path: string): Sheet =
    let data: File = open(path)
    defer: data.close()
    
    var line: string
    while readLine(data, line):
        if line.len == 0:
            continue

        if not line.startsWith("fold"):
            let coords = line.split(",")

            let x = parseInt($coords[0])
            if x > result.width:
                result.width = x

            let y = parseInt($coords[1])
            if y > result.height:
                result.height = y

            result.dots.add((x: x, y: y))
        else:
            let fold = line.split("=")
            let parsedFold = (axis: $fold[0][^1], coordinate: parseInt(fold[1]))
            result.folds.add(parsedFold)

    inc result.width
    inc result.height

proc fold(sheet: Sheet, axis: string): Sheet =
    var newSheet: Sheet
    if axis == "y":
        newSheet.width = sheet.width
        newSheet.height = sheet.height div 2

        for dot in sheet.dots:
            # Dot in the top half.
            if dot.y < newSheet.height:
                if newSheet.dots.contains((x: dot.x, y: dot.y)):
                    continue
                else:
                    newSheet.dots.add(dot)
            # Dot in the bottom half.
            else:
                let newY = dot.y - 2 * (dot.y - newSheet.height)
                let newDot = (x: dot.x, y: newY)
                if newSheet.dots.contains(newDot):
                    continue
                else:
                    newSheet.dots.add(newDot)
    else:
        newSheet.width = sheet.width div 2
        newSheet.height = sheet.height

        for dot in sheet.dots:
            # Dot in the left half.
            if dot.x < newSheet.width:
                if newSheet.dots.contains((x: dot.x, y: dot.y)):
                    continue
                else:
                    newSheet.dots.add(dot)
            # Dot in the right half.
            else:
                let newX = dot.x - 2 * (dot.x - newSheet.width)
                let newDot = (x: newX, y: dot.y)
                if newSheet.dots.contains(newDot):
                    continue
                else:
                    newSheet.dots.add(newDot)

    return newSheet

proc printSheet(sheet: Sheet) =
    for y in 0..sheet.height - 1:
        var row = ""
        for x in 0..sheet.width - 1:
            if sheet.dots.contains((x: x, y: y)):
                row.add('#')
            else:
                row.add(' ')
        echo row

proc partOneAndTwo(sheet: Sheet, partOne: static bool = true): int =
    var newSheet = sheet

    when partOne:
        newSheet = fold(newSheet, sheet.folds[0].axis)
        result = newSheet.dots.len
    else:
        for fold in sheet.folds:
            newSheet = fold(newSheet, fold.axis)
        result = newSheet.dots.len
        printSheet(newSheet)

let sheet = loadData("day13/day13.txt")

echo "Part one: ", partOneAndTwo(sheet)
echo "Part two: ", partOneAndTwo(sheet, false)
import std/sequtils
import std/strutils

type
    Number = object
        value: int
        marked: bool

type
    Bingo = object
        drawnNumbers: seq[int]
        boards: seq[seq[seq[Number]]]


proc loadData(path: string): Bingo =
    let data: File = open(path)
    defer: data.close()

    var line: string
    var scoreLine: bool = true
    var grid: seq[seq[Number]] = @[]
    while readLine(data, line):
        if scoreLine:
            result.drawnNumbers.add(map(line.split(","), proc(drawnNumber: string): int = parseInt(drawnNumber)))
            scoreLine = false
        elif line.len > 0:
            grid.add(map(line.splitWhiteSpace(), proc(number: string): Number =
                    result.value = parseInt(number)
                    result.marked = false
                )
            )
        else:
            if grid.len > 0:
                result.boards.add(grid)
            grid = @[]

proc guess(board: seq[seq[Number]], drawnNumber: int): array[0..1, int] =
    result = [-1, -1]
    for y, row in board:
        for x, number in row:
            if number.value == drawnNumber:
                result = [y, x]

proc checkForWin(board: seq[seq[Number]]): bool =
    for row in board:
        if all(row, proc(x: Number): bool = x.marked):
            return true
    
    for columnNumber in 0 ..< board[0].len:
        var column: seq[Number]
        for row in board:
            column.add(row[columnNumber])
        if all(column, proc(x: Number): bool = x.marked):
            return true

    return false

proc calculateScore(board: seq[seq[Number]], drawnNumber: int): int =
    for row in board:
        for number in row:
            if not number.marked:
                result += number.value

    result *= drawnNumber


proc partOne(bingo: var Bingo): int =
    for drawnNumber in bingo.drawnNumbers:
        for board in bingo.boards.mitems:
            let numberInBoard = guess(board, drawnNumber)
            if numberInBoard != [-1, -1]:
                let y = numberInBoard[0]; let x = numberInBoard[1]
                board[y][x].marked = true
            if checkForWin(board):
                return calculateScore(board, drawnNumber)


type
    WinningBoard = object
        index: int
        score: int

proc partTwo(bingo: var Bingo): int = 
    var winningBoards: seq[WinningBoard]
    for drawnNumber in bingo.drawnNumbers:
        var index = 0
        for board in bingo.boards.mitems:
            let numberInBoard = guess(board, drawnNumber)
            if numberInBoard != [-1, -1]:
                let y = numberInBoard[0]; let x = numberInBoard[1]
                board[y][x].marked = true
            if checkForWin(board):
                let winningBoard = WinningBoard(index: index, score: calculateScore(board, drawnNumber))
                if any(winningBoards, proc(board: WinningBoard): bool = board.index == index):
                    inc index
                    continue
                winningBoards.add(winningBoard)
            inc index

    result = winningBoards[winningBoards.len - 1].score

var bingo = loadData("day4/day4.txt")

echo "Part one: ", partOne(bingo) # 58412
echo "Part two: ", partTwo(bingo) # 10030
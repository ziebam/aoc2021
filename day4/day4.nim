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
    let data: string = readFile(path)
    let lines: seq[string] = data.splitLines()

    for index, line in lines:
        if index == 0:
            result.drawnNumbers = map(line.split(","), proc(x: string): int = parseInt(x))
        elif index mod 6 == 1:
            continue
        elif index mod 6 == 2:
            var grid: seq[seq[Number]]
            for i in 0 .. 4:
                grid.add(map(lines[index + i].splitWhitespace(), proc(x: string): Number =
                        result.value = parseInt(x)
                        result.marked = false
                    )
                )
            result.boards.add(grid)

proc checkNumberInBoard(board: seq[seq[Number]], drawnNumber: int): array[0..1, int] =
    result = [-1, -1]
    for y, row in board:
        for x, number in row:
            if number.value == drawnNumber:
                result = [y, x]

proc checkIfIsWinning(board: seq[seq[Number]]): bool =
    for row in board:
        if all(row, proc(x: Number): bool = x.marked):
            return true
    
    for columnNumber in 0 .. board[0].len - 1:
        var column: seq[Number]
        for row in board:
            column.add(row[columnNumber])
        if all(column, proc(x: Number): bool = x.marked):
            return true

    return false

proc score(board: seq[seq[Number]], drawnNumber: int): int =
    var sumOfUnmarked: int = 0
    for row in board:
        for number in row:
            if not number.marked:
                sumOfUnmarked += number.value

    result = sumOfUnmarked * drawnNumber


proc partOne(bingo: var Bingo): int =
    for drawnNumber in bingo.drawnNumbers:
        for board in bingo.boards.mitems:
            let numberInBoard = checkNumberInBoard(board, drawnNumber)
            if numberInBoard != [-1, -1]:
                board[numberInBoard[0]][numberInBoard[1]].marked = true
            if checkIfIsWinning(board):
                return score(board, drawnNumber)


type
    WinningBoard = object
        index: int
        score: int

proc partTwo(bingo: var Bingo): int = 
    var winningBoards: seq[WinningBoard]
    for drawnNumber in bingo.drawnNumbers:
        var index = 0
        for board in bingo.boards.mitems:
            let numberInBoard = checkNumberInBoard(board, drawnNumber)
            if numberInBoard != [-1, -1]:
                board[numberInBoard[0]][numberInBoard[1]].marked = true
            if checkIfIsWinning(board):
                let winningBoard = WinningBoard(index: index, score: score(board, drawnNumber))
                if any(winningBoards, proc(board: WinningBoard): bool = board.index == index):
                    inc index
                    continue
                winningBoards.add(winningBoard)
            inc index

    result = winningBoards[winningBoards.len - 1].score

var bingo = loadData("day4/day4.txt")

echo "Part one: ", partOne(bingo)
echo "Part two: ", partTwo(bingo)
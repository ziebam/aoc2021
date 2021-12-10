import std/strutils

type
    Lanternfish = object
        timer: int

type
    Day = object
        amount: int

proc loadData(path: string): seq[Lanternfish] =
    let allLanternfish: seq[string] = readFile(path).split(",")

    for lanternfish in allLanternfish:
        result.add(Lanternfish(timer: parseInt(lanternfish)))

proc nextDay(lanternfishSeq: seq[Lanternfish]): seq[Lanternfish] =
    var lanternfishSeq = lanternfishSeq

    var howManyCreated = 0
    for lanternfish in lanternfishSeq.mitems:
        if lanternfish.timer == 0:
            lanternfish.timer = 6
            inc howManyCreated
        else:
            dec lanternfish.timer

    for i in 1..howManyCreated:
        lanternfishSeq.add(Lanternfish(timer: 8))

    return lanternfishSeq

proc partOneAndTwo(lanternfishSeq: seq[Lanternfish], days: int): int =
    var lanternfishSeq = lanternfishSeq

    var daysPassed: seq[Day] = @[]
    daysPassed.add(Day(amount: lanternfishSeq.len))

    for i in 1..8:
        lanternfishSeq = nextDay(lanternfishSeq)
        daysPassed.add(Day(amount: lanternfishSeq.len))

    #[
        After brute-forcing the solution for part one and playing around with
        the values, I noticed that the amount of lanternfish on a given
        day `n` is equal to the sum of the amount of lanternfish on days
        `n-9` and `n-7`. Therefore, we only need to calculate the initial
        amount and the amounts after the first 8 days to easily calculate
        the rest.
    ]#
    for n in 9..days:
        let amountAfterNextDay = daysPassed[n - 9].amount + daysPassed[n - 7].amount
        daysPassed.add(Day(amount: amountAfterNextDay))
    
    result = daysPassed[days].amount

var lanternfishSeq = loadData("day6/day6.txt")
echo "Part one: ", partOneAndTwo(lanternfishSeq, 80)
echo "Part two: ", partOneAndTwo(lanternfishSeq, 256)
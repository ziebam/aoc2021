import std/strutils

type
    Lanternfish = object
        timer: int

proc loadData(path: string): seq[Lanternfish] =
    let allLanternfish: seq[string] = readFile(path).split(",")

    for lanternfish in allLanternfish:
        result.add(Lanternfish(timer: parseInt(lanternfish)))

proc calculateDay(lanternfishSeq: var seq[Lanternfish]) =
    var howManyCreated = 0
    for lanternfish in lanternfishSeq.mitems:
        if lanternfish.timer == 0:
            lanternfish.timer = 6
            inc howManyCreated
        else:
            dec lanternfish.timer

    for i in 1..howManyCreated:
        lanternfishSeq.add(Lanternfish(timer: 8))
        

var lanternfishSeq = loadData("day6/day6.txt")
echo "Initial: ", lanternfishSeq.len
for i in 1..80:
    let before = lanternfishSeq.len
    calculateDay(lanternfishSeq)
    let after = lanternfishSeq.len
    echo "After day ", i, ": ", lanternfishSeq.len, " (+ ", after - before, ")"

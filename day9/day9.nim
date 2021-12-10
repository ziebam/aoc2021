import std/algorithm
import std/sequtils
import std/strutils  

type
    Point = object
        x: int
        y: int
        height: int
        visited: bool

proc loadData(path: string): seq[seq[Point]] =
    let rows: seq[string] = readFile(path).splitLines()

    for idx, row in rows:
        if row.len > 0:
            var heightMapRow: seq[Point] = @[]
            for jdx, point in row:
                heightMapRow.add(Point(x: jdx, y: idx, height: parseInt($point), visited: false))
            result.add(heightMapRow)

proc getNeighbors(point: Point, heightMap: var seq[seq[Point]]): seq[Point] =
    # Left neighbor.
    if point.x > 0:
        result.add(heightMap[point.y][point.x - 1])

    # Top neighbor.
    if point.y > 0:
        result.add(heightMap[point.y - 1][point.x])

    # Right neighbor.
    if point.x < heightMap[0].len - 1:
        result.add(heightMap[point.y][point.x + 1])

    # Bottom neighbor.
    if point.y < heightMap.len - 1:
        result.add(heightMap[point.y + 1][point.x])

proc partOne(heightMap: var seq[seq[Point]]): int =
    for row in heightMap:
        for point in row:
            var isLow = true

            let neighbors = getNeighbors(point, heightMap)
            for neighbor in neighbors:
                if neighbor.height <= point.height:
                    isLow = false
                    break

            if isLow:
                result += point.height + 1



proc findBasin(point: Point, heightMap: var seq[seq[Point]]): int =
    let neighbors = getNeighbors(point, heightMap)
    let basinNeighbors = filter(neighbors, proc(neighbor: Point): bool =
        not neighbor.visited
    ) 

    heightMap[point.y][point.x].visited = true
    for neighbor in basinNeighbors:
        if neighbor.height < 9:
            heightMap[neighbor.y][neighbor.x].visited = true

    if basinNeighbors.len == 0 or all(basinNeighbors, proc(neighbor: Point): bool = point.height == 9):
        return
    else:
        for neighbor in basinNeighbors:
            if neighbor.height < 9:
                result += findBasin(neighbor, heightMap) + 1

proc partTwo(heightMap: var seq[seq[Point]]): int =
    var basins: seq[int] = @[]

    for idx, row in heightMap:
        for jdx, point in row:
            if point.height == 9 or point.visited:
                continue
            else:
                basins.add(findBasin(point, heightMap) + 1)

    sort(basins, SortOrder.Descending)

    result = basins[0] * basins[1] * basins[2]

var heightMap = loadData("day9/day9.txt")

echo "Part one: ", partOne(heightMap)
echo "Part two: ", partTwo(heightMap)
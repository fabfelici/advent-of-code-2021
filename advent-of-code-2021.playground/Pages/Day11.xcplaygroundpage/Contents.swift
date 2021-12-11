import Foundation
import simd

let input = "day11".load()!
  .components(separatedBy: .newlines)
  .filter { !$0.isEmpty }
  .map(Array.init)
  .map {
    $0.map(String.init)
      .compactMap(Int.init)
  }

func solve1(input: [[Int]], steps: Int) -> Int {
  var mutable = input
  return (0..<steps).reduce(0) { acc, _ in
    acc + tick(input: &mutable)
  }
}

func solve2(input: [[Int]]) -> Int {
  var res = 1
  var mutable = input
  while tick(input: &mutable) != input.count * input.count {
    res += 1
  }
  return res
}

func tick(input: inout [[Int]]) -> Int {
  var flashed = Set<Point>()
  input.enumerated().forEach { row in
    input.enumerated().forEach { column in
      visit(point: .init(x: row.offset, y: column.offset), input: &input, flashed: &flashed)
    }
  }
  return flashed.count
}

typealias Point = SIMD2<Int>

let neighbors = [
  (-1, -1),
  (-1, 0),
  (-1, 1),
  (1, -1),
  (1, 0),
  (1, 1),
  (0, -1),
  (0, 1)
]
.map(Point.init(x:y:))

func visit(point: Point, input: inout [[Int]], flashed: inout Set<Point>) {
  guard !flashed.contains(point),
    (0..<input.count).contains(point.x),
    (0..<input.count).contains(point.y) else { return }
  guard input[point.x][point.y] == 9 else {
    input[point.x][point.y] += 1
    return
  }
  input[point.x][point.y] = 0
  flashed.insert(point)
  neighbors
    .map { point &+ $0 }
    .forEach {
      visit(point: $0, input: &input, flashed: &flashed)
    }
}

solve1(input: input, steps: 100)
solve2(input: input)

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
  let grid = Grid(input: input)
  return (0..<steps)
    .map { _ in grid.tick() }
    .reduce(0, +)
}

func solve2(input: [[Int]]) -> Int {
  var res = 1
  let grid = Grid(input: input)
  while grid.tick() != input.count * input.count {
    res += 1
  }
  return res
}

typealias Point = SIMD2<Int>

class Grid {

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

  private var input: [[Int]]
  private var flashed = Set<Point>()

  init(input: [[Int]]) {
    self.input = input
  }

  func tick() -> Int {
    flashed = Set<Point>()
    input.enumerated().flatMap { row in
      input.enumerated().map { column in
        Point(x: row.offset, y: column.offset)
      }
    }
    .forEach(visit)
    return flashed.count
  }

  private func visit(point: Point) {
    guard !flashed.contains(point),
      input.indices.contains(point.x),
      input.indices.contains(point.y) else { return }
    guard input[point.x][point.y] == 9 else {
      input[point.x][point.y] += 1
      return
    }
    input[point.x][point.y] = 0
    flashed.insert(point)
    neighbors
      .map { point &+ $0 }
      .forEach(visit)
  }
}

solve1(input: input, steps: 100)
solve2(input: input)

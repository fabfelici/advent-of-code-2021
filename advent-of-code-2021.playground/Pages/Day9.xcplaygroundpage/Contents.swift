import Foundation

let input = "day9".load()!
  .components(separatedBy: .newlines)
  .filter { !$0.isEmpty }
  .map(Array.init)
  .map {
    $0.map(String.init)
      .compactMap(Int.init)
  }

func solve1(input: [[Int]]) -> Int {
  var res = 0
  for i in 0..<input.count {
    for j in 0..<input[0].count {
      if isLowPoint(i: i, j: j, input: input) {
        res += input[i][j] + 1
      }
    }
  }
  return res
}

func isLowPoint(i: Int, j: Int, input: [[Int]]) -> Bool {
  guard input[i][j] != 9 else { return false }
  let left = j > 0 ? input[i][j - 1] : Int.max
  let right = j < input[0].count - 1 ? input[i][j + 1] : Int.max
  let up = i > 0 ? input[i - 1][j] : Int.max
  let down = i < input.count - 1 ? input[i + 1][j] : Int.max
  return [left, right, up, down].allSatisfy { input[i][j] < $0 }
}

func solve2(input: [[Int]]) -> Int {
  var mutable = input.map { $0.map(UInt8.init) }
  var basins = [0, 0, 0]
  var minIndex = 0
  for i in 0..<input.count {
    for j in 0..<input[0].count {
      let basin = basin(i: i, j: j, input: &mutable)
      if basin > basins[minIndex] {
        basins[minIndex] = basin
        minIndex = basins.firstIndex(of: basins.min()!)!
      }
    }
  }
  return basins.reduce(1, *)
}

func basin(i: Int, j: Int, input: inout [[UInt8]]) -> Int {
  guard input[i][j] != 9 else { return 0 }
  input[i][j] = 9
  return [
    j > 0 ? (i, j - 1) : nil,
    j < input[0].count - 1 ? (i, j + 1) : nil,
    i > 0 ? (i - 1, j) : nil,
    i < input.count - 1 ? (i + 1, j) : nil
  ]
  .compactMap {
    $0.map {
      basin(i: $0.0, j: $0.1, input: &input)
    }
  }
  .reduce(1, +)
}

solve1(input: input)
solve2(input: input)

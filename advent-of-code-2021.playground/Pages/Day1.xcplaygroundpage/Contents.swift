import Foundation

let input = "day1".load()
  .map {
    $0.components(separatedBy: .newlines)
      .compactMap(Int.init)
  }!

func countIncrements(_ input: [Int], window: Int) -> Int {
  zip(input, input.dropFirst(window))
    .reduce(into: 0) {
      $0 += $1.1 > $1.0 ? 1 : 0
    }
}

countIncrements(input, window: 1)
countIncrements(input, window: 3)

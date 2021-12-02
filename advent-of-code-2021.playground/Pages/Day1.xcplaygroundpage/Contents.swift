import Foundation

let day1 = "day1".load()
  .map {
    $0.components(separatedBy: "\n")
      .compactMap(Int.init)
  }!

func countIncrements(_ input: [Int], window: Int) -> Int {
  zip(input, input.dropFirst(window))
    .reduce(into: 0) {
      $0 += $1.1 > $1.0 ? 1 : 0
    }
}

print(countIncrements(day1, window: 1))
print(countIncrements(day1, window: 3))

import Foundation

let input = "day7".load()!.components(separatedBy: .punctuationCharacters).compactMap(Int.init)

func solve(positions: [Int]) -> Int {
  let counts = positions.reduce(into: [Int: Int]()) { $0[$1, default: 0] += 1 }
  guard let min = positions.min(), let max = positions.max() else { return 0 }
  var result = Int.max
  for chosen in min...max {
    let cost = cost(chosing: chosen, positions: counts, current: result)
    if cost != result {
      result = cost
    }
  }
  return result
}

func cost(chosing: Int, positions: [Int: Int], current: Int) -> Int {
  var result = 0
  for position in positions {
    let diff = sum(abs(position.key - chosing)) * position.value
    result += diff
    if result > current {
      return current
    }
  }
  return result
}

func sum(_ to: Int) -> Int {
  return (to * (to + 1) / 2)
}

print(solve(positions: input))

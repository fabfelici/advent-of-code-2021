import Foundation

let input = "day6".load()!.components(separatedBy: ",").compactMap {
  Int($0.trimmingCharacters(in: .newlines))
}

func brute(lanterns: [Int], days: Int) -> Int {
  var newLanters = lanterns
  for _ in 0..<days {
    var babies = [Int]()
    newLanters = newLanters.compactMap {
      if $0 == 0 {
        babies.append(8)
        return 6
      } else {
        return $0 - 1
      }
    }
    newLanters = newLanters + babies
  }
  return newLanters.count
}

func memoize<T: Hashable, U>(_ work: @escaping ((T) -> U, T) -> U) -> (T) -> U {
  var memo = [T: U]()
  
  func wrap(x: T) -> U {
    if let q = memo[x] { return q }
    let r = work(wrap, x)
    memo[x] = r
    return r
  }
  return wrap
}

struct Input: Hashable {
  let fish: Int
  let days: Int
}

let countFishes = memoize { (countFishes: (Input) -> Int, input: Input) -> Int in
  let daysLeft = input.days - input.fish - 1
  if input.days == 0 || daysLeft < 0 {
    return 0
  }
  let children = 1 + daysLeft / 7
  return children + (0..<children).reduce(0) { acc, fish in
    acc + countFishes(.init(fish: 8, days: daysLeft - (fish * 7)))
  }
}

func count(lanterns: [Int], days: Int) -> Int {
  lanterns.reduce(0) {
    return $0 + 1 + countFishes(.init(fish: $1, days: days))
  }
}

func solve(input: [Int], days: Int) -> Int {
  var counts = input.reduce(into: [0,0,0,0,0,0,0,0,0]) { $0[$1] += 1 }
  (0..<days)
    .map { $0 % 9 }
    .forEach { zeroIndex in
      counts[(zeroIndex + 7) % 9] += counts[zeroIndex]
    }
  return counts.reduce(0, +)
}

solve(input: input, days: 80)
solve(input: input, days: 256)

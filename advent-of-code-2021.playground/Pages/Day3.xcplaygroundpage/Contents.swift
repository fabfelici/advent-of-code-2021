import Foundation

let input = "day3".load()
  .map {
    $0.components(separatedBy: .newlines)
  }!

let test = [
  "00100",
  "11110",
  "10110",
  "10111",
  "10101",
  "01111",
  "00111",
  "11100",
  "10000",
  "11001",
  "00010",
  "01010"
]

struct State {
  var gamma: String = ""
  var epsilon: String = ""
  
  var result: Int {
    Int(gamma, radix: 2)! * Int(epsilon, radix: 2)!
  }
}

func solveFirst(_ input: [String]) -> Int {
  let ones = input.enumerated().reduce(into: [Int](), { acc, elem in
    if elem.offset == 0 {
      acc = Array(elem.element).map(String.init).compactMap(Int.init)
    }
    elem.element.enumerated().forEach {
      if $0.element == "1" {
        acc[$0.offset] += 1
      }
    }
  })
  let total = input.count
  return ones.reduce(into: State()) {
    if $1 > total / 2 {
      $0.gamma += "1"
      $0.epsilon += "0"
    } else {
      $0.gamma += "0"
      $0.epsilon += "1"
    }
  }.result
}

func filterOxigen(input: [String], at: Int) -> [String] {
  var ones = 0
  for item in input.enumerated() {
    let array = Array(item.element)
    if array[at] == "1" {
      ones += 1
    }
  }
  let zeroes = input.count - ones
  return input.filter {
    let array = Array($0)
    if ones >= zeroes {
      return array[at] == "1"
    } else {
      return array[at] == "0"
    }
  }
}

func filterCo2(input: [String], at: Int) -> [String] {
  var ones = 0
  for item in input.enumerated() {
    let array = Array(item.element)
    if array[at] == "1" {
      ones += 1
    }
  }
  let zeroes = input.count - ones
  return input.filter {
    let array = Array($0)
    if ones < zeroes {
      return array[at] == "1"
    } else {
      return array[at] == "0"
    }
  }
}

func solveSecond(_ input: [String]) -> Int {
  var result = input
  var i = 0
  while result.count != 1 {
    result = filterOxigen(input: result, at: i)
    i += 1
  }
  let oxigen = Int(result.first!, radix: 2)!
  result = input
  i = 0
  while result.count != 1 {
    result = filterCo2(input: result, at: i)
    i += 1
  }
  let co2 = Int(result.first!, radix: 2)!
  return oxigen * co2
}

solveFirst(input)
solveSecond(input.dropLast())

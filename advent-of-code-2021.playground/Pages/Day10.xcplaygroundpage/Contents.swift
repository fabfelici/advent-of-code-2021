import Foundation

let input = "day10".load()!
  .components(separatedBy: .newlines)
  .filter { !$0.isEmpty }

let scores = [
  ")" : 3,
  "]" : 57,
  "}" : 1197,
  ">" : 25137
]

let scores2 = [
  ")" : 1,
  "]" : 2,
  "}" : 3,
  ">" : 4
]

let openToClose = [
  "(" : ")",
  "[" : "]",
  "{" : "}",
  "<" : ">"
]

let closeToOpen = [
  ")" : "(",
  "]" : "[",
  "}" : "{",
  ">" : "<"
]

let openings = Set(["(", "[", "{", "<"])

func solve1(input: [String]) -> Int {
  var res = 0
  for s in input {
    if let illegal = illegalChar(input: s) {
      res += scores[illegal]!
    }
  }
  return res
}

func illegalChar(input: String) -> String? {
  var stack = [String]()
  for s in input {
    let string = String(s)
    if openToClose[string] == nil && openToClose[stack.last!] != string {
      return string
    } else if openToClose[string] != nil {
      stack.append(string)
    } else {
      stack.popLast()
    }
  }
  return nil
}

func solve2(input: [String]) -> Int {
  var res = [Int]()
  for s in input {
    if let missing = missingChars(input: s) {
      res.append(missing.reduce(0) {
        $0 * 5 + scores2[$1]!
      })
    }
  }
  return res.sorted()[res.count / 2]
}

func missingChars(input: String) -> [String]? {
  var stack = [String]()
  for s in input {
    let string = String(s)
    if openings.contains(string) {
      stack.append(string)
    } else {
      let opening = closeToOpen[string]!
      if stack.last == opening {
        stack.popLast()
      } else {
        return nil
      }
    }
  }
  return stack.compactMap { openToClose[$0] }.reversed()
}

solve1(input: input)
solve2(input: input)

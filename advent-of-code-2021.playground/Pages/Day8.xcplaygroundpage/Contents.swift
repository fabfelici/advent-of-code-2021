import Foundation

struct Display {
  let segments: Set<String>
  var is1: Bool { segments.count == 2 }
  var is4: Bool { segments.count == 4 }
  var is7: Bool { segments.count == 3 }
  var is8: Bool { segments.count == 7 }
}

struct Entry {
  let input: [Display]
  let output: [Display]

  var outputValue: Int {
    let one = input.first(where: \.is1)!.segments
    let four = input.first(where: \.is4)!.segments
    let stringValue = output.map { display -> Int in
      switch display.segments.count {
      case 2:
        return 1
      case 4:
        return 4
      case 3:
        return 7
      case 7:
        return 8
      default:
        let commonWithOne = display.segments.intersection(one).count
        let commonWithFour = display.segments.intersection(four).count
        switch (display.segments.count, commonWithOne, commonWithFour) {
        case (6, 2, 3):
          return 0
        case (5, 1, 2):
          return 2
        case (5, 2, 3):
          return 3
        case (5, 1, 3):
          return 5
        case (6, 1, 3):
          return 6
        case (6, 2, 4):
          return 9
        default:
          fatalError()
        }
      }
    }
    .map(String.init)
    .joined(separator: "")

    return Int(stringValue)!
  }
}

func parseEntry(input: String) -> Entry {
  let split = input.components(separatedBy: " | ")
  return Entry(
    input: parseDisplay(input: split[0]),
    output: parseDisplay(input: split[1]))
}

func parseDisplay(input: String) -> [Display] {
  input.components(separatedBy: .whitespaces)
    .map { Set($0.map(String.init)) }
    .map(Display.init)
}

func solve1(input: [Entry]) -> Int {
  input.reduce(0) {
    $0 + $1.output.filter {
      $0.is1 || $0.is4 || $0.is7 || $0.is8
    }.count
  }
}

func solve2(input: [Entry]) -> Int {
  input.map(\.outputValue).reduce(0, +)
}

let input = "day8".load()!.components(separatedBy: .newlines).filter { !$0.isEmpty }
  .map(parseEntry(input:))

solve1(input: input)
solve2(input: input)

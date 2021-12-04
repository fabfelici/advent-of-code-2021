import Foundation

let input = "day2".load()
  .map {
    $0.components(separatedBy: .newlines)
      .map {
        $0.components(separatedBy: .whitespaces)
      }
      .compactMap(parseCommand)
  }!

func parseCommand(_ input: [String]) -> Command? {
  guard input.count == 2, let value = Int(input[1]) else { return nil }
  return CommandType(rawValue: input[0]).map {
    switch $0 {
    case .forward:
      return Forward(value: value)
    case .up:
      return Up(value: value)
    case .down:
      return Down(value: value)
    }
  }
}

enum CommandType: String {
  case forward
  case up
  case down
}

struct State {
  var horizontal: Int = 0
  var depth: Int = 0
  var aim: Int = 0

  var score: Int {
    horizontal * depth
  }
}

protocol Command {
  func execute(on: inout State, aiming: Bool)
}

struct Forward: Command {
  let value: Int

  func execute(on state: inout State, aiming: Bool) {
    state.horizontal += value
    if aiming {
      state.depth += state.aim * value
    }
  }
}

struct Up: Command {
  let value: Int

  func execute(on state: inout State, aiming: Bool) {
    if aiming {
      state.aim -= value
    } else {
      state.depth -= value
    }
  }
}

struct Down: Command {
  let value: Int

  func execute(on state: inout State, aiming: Bool) {
    if aiming {
      state.aim += value
    } else {
      state.depth += value
    }
  }
}

func solve(_ input: [Command], aiming: Bool) -> Int {
  input.reduce(into: State()) {
    $1.execute(on: &$0, aiming: aiming)
  }.score
}

solve(input, aiming: false)
solve(input, aiming: true)

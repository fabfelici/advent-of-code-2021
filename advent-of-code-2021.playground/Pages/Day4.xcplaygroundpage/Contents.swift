import Foundation

class BingoNode {
  let value: Int
  var marked: Bool = false
  
  init(value: Int) {
    self.value = value
  }
}

class BingoBoard {

  let grid: [[BingoNode]]

  private lazy var valueToCoordinates: [Int: (Int, Int)] = {
    grid.enumerated()
      .reduce(into: [Int: (Int, Int)]()) { acc, row in
        acc.merge(
          row.element
            .enumerated()
            .reduce(into: [Int: (Int, Int)]()) {
              $0[$1.element.value] = (row.offset, $1.offset)
            },
          uniquingKeysWith: { $1 }
        )
      }
  }()
  
  private var score: Int {
    grid.reduce(0, {
      $0 + $1
        .filter { !$0.marked }
        .reduce(0, {
          $0 + $1.value
        })
    })
  }
  
  private var won = false

  init(grid: [[BingoNode]]) {
    self.grid = grid
  }

  func check(value: Int) -> Int? {
    guard !won else { return nil }
    return valueToCoordinates[value].flatMap { coords in
      grid[coords.0][coords.1].marked = true
      won = checkWin(from: coords)
      return won ? score * value : nil
    }
  }

  private func checkWin(from coords: (Int, Int)) -> Bool {
    let row = grid[coords.0]
    let column = (0..<grid.count).map { grid[$0][coords.1] }
    return row.allSatisfy(\.marked) || column.allSatisfy(\.marked)
  }
}

class BingoGame {

  let numbers: [Int]
  let boards: [BingoBoard]

  init(numbers: [Int], boards: [BingoBoard]) {
    self.numbers = numbers
    self.boards = boards
  }

  func play() -> Int? {
    for number in numbers {
      for board in boards {
        if let win = board.check(value: number) {
          return win
        }
      }
    }
    return nil
  }

  func play2() -> Int? {
    var scores = [Int]()
    for number in numbers {
      for board in boards {
        if let win = board.check(value: number) {
          scores.append(win)
        }
      }
    }
    return scores.last
  }
}

func parse(game: String) -> BingoGame? {
  let numbersAndBoards = game.components(separatedBy: "\n\n")
  let numbers = numbersAndBoards.first?
    .components(separatedBy: .punctuationCharacters)
    .compactMap(Int.init)
  return numbers
    .map {
      BingoGame(
        numbers: $0,
        boards: numbersAndBoards.dropFirst().map(parse(board:))
      )
    }
}

func parse(board: String) -> BingoBoard {
  .init(
    grid: board
      .components(separatedBy: .newlines)
      .filter { !$0.isEmpty }
      .map(parse(row:))
  )
}

func parse(row: String) -> [BingoNode] {
  row
    .components(separatedBy: .whitespaces)
    .compactMap(Int.init)
    .map(BingoNode.init)
}


let game = "day4".load().flatMap(parse(game:))
game?.play()
game?.play2()

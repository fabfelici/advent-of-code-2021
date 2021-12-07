import Foundation

func parse(row: String) -> Vent {
  let components = row.components(separatedBy: " -> ")
  return .init(
    start: parse(point: components[0]),
    finish: parse(point: components[1])
  )
}

func parse(point: String) -> Point {
  let array = point.components(separatedBy: .punctuationCharacters)
  return Point(x: Int(array[0])!, y: Int(array[1])!)
}

struct Vent {
  let start: Point
  let finish: Point
}

struct Point: Hashable {
  let x: Int
  let y: Int
}

let input = "day5".load()!
let rows = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
let vents = rows.map(parse(row:))

func solve1(input: [Vent]) -> Int {
  var counts = [Point: Int]()
  for vent in input.filter({$0.start.x == $0.finish.x || $0.start.y == $0.finish.y}) {
    var start: Int
    var end: Int
    var maintain: Int
    var maintainX: Bool
    if vent.start.x != vent.finish.x {
      start = min(vent.start.x, vent.finish.x)
      end = max(vent.start.x, vent.finish.x)
      maintain = vent.finish.y
      maintainX = false
    } else {
      start = min(vent.start.y, vent.finish.y)
      end = max(vent.start.y, vent.finish.y)
      maintain = vent.finish.x
      maintainX = true
    }
    for i in start...end {
      counts[
        .init(
          x: maintainX ? maintain: i,
          y: maintainX ? i: maintain
        ),
        default: 0] += 1
    }
  }
  return counts.values.filter {
    $0 >= 2
  }.count
}

func solve2(input: [Vent]) -> Int {
  var counts = [Point: Int]()
  for vent in input {
    let isDiagonal = vent.start.x != vent.finish.x && vent.start.y != vent.finish.y
    
    if isDiagonal {
      let minX = min(vent.start.x, vent.finish.x)
      let maxX = max(vent.start.x, vent.finish.x)
      let steps = maxX - minX
      let increaseX = vent.start.x < vent.finish.x
      let increaseY = vent.start.y < vent.finish.y
      for i in 0...steps {
        counts[
         .init(
           x: vent.start.x + (increaseX ? i : -i),
           y: vent.start.y + (increaseY ? i : -i)
         ),
         default: 0] += 1
      }
    } else {
      var start: Int
      var end: Int
      var maintain: Int
      var maintainX: Bool
      if vent.start.x != vent.finish.x {
        start = min(vent.start.x, vent.finish.x)
        end = max(vent.start.x, vent.finish.x)
        maintain = vent.finish.y
        maintainX = false
      } else {
        start = min(vent.start.y, vent.finish.y)
        end = max(vent.start.y, vent.finish.y)
        maintain = vent.finish.x
        maintainX = true
      }
      for i in start...end {
        counts[
          .init(
            x: maintainX ? maintain: i,
            y: maintainX ? i: maintain
          ),
          default: 0] += 1
      }
    }
  }
  return counts.values.filter {
    $0 >= 2
  }.count
}

solve1(input: vents)
solve2(input: vents)

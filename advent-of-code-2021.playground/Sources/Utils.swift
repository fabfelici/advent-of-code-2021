import Foundation

public extension String {
  func load() -> String? {
    return try? Bundle.main.url(forResource: self, withExtension: "txt")
      .flatMap(String.init(contentsOf:))
  }
}
